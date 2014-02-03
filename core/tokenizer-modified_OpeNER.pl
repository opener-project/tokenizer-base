#!/usr/bin/perl -w

# Sample Tokenizer
# written by Josh Schroeder, based on code by Philipp Koehn
# changed by Haritz Arzelus (#2012/11/19) Aitor García and Andoni Azpeitia

use FindBin;

use lib "$FindBin::Bin/lib";

use Encode::Guess;
use Time::Stamp;

require "$FindBin::Bin"."/text-fixer.pl";
require "$FindBin::Bin"."/split-sentences.pl";
require "$FindBin::Bin"."/tokenizer.pl";
require "$FindBin::Bin"."/load-prefixes.pl";

no warnings;
use encoding 'utf8';

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#use FindBin qw($Bin);
#use strict;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#use Time::HiRes;

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#my $mydir = "$Bin/nonbreaking_prefixes";
#changed by me (aitor) to point to the directory of the script, instead of current working directory
#my $mydir = "$FindBin::Bin"."/nonbreaking_prefixes";
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#my $start = [ Time::HiRes::gettimeofday( ) ];

#while (@ARGV) {
#	$_ = shift;
#	/^-l$/ && ($language = shift, next);
#	/^-q$/ && ($QUIET = 1, next);
#	/^-h$/ && ($HELP = 1, next);
#}

#if (!$QUIET) {
#	print STDERR "Tokenizer v3\n";
#	print STDERR "Language: $language\n";
#}

#argument variables
my %NONBREAKING_PREFIX = ();
my $SENT_VERSION = "0.0.1";
my $TOK_VERSION = "1.0.1";
my $FILE = "";
my $LANGUAGE;
my $NOTIMESTAMP = 0;
my $HELP = 0;

my $SUBSTITUTE = "####";

if (checkArguments(\@ARGV) == 1) {
  if ($HELP == 1) {
    displayHelp();
    exit 0;
  }
}
else {
  displayHelp();
  exit -1;
}

# load nonbreaking prefixes and init both tokenizer and sentence splitter
%NONBREAKING_PREFIX = %{ &load_prefixes($LANGUAGE) };

&init_text_fixer($LANGUAGE, \%NONBREAKING_PREFIX);
&init_sentence_splitter($LANGUAGE, \%NONBREAKING_PREFIX);
&init_tokenizer($LANGUAGE, \%NONBREAKING_PREFIX);


# get timestamp
my $timestamp = "0000-00-00T00:00:00Z";
if ($NOTIMESTAMP == 0) {
  $timestamp = timestamp();
}

# print kaf header
if ($FILE ne "") {

  my $i = rindex($FILE, ".");
  my $filename = substr($FILE, 0, $i);
  my $filetype = uc(substr($FILE, $i+1, length($FILE)-length($filename)-1));
  print_kafheader($filename, $filetype, $timestamp, $LANGUAGE);
}
else {
  print_kafheader_nofile($timestamp);
}
print "  <text>\n";

# process text
my $sent = 1;
my $para = 1;
my $counter = 0;
my $charcount = 0;
while(<STDIN>) {

  if (/^<.+>$/ || /^\s*$/) {
    #don't try to tokenize XML/HTML tag lines
    chomp($_);
    #print $_;
  }
  else {
    
    #fix input text
    my $text = &fix_text($_);

    #split sentences
    my @sentences = &split_sentences($text);
    my $index = 0;
    my $last_index = 0;
    my $last_offset = -1;
    my $j = 0;
    foreach my $sentence (@sentences) {
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      #print &tokenize($_);
      $tok = tokenize($sentence);
      #tokenize some especial characters
      $tok =~ s/([|||||«|»])([^ ])/$1 $2/g;
      $tok =~ s/([^ ])([|||||«|»])/$1 $2/g;
      #detokenize tokens with @
      $tok =~ s/ @ /@/g;
      #detokenize some tokens with '
      $tok =~ s/([DLNO]) '/$1'/g;
      #$tok =~ s/([DLNO])' /$1'/g;      cambiado por Andoni Azpeitia Vicomtech    L' armée => L'armée
      $tok =~ s/o( )?'( )?clock/o'clock/g;
      $tok =~ s/ ' ([0-9][0-9]s)/ '$1/g;
      #detokenize some time formats
      $tok =~ s/([0-9][0-9]*) ' ([0-9][0-9]*) "/$1'$2"/g;
      $tok =~ s/([0-9][0-9]*) : ([0-9][0-9])/$1:$2/g;
      #detokenize some height formats
      $tok =~ s/([0-9][0-9]*) ' ([0-9][0-9])/$1'$2/g;
      #tokenize two dashes
      $tok =~ s/\-\-/ \-\-/g;
      #correct ºC tokenization
      $tok =~ s/([0-9])( )?º( )?C/$1 ºC/g;
      $tok =~ s/ +/ /g;
#<<<<<<<<<<<<<<<
      #changed by me (aitor) to format the output as a kind of dummy KAF format
      chomp($tok);

      @tokens = split(/ /, $tok);

      my $i = 0;
      foreach my $token (@tokens) {
	
        $index = index($_, $token, $last_index);
	
	#if token was substituted at tokenization, be careful
        if ( $token eq "\"".$SUBSTITUTE ) {
          $index = index($_, "'", $last_index);
	  $token = "\"";
        }
        elsif ( $token eq "\'".$SUBSTITUTE ) {
          $index = index($_, "`", $last_index);
	  $token = "\'";
        }

        my $offset = $charcount + $index;
	#if input text has been preprocesed and tokens has been moved ( 'hello.' => 'hello'.),
        # offset of the "." char is at the left of "'" char not at the right
        if ( $index==-1 ) {
	  $index = index($_, $token, $last_index-2);
	  $offset = $charcount + $index;
        }
	#make sure that found offset is not an offset of the same char at other position so,
	# find offset of the next token and compare
	# next token is at the same sentence
	elsif ( $i<scalar(@tokens)-1 ) {
	  my $next_token_index = $charcount + index($_, $tokens[$i+1], length($token) + $last_index-1);
          if ( $index==-1 || ($next_token_index > -1 && $offset > $next_token_index+1) ) {
	    $index = index($_, $token, $last_index-2);
	    $offset = $charcount + $index;
	  }
	}
	#make sure that found offset is not an offset of the same char at other position so,
	# find offset of the next token and compare
	# next token is at next sentence
	elsif ( $sent < scalar(@sentences)) {
	  my $next_sentence = $sentences[$j+1];
	  $next_sentence = &tokenize($next_sentence);
	  my @next_tokens = split(/ /, $next_sentence);
          my $next_token = $next_tokens[0];
	  my $next_token_index = $charcount + index($_, $next_token, length($token) + $last_index-1);
	  if ( ($next_token_index > -1 && $offset > $next_token_index+1) ) {
	    $index = index($_, $token, $last_index-2);
	    $offset = $charcount + $index;
	  }
	}
	
	my $token_length = length($token);
	&print_line(++$counter, $sent, $para, $offset, $token_length, $token);
        
        $last_index = $index + $token_length;
	$last_offset = $offset;
        $i++;
      }

#>>>>>>>>>>>>>>>
      $j++;
      $sent++;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    }#foreach sentence

    if (length($_) == 0) {
      $charcount += 1;
    }
    else {
      $charcount += length($_);
    }
    $para++;
  }
}#while(<STDIN>)
print "  </text>\n";
print "</KAF>\n";


#prints word form in kaf format
sub print_line {

  my $wid=shift(@_);
  my $sent=shift(@_);
  my $para=shift(@_);
  my $offset=shift(@_);
  my $length=shift(@_);
  my $token=shift(@_);

  print "    <wf wid=\"w".$wid."\" sent=\"".$sent."\" para=\"".$para."\" offset=\"".$offset."\" length=\"". $length."\"><![CDATA[".$token."]]></wf>\n";
}

#prints kaf xml fomat header
sub print_kafheader {
  my $filename = shift(@_);
  my $filetype = shift(@_);
  my $timestamp = shift(@_);
  my $LANGUAGE = shift(@_);
  print "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n";
  print "<KAF xml:lang=\"".$LANGUAGE."\" version=\"v1.opener\">\n";
  print "  <kafHeader>\n";
  print "    <fileDesc filename=\"".$filename."\" filetype=\"".$filetype."\" />\n";
  print "    <linguisticProcessors layer=\"text\">\n";
  print "      <lp name=\"opener-sentence-splitter-$LANGUAGE\" version=\"".$SENT_VERSION."\" timestamp=\"".$timestamp."\"/>\n";
  print "      <lp name=\"opener-tokenizer-$LANGUAGE\" version=\"".$TOK_VERSION."\" timestamp=\"".$timestamp."\"/>\n";
  print "    </linguisticProcessors>\n";
  print "  </kafHeader>\n";
}
#prints kaf xml fomat header whithout filedesc
sub print_kafheader_nofile {
  my $timestamp = shift(@_);
  print "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n";
  print "<KAF xml:lang=\"".$LANGUAGE."\" version=\"v1.opener\">\n";
  print "  <kafHeader>\n";
  print "    <fileDesc />\n";
  print "    <linguisticProcessors layer=\"text\">\n";
  print "      <lp name=\"opener-sentence-splitter-$LANGUAGE\" version=\"".$SENT_VERSION."\" timestamp=\"".$timestamp."\"/>\n";
  print "      <lp name=\"opener-tokenizer-$LANGUAGE\" version=\"".$TOK_VERSION."\" timestamp=\"".$timestamp."\"/>\n";
  print "    </linguisticProcessors>\n";
  print "  </kafHeader>\n";
}

sub checkArguments {
  my $argref = shift(@_);
  my @arg = @ { $argref };
  my $correct = 1;
  if (scalar(@arg) > 0) {
    for (my $i = 0; $i < scalar(@arg); $i++) {
      if (lc($arg[$i]) eq "-l") {
        if(scalar(@arg) > $i+1) {
          if (lc($arg[$i+1]) ne "-t" && lc($arg[$i+1]) ne "-f" && lc($arg[$i+1]) ne "-l" && checkLanguage($arg[$i+1]) == 1) {
            $LANGUAGE = $arg[$i+1];
          }
          else {
            $correct = 0;
            print STDERR "Error: language \"".$arg[$i+1]."\" not supported\n";
          }
        }
        else {
          $correct = 0;
          print STDERR "Error: language don't specified\n";
        }
      }
      elsif (lc($arg[$i]) eq "-f") {
        if(scalar(@arg) > $i+1 && lc($arg[$i+1]) ne "-t" && lc($arg[$i+1]) ne "-f" && lc($arg[$i+1]) ne "-l") {
          $FILE = $arg[$i+1];
        }
        else {
          $correct = 0;
          print STDERR "Error: file's name empty\n";
        }
      }
      elsif (lc($arg[$i]) eq "-t") {
        $NOTIMESTAMP = 1;
      }
      elsif (lc($arg[$i]) eq "--help") {
        $HELP = 1;
      }
    }
    if ($LANGUAGE ne "") {
      return $correct;
    }
    else {
      print STDERR "Error: language don't specified\n";
      return 0;
    }
  }
  else {
    print STDERR "Error: language don't specified\n";
    return 0
  }
}

sub checkLanguage {
  my $language = shift(@_);
  if ($language eq "en") { return 1; }
  elsif ($language eq "es") { return 1; }
  elsif ($language eq "fr") { return 1; }
  elsif ($language eq "it") { return 1; }
  elsif ($language eq "de") { return 1; }
  elsif ($language eq "nl") { return 1; }
  else { return -1 }
}

sub displayHelp {
  print STDERR "\nThis aplication reads a text from standard input in order to tokenize.\n";
  print STDERR "Aplication arguments:\n";
  print STDERR "-l, --language  input text's language.\n";
  print STDERR "-f, --filename  (optional) file's name.\n";
  print STDERR "-t,             (optional) o use static timestamp at KAF header.\n";
  print STDERR "--help,         outputs aplication help.\n";
}

sub timestamp {
  my $time = Time::Stamp::gmstamp();
  return $time;
}

sub detect_encoding {
  my $file = shift(@_);
  my $enc;
  open(FILE,$file);
  binmode(FILE);
  if(read(FILE,my $filestart, 500)) {
    $enc = guess_encoding($filestart);
  }
  close(FILE);
  if (ref($enc)) {
    return $enc->name;
  }
  else {
    return "utf8";
  }
}

