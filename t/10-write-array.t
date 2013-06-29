use v6;
use Test;

use Text::CSV;

my ( $in, $out, $before, $after );

{
    my @csv = [];
    dies_ok { csv-write-file( @csv ) }, 'Dies if no file name is provided';
}

{
    $in = './t/Files/pretty.csv';

    $out = './t/Files/test.csv';

    $before = slurp $in;

    my @csv = Text::CSV.parse-file($in);

    csv-write-file( :file($out), @csv );

    $after = slurp $out;

    is($before, $after, 'Array output for parse / write on pretty.csv round-trips');
}

{
    $in = './t/Files/ugly.csv';

    $out = './t/Files/test.csv';

    $before = slurp $in;

    my @csv = Text::CSV.parse-file($in);

    csv-write-file( :file($out), @csv );

    $after = slurp $out;

    is($before, $after, 'Array output for parse / write on ugly.csv round-trips');
}

{
    $in = './t/Files/pretty.csv';

    $out = './t/Files/test.csv';

    $before = slurp $in;

    my @header = <subject predicate object>;

    my @csv = Text::CSV.parse-file($in, :skip-header);

    csv-write-file( :file($out), @csv, :header(@header) );

    $after = slurp $out;

    is($before, $after, 'Array output for parse with skip-header / write with given header on pretty.csv round-trips');
}

{
    $in = './t/Files/ugly.csv';

    $out = './t/Files/test.csv';

    $before = slurp $in;

    my @header = <Name Number Sentence>;

    my @csv = Text::CSV.parse-file($in, :skip-header);

    csv-write-file( :file($out), @csv, :header(@header) );

    $after = slurp $out;

    is($before, $after, 'Array output for parse with skip-header / write with given header on ugly.csv round-trips');

    csv-write-file( file => $out, @csv, header => @header );

    $after = slurp $out;

    is($before, $after, 'Different calling convention yields the same result');

    csv-write-file( :header(@header), @csv, file => $out);

    $after = slurp $out;

    is($before, $after, 'Different parameter order yields the same result');
}

done;

# vim:ft=perl6
