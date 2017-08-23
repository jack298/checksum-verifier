#!/usr/bin/perl -s

use strict;
use warnings;
use Digest::MD5::File qw( file_md5_hex );
use Digest::SHA;
use Getopt::Long;

############# SETUP #############
my $usage = "Usage: $0 <filename> [--md5-checksum|--sha256-checksum] <checksum>";

my $file = shift or die "$usage\n";
die "File does not exist.\n" unless -f $file;
my $checksum_sha256 = 0;
my $checksum_md5 = 0;
my $checksum_calc = 0;
my $is_correct = 0;

GetOptions ("sha256-checksum=s" => \$checksum_sha256,
			"md5-checksum=s"	=> \$checksum_md5) or die "$usage";
			
############# SETUP #############

if ($checksum_sha256 && $checksum_md5)
{
	die "Invalid parameters.\n$usage";
}

if ($checksum_sha256)
{
	print("Calculating SHA256 checksum..\n");
	my $sha = Digest::SHA->new(256);
	$sha->addfile($file, "b");
	$checksum_calc = $sha->hexdigest;
	$is_correct = 1 if $checksum_calc eq $checksum_sha256;
}

elsif ($checksum_md5)
{
	print("Calculating MD5 checksum..\n");
	$checksum_calc = file_md5_hex( $file );
	$is_correct = 1 if ($checksum_calc eq $checksum_md5);
}
else
{
	die "$usage";
}

print "\nThe file is ";
if ($is_correct)
{
	print "VALID.";
}
else
{
	print "INVALID.";
}
	
print "\n\nGiven checksum: \t" . ($checksum_md5 or $checksum_sha256) . "\nCalculated checksum: \t" . $checksum_calc;
