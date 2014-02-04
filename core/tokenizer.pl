#!/usr/bin/perl -w

# This class tokenizes input sentence
# Implements Moses tokenizer and it has been modified
# for OpeNER by Aitor García and Andoni Azpeitia

use FindBin;
use utf8;

my %NONBREAKING_PREFIX = ();
my $LANGUAGE;
my $SUBSTITUTE = "####";

sub init_tokenizer {
	$LANGUAGE = shift(@_);
	%NONBREAKING_PREFIX = %{ shift(@_) };
}

sub tokenize {
	
	my($text) = shift(@_);
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
	$text =~ s/\`/\'$SUBSTITUTE/g;

	#turn '' into "
	$text =~ s/\'\'/ \"$SUBSTITUTE /g;
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#tokenize the words like '05-'06
	$text =~ s/(['|’])([0-9][0-9])\-(['|’])([0-9][0-9])/$1$2 - $3$4/g;
	#replace the ' with ### to don't tokenize words like '90
	$text =~ s/ ['|’]([0-9][0-9])/ ###$1/g;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	if ($LANGUAGE eq "en") {
		#split contractions right
		$text =~ s/([^\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([^\p{IsAlpha}\p{IsN}])(['|’])([\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([\p{IsAlpha}])/$1 $2$3/g;
		#special case for "1990's"
		$text =~ s/([\p{IsN}])(['|’])([s])/$1 $2$3/g;
	} elsif ($LANGUAGE eq "fr") {
		#split contractions left
		$text =~ s/([^\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([^\p{IsAlpha}])(['|’])([\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([\p{IsAlpha}])/$1$2 $3/g;
	} elsif ($LANGUAGE eq "it") {
		#split contractions left
		$text =~ s/([^\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([^\p{IsAlpha}])(['|’])([\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([^\p{IsAlpha}])/$1 $2 $3/g;
		$text =~ s/([\p{IsAlpha}])(['|’])([\p{IsAlpha}])/$1$2 $3/g;
		$text =~ s/([^\p{IsAlpha}\p{IsN}]po) (['|’])([^\p{IsAlpha}])/$1$2 $3/g; # rule for "po'"
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

	#detokenize URLs
	$text = &detokenize_urls($text);
	
	#ensure final line break
	$text .= "\n" unless $text =~ /\n$/;
	return $text;
}

sub detokenize_urls {

	my($text) = shift(@_);

	$text =~ s/(\w{3,9}) : \/ \/ /$1:\/\//g;
	my $URL_HEAD_PATTERN = "\\w{3,9}:\\/\\/|www";
	my $URL_BODY_PATTERN = "\\w\\d\\.\\/\\-\\#;:=\\+\\?&_";
	my $URL_SPECIAL_PATTERN = "\\/|\\?|=|&|\\+|_|\\#|:|;|\\-";
	while ( $text =~ /($URL_HEAD_PATTERN)[$URL_BODY_PATTERN]+ ($URL_SPECIAL_PATTERN)/ ) {
		$text =~ s/($URL_HEAD_PATTERN)([$URL_BODY_PATTERN]+) ($URL_SPECIAL_PATTERN) {0,1}(($URL_SPECIAL_PATTERN? {0,1})+)/$1.$2.$3.&clean($4)/eg;
	}
	
	return $text;
}

sub clean {
	my $text = shift(@_);
	$text = s/ //g;
	return $text;
}

1;
