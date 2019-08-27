#!/usr/local/bin/perl -w

#what're we wanting to use with this
use strict;
use File::Slurp;

#Read in our list of realms - Chomp to remove bullshit whitespace
my @lines = read_file("realms.txt", chomp => 1);
my $line;

#Print each line that we want in our final file, with each line from the realms list
# 'samlGroupRoleMap' will need to be replaced by your reach role; don't forget!
foreach $line (@lines) {
    print qq(#REALM - $line - ) . qq(\n);
    print qq(samlGroupRoleMap.$line\_Administrator.NUM=true).qq(\n);
    print qq(samlGroupRoleMap.$line\_Contributor.NUM=true).qq(\n);
    print qq(samlGroupRoleMap.$line\_Editor.NUM=true).qq(\n);
    print qq(samlGroupRoleMap.$line\_Researcher.NUM=true).qq(\n);
#    print qq(samlGroupRoleMap.$line\_Librarian Admin.NUM=true).qq(\n);
#    print qq(samlGroupRoleMap.$line\_Librarian Editor.NUM=true).qq(\n);
#    print qq(samlGroupRoleMap.$line\_Librarian Contributor.NUM=true).qq(\n);
#    print qq(samlGroupRoleMap.$line\_Librarian Researcher.NUM=true).qq(\n);
}
