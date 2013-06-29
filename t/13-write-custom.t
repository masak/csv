use v6;
use Test;

use Text::CSV;

my ( $in, $out, $before, $after );

{
    $in = './t/Files/ugly.csv';

    $out = './t/Files/test.csv';

    my @csv = Text::CSV.parse-file($in);

    csv-write-file(@csv, :file($out), :quote("'") );

    $before = slurp './t/Files/single-q.csv';

    $after = slurp $out;

    is($before, $after, 'Writes file with single quote as quoting character correctly');

    csv-write-file(@csv, :file($out), :quote('@') );

    $before = slurp './t/Files/at-q.csv';

    $after = slurp $out;

    is($before, $after, 'Writes file with "@" as quoting character correctly');

    csv-write-file(@csv, :file($out), :separator("\t") );

    $before = slurp './t/Files/tab-s.csv';

    $after = slurp $out;

    is($before, $after, 'Writes file with Tab as separator character correctly');
}

done;

# vim:ft=perl6
