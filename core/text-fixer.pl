#!/usr/bin/perl -w

# reads input text and fixes some mistakes
# developed by Andoni Azpeitia

use utf8;

my %NONBREAKING_PREFIX = ();
my $LANGUAGE;

my $START_QUOTES_REGEX = "“|‘|«|‹";
my $END_QUOTES_REGEX = "”|’|»|›";

sub init_text_fixer {
	$LANGUAGE = shift(@_);
	%NONBREAKING_PREFIX = %{ shift(@_) };
}

sub fix_text {

	my($text) = shift(@_);
	
	chomp($text);
	
	#fix encoding
	$text = &fix_encoding($text);
	

	#word token method
	my @words = split(/\s/,$text);
	$text = "";
	for (my $i=0;$i<(scalar(@words));$i++) {
		my $word = $words[$i];
		#Kumi Naidoo said: “bla bla bla.”Bla bla => Kumi Naidoo said: “bla bla bla”. Bla bla
		
		if ( $word =~ /^(\S+)\.($END_QUOTES_REGEX)($START_QUOTES_REGEX*\p{IsUpper}\S*)$/ ) {
			my $pre = $1;
			my $quote = $2;
			my $post = $3;
			
			$word = $pre.$quote.". ".$post;
		}
		#to a "breach of trust." A German => to a "breach of trust". A German
		elsif ( $word =~ /^(\S+)\.($END_QUOTES_REGEX)$/ ) {
			my $pre = $1;
			my $quote = $2;
			if ( ($i<scalar(@words)-1 && $words[$i+1] =~ /^$START_QUOTES_REGEX*\p{IsUpper}\S*$/ )) {
				$word = $pre.$quote.".";
			}
			elsif ($i==scalar(@words)-1) {
				$word = $pre.$quote.".";
			}
		}
		#OpeNER is amazing.OpeNER is cool. => OpeNER is amazing. OpeNER is cool.
		elsif ( $word =~ /^(\S+)\.(\S+)$/) {
			my $pre = $1;
			my $post = $2;
			if (($pre =~ /\./ && $pre =~ /\p{IsAlpha}/) || ($NONBREAKING_PREFIX{$pre} && $NONBREAKING_PREFIX{$pre}==1) || ($post =~ /^[\p{IsLower}]/) ) {
				#no change
			} elsif (($NONBREAKING_PREFIX{$pre} && $NONBREAKING_PREFIX{$pre}==2) &&  ($post =~ /^[0-9]+/) ) {
				#no change
			} else {
				$word = $pre.". ".$post;
			}
		}
		#OpeNER is amazing .OpeNER is cool. => OpeNER is amazing. OpeNER is cool.
		elsif ( $word =~ /^\.(\p{IsUpper}\S+)$/ ) {
			my $post = $1;
			if ( $i>0 &&  $words[$i-1] =~ /^(\S+)$/) {
				$word = ". ".$post;
			}
		}
		$text .= $word." ";
	}
	#freedoms." 'Outrageous'Although => freedoms". 'Outrageous' Although
	#$text =~ s/(\")([^\"]+)(\. ?)(\")/$1$2$4$3/g;
	#$text =~ s/(\')([^\']+)(\. ?)(\')/$1$2$4$3/g;
	return $text;
}

sub fix_encoding {

	my $text = shift(@_);	

	$text =~ s/â/'/g;
	$text =~ s/Ã/À/g;
	$text =~ s//“/g;
############################################
############################################
	$text =~ s/â€¦/…/g; # elipsis
	$text =~ s/â¦/…/g; # elipsis
	$text =~ s/â€“/–/g; # long hyphen
	$text =~ s/â€™/’/g; #curly apostrophe
	$text =~ s/â€œ/“/g; # curly open quote
	$text =~ s/â€/”/g; # curly close quote
	$text =~ s/Â»/»/g;
	$text =~ s/Â«/«/g;
############################################
	$text =~ s/Ã¡/á/g;
	$text =~ s/Ã©/é/g;
	$text =~ s/Ã\*/í/g;
	$text =~ s/Ã³/ó/g;
	$text =~ s/Ãº/ú/g;

	$text =~ s/Ã/Á/g;
	$text =~ s/Ã‰/É/g;
	$text =~ s/Ã/Í/g;
	$text =~ s/Ã“/Ó/g;
	$text =~ s/Ãš/Ú/g;
############################################
	$text =~ s/Ã±/ñ/g;
	$text =~ s/Ã§/ç/g;
	$text =~ s/Å“/œ/g;

	$text =~ s/Ã‘/Ñ/g;
	$text =~ s/Ã‡/Ç/g;
	$text =~ s/Å’/Œ/g;
############################################
	$text =~ s/Â©/©/g;
	$text =~ s/Â®/®/g;
	$text =~ s/â„¢/™/g;
	$text =~ s/Ã˜/Ø/g;
	$text =~ s/Âª/ª/g;
############################################
	$text =~ s/Ã¤/ä/g;
	$text =~ s/Ã«/ë/g;
	$text =~ s/Ã¯/ï/g;
	$text =~ s/Ã¶/ö/g;
	$text =~ s/Ã¼/ü/g;

	$text =~ s/Ã„/Ä/g;
	$text =~ s/Ã‹/Ë/g;
	$text =~ s/Ã /Ï/g;
	$text =~ s/Ã– /Ö/g;
	$text =~ s/Ãœ/Ü/g;
############################################
	$text =~ s/Ã /à/g;
	$text =~ s/Ã¨/è/g;
	$text =~ s/Ã¬/ì/g;
	$text =~ s/Ã²/ò/g;
	$text =~ s/Ã¹/ù/g;

	$text =~ s/Ã€/À/g;
	$text =~ s/Ãˆ/È/g;
	$text =~ s/ÃŒ/Ì/g;
	$text =~ s/Ã’/Ò/g;
	$text =~ s/Ã™/Ù/g;
############################################
	$text =~ s/Ã¢/â/g;
	$text =~ s/Ãª/ê/g;
	$text =~ s/Ã®/î/g;
	$text =~ s/Ã´/ô/g;
	$text =~ s/Ã»/û/g;

	$text =~ s/Ã‚/Â/g;
	$text =~ s/ÃŠ/Ê/g;
	$text =~ s/ÃŽ/Î/g;
	$text =~ s/Ã”/Ô/g;
	$text =~ s/Ã›/Û/g;
############################################
	$text =~ s/Ã/E/g;


	return $text;
}

1;
