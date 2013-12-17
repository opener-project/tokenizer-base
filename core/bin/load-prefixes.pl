#!/usr/bin/perl -w

# Moses nonbreaking prefixes loader
# changed by Andoni Azpeitia (#2013/12/17)

use FindBin;
use utf8;

my $mydir = "$FindBin::Bin"."/nonbreaking_prefixes";
my %NONBREAKING_PREFIX = ();
my $LANGUAGE;

sub load_prefixes {
	$LANGUAGE = shift(@_);

	my $prefixfile = "$mydir/nonbreaking_prefix.$LANGUAGE";

	#default back to English if we don't have a language-specific prefix file
	if (!(-e $prefixfile)) {
		$prefixfile = "$mydir/nonbreaking_prefix.en";
		print STDERR "WARNING: No known abbreviations for language '$LANGUAGE', attempting fall-back to English version...\n";
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
	return \%NONBREAKING_PREFIX;
}

1;
