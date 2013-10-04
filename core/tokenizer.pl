#!/usr/bin/perl -w

use FindBin;
use utf8;

my $mydir = "$FindBin::Bin"."/nonbreaking_prefixes";
my %NONBREAKING_PREFIX = ();
my $language;

sub tokenize {
	my($text) = @_;
	chomp($text);
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#tokenize the dashes of the beginning of the lines
	$text =~ s/^\-([^ ])/\- $1/g;

	# turn  into '
	$text =~ s/Ž/\'/g;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	$text = " $text ";

	# seperate out all "other" special characters
	$text =~ s/([^\p{IsAlnum}\s\.\'\`\,\-\’])/ $1 /g;
        #$text =~ s/([^\p{IsAlnum}\s\.\'\`\,\-])/ $1 /g;
	#multi-dots stay together
	$text =~ s/\.([\.]+)/ DOTMULTI$1/g;
	while($text =~ /DOTMULTI\./) {
		$text =~ s/DOTMULTI\.([^\.])/DOTDOTMULTI $1/g;
		$text =~ s/DOTMULTI\./DOTDOTMULTI/g;
	}
	# seperate out "," except if within numbers (5,300)
	$text =~ s/([^\p{IsN}])[,]([^\p{IsN}])/$1 , $2/g;
	# separate , pre and post number
	$text =~ s/([\p{IsN}])[,]([^\p{IsN}])/$1 , $2/g;
	$text =~ s/([^\p{IsN}])[,]([\p{IsN}])/$1 , $2/g;

	# turn `into '
	$text =~ s/\`/\'/g;

	#turn '' into "
	$text =~ s/\'\'/ \" /g;
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#tokenize the words like '05-'06
	$text =~ s/(['|’])([0-9][0-9])\-(['|’])([0-9][0-9])/$1$2 - $3$4/g;
	#replace the ' with ### to don't tokenize words like '90
	$text =~ s/ ['|’]([0-9][0-9])/ ###$1/g;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	if ($language eq "en") {
		#split contractions right
		$text =~ s/([^\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([^\p{IsAlpha}\p{IsN}])(['|’])([\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([\p{IsAlpha}])/$1 $2$3/g;
		#special case for "1990's"
		$text =~ s/([\p{IsN}])(['|’])([s])/$1 $2$3/g;
	} elsif (($language eq "fr") or ($language eq "it")) {
		#split contractions left
		$text =~ s/([^\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([^\p{IsAlpha}])(['|’])([\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([\p{IsAlpha}])/$1$2 $3/g;
	} else {
		$text =~ s/\'/ \' /g;
	}
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#replace the ### with ' to tokenize words like '90
	$text =~ s/ ###([0-9][0-9])/ '$1/g;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	#word token method
	my @words = split(/\s/,$text);
	$text = "";
	for (my $i=0;$i<(scalar(@words));$i++) {
		my $word = $words[$i];
		if ( $word =~ /^(\S+)\.$/) {
			my $pre = $1;
			if (($pre =~ /\./ && $pre =~ /\p{IsAlpha}/) || ($NONBREAKING_PREFIX{$pre} && $NONBREAKING_PREFIX{$pre}==1) || ($i<scalar(@words)-1 && ($words[$i+1] =~ /^[\p{IsLower}]/))) {
				#no change
			} elsif (($NONBREAKING_PREFIX{$pre} && $NONBREAKING_PREFIX{$pre}==2) && ($i<scalar(@words)-1 && ($words[$i+1] =~ /^[0-9]+/))) {
				#no change
			} else {
				$word = $pre." .";
			}
		}
		$text .= $word." ";
	}

	# clean up extraneous spaces
	$text =~ s/ +/ /g;
	$text =~ s/^ //g;
	$text =~ s/ $//g;

	#restore multi-dots
	while($text =~ /DOTDOTMULTI/) {
		$text =~ s/DOTDOTMULTI/DOTMULTI./g;
	}
	$text =~ s/DOTMULTI/./g;

	#ensure final line break
	$text .= "\n" unless $text =~ /\n$/;
	return $text;
}

sub load_prefixes {
	$language = shift(@_);

	my $prefixfile = "$mydir/nonbreaking_prefix.$language";

	#default back to English if we don't have a language-specific prefix file
	if (!(-e $prefixfile)) {
		$prefixfile = "$mydir/nonbreaking_prefix.en";
		print STDERR "WARNING: No known abbreviations for language '$language', attempting fall-back to English version...\n";
		die ("ERROR: No abbreviations files found in $mydir\n") unless (-e $prefixfile);
	}

	if (-e "$prefixfile") {
		open(PREFIX, "<:utf8", "$prefixfile");
		while (<PREFIX>) {
			my $item = $_;
			chomp($item);
			if (($item) && (substr($item,0,1) ne "#")) {
				if ($item =~ /(.*)[\s]+(\#NUMERIC_ONLY\#)/) {
					$NONBREAKING_PREFIX{$1} = 2;
				} else {
					$NONBREAKING_PREFIX{$item} = 1;
				}
			}
		}
		close(PREFIX);
	}
}

1;
