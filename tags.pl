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
    $row->[0] =~ s{ and\b}{<br/>and};
    push @names, {
        first => $row->[0],
        last  => $row->[1],
        color => $row->[2],
    };
}
close $fh;

push @names, {
    first => '',
    last  => '',
    color => '',
} if @names % 2;

my $tt = Template->new;
$tt->process('tags.tt2', {
    names => \@names,
}, 'tags.html')
    or die "TT Error: ", $tt->error, "\n";
