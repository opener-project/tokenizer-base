#!/usr/bin/perl -w

# Based on Preprocessor written by Philipp Koehn
# Changed by aazpeitia (aazpeitia@vicomtech.org)

use strict;

my %NONBREAKING_PREFIX = ();
my $LANGUAGE;

sub init_sentence_splitter {
	$LANGUAGE = shift(@_);
	%NONBREAKING_PREFIX = %{ shift(@_) };
}

sub split_sentences {

	my $input_text = shift(@_);
	chomp($input_text);
	my $text = "";
	if (/^<.+>$/ || /^\s*$/) {
		#time to process this block, we've hit a blank or <p>
		#&do_it_for($text,$input_text);
		#print "<P>\n" if (/^\s*$/ && $text); ##if we have text followed by <P>
		#$text = "";
		$text .= &do_it_for($text,$input_text);
		$text .= "<P>\n" if (/^\s*$/ && $text); ##if we have text followed by <P>
	}
	else {
		#append the text, with a space
		$text .= $input_text. " ";
	}
	$text = &do_it_for($text,$input_text);
	return split("\n", $text);
}

sub do_it_for {
	my($text,$markup) = @_;
	$text = &preprocess($text) if $text;
	#print "$markup\n" if ($markup =~ /^<.+>$/);
	return $text;
}

sub preprocess {
	#this is one paragraph
	my($text) = @_;

	# clean up spaces at head and tail of each line as well as any double-spacing
	$text =~ s/ +/ /g;
	$text =~ s/\n /\n/g;
	$text =~ s/ \n/\n/g;
	$text =~ s/^ //g;
	$text =~ s/ $//g;
		
	#####add sentence breaks as needed#####
	#non-period end of sentence markers (?!) followed by sentence starters.

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#$text =~ s/([?!]) +([\'\"\(\[\¿\¡\p{IsPi}]*[\p{IsUpper}])/$1\n$2/g;
	$text =~ s/([?!]) +([\'\"\(\[\¿\¡\p{IsPi}]*[\w])/$1\n$2/g;
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		
	#multi-dots followed by sentence starters
	$text =~ s/(\.[\.]+) +([\'\"\(\[\¿\¡\p{IsPi}]*[\p{IsUpper}])/$1\n$2/g;
	
	# add breaks for sentences that end with some sort of punctuation inside a quote or parenthetical and are followed by a possible sentence starter punctuation and upper case
	$text =~ s/([?!\.][\ ]*[\'\"\)\]\p{IsPf}]+) +([\'\"\(\[\¿\¡\p{IsPi}]*[\ ]*[\p{IsUpper}])/$1\n$2/g;
		
	# add breaks for sentences that end with some sort of punctuation are followed by a sentence starter punctuation and upper case
	$text =~ s/([?!\.]) +([\'\"\(\[\¿\¡\p{IsPi}]+[\ ]*[\p{IsUpper}])/$1\n$2/g;
	
	# special punctuation cases are covered. Check all remaining periods.
	my $word;
	my $i;
	my @words = split(/ /,$text);
	$text = "";
	for ($i=0;$i<(scalar(@words)-1);$i++) {
		if ($words[$i] =~ /([\p{IsAlnum}\.\-]*)([\'\"\)\]\%\p{IsPf}]*)(\.+)$/) {
			#check if $1 is a known honorific and $2 is empty, never break
			my $prefix = $1;
			my $starting_punct = $2;
			if($prefix && $NONBREAKING_PREFIX{$prefix} && $NONBREAKING_PREFIX{$prefix} == 1 && !$starting_punct) {

				#not breaking;
			} elsif ($words[$i] =~ /(\.)[\p{IsUpper}\-]+(\.+)$/) {
				#not breaking - upper case acronym	
			} elsif($words[$i+1] =~ /^([ ]*[\'\"\(\[\¿\¡\p{IsPi}]*[ ]*[\p{IsUpper}0-9])/) {
				#the next word has a bunch of initial quotes, maybe a space, then either upper case or a number
				$words[$i] = $words[$i]."\n" unless ($prefix && $NONBREAKING_PREFIX{$prefix} && $NONBREAKING_PREFIX{$prefix} == 2 && !$starting_punct && ($words[$i+1] =~ /^[0-9]+/));
				#we always add a return for these unless we have a numeric non-breaker and a number start
			}
			
		}
		$text = $text.$words[$i]." ";
	}
	
	#we stopped one token from the end to allow for easy look-ahead. Append it now.
	$text = $text.$words[$i];
	
	# clean up spaces at head and tail of each line as well as any double-spacing
	$text =~ s/ +/ /g;
	$text =~ s/\n /\n/g;
	$text =~ s/ \n/\n/g;
	$text =~ s/^ //g;
	$text =~ s/ $//g;
	
	#add trailing break
	$text .= "\n" unless $text =~ /\n$/;
	
	return $text;
	
}

1;
