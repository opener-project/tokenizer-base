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
	
	#substitutes
	$text =~ s/â€¦/…/g; # elipsis
	$text =~ s/â€“/–/g; # long hyphen
	$text =~ s/â€™/’/g; #curly apostrophe
	$text =~ s/â€œ/“/g; # curly open quote
	$text =~ s/â€/”/g; # curly close quote
	
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

1;
