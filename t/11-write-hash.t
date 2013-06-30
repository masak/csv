use v6;
use Test;

use Text::CSV;

my ( $in, $out, $before, $after );

{
    $in = './t/Files/pretty.csv';
    $out = './t/Files/test.csv';
    my @csv = Text::CSV.parse-file($in, output => 'hashes');
    dies_ok { csv-write-file(file => $out, @csv) },
      'Dies if no header is provided in hash mode';

}

{
    $in = './t/Files/pretty.csv';
    $out = './t/Files/test.csv';
    $before = slurp $in;
    my @header = <subject predicate object>;
    my @csv = Text::CSV.parse-file($in, output => 'hashes');
    csv-write-file(file => $out, @csv, header => @header);
    $after = slurp $out;
    is($before, $after,
      'Hash output for parse / write with given header on pretty.csv round-trips');
}

{
    $in = './t/Files/ugly.csv';
    $out = './t/Files/test.csv';
    $before = slurp $in;
    my @header = <Name Number Sentence>;
    my @csv = Text::CSV.parse-file($in, output => 'hashes');
    csv-write-file(file => $out, @csv, header => @header);
    $after = slurp $out;
    is($before, $after,
      'Hash output for parse / write with given header on ugly.csv round-trips');
}

unlink $out;

done;

# vim:ft=perl6
