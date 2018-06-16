#!/usr/bin/env perl
use v5.18;

use Text::CSV_XS;
use Template;

my $csv_file = shift // 'labels.csv';

my $csv = Text::CSV_XS->new;
open my $fh, '<', $csv_file or die "cannot open $csv_file: $!";
my @names;
while (my $row = $csv->getline($fh)) {
    next if $row->[0] eq 'FirstName';
    push @names, {
        first => $row->[0],
        last  => $row->[1],
        color => $row->[2],
    };
}
close $fh;

my $tt = Template->new;
$tt->process('labels.tt2', {
    names => \@names,
}, 'labels.html')
    or die "TT Error: ", $tt->error, "\n";
