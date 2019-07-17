#!/usr/bin/perl -w

use List::Compare;
use Array::Utils qw(:all);
use Term::ANSIColor qw(:constants);

#Read in files from the user input
# ./compare.pl file1 file2
my $path_to_file = $ARGV[0];
open my $handle, '<', $path_to_file;
chomp(my @file1 = <$handle>);
close $handle;
#
$path_to_file = $ARGV[1];
open $handle, '<', $path_to_file;
chomp(my @file2 = <$handle>);
close $handle;

#Print out lines in both files
my @isect = intersect(@file1, @file2);
print MAGENTA . "######Lines found in both files ######" . RESET . "\n";
#print "######Lines found in both files ######" . "\n";
print join("\n", @isect) . "\n";

#Doing the needful and grabbing what's in each file (list)
# as I can't figure a way out how to do this with array utils
my $lc = List::Compare->new( \@file1, \@file2 );
my @file1Only = $lc->get_Lonly;
my @file2Only = $lc->get_Ronly;

print MAGENTA . "######Lines found in File1 only######" . RESET . "\n";
#print "######Lines found in File1 only######" . "\n";
print join("\n", @file1Only) . "\n";

print MAGENTA . "######Lines found in File2 only######" . RESET . "\n";
#print "######Lines found in File2 only######" . "\n";
print join("\n", @file2Only) . "\n";
