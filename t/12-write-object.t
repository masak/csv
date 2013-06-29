use v6;
use Test;

use Text::CSV;

my ( $in, $out, $before, $after );


{
    class Should-die {
        has Str $.subject;
        has Str $.predicate;
        has Str $.object;
    }

    $in = './t/Files/pretty.csv';

    $out = './t/Files/test.csv';

    my @csv = Text::CSV.parse-file($in, :output(Should-die));

    dies_ok { csv-write-file(:file($out), @csv) }, 'Dies if no header / accessor list is provided in object mode';

}


{
    class Sentence {
        has Str $.subject;
        has Str $.predicate;
        has Str $.object;
    }

    $in = './t/Files/pretty.csv';

    $out = './t/Files/test.csv';

    $before = slurp $in;

    my @header = <subject predicate object>;

    my @csv = Text::CSV.parse-file($in, :output(Sentence));

    csv-write-file(:file($out), @csv, :header(@header));

    $after = slurp $out;

    is($before, $after, 'Object output for parse / write with provided header / accessor list on pretty.csv round-trips');
}

{
   class UglyCSV {
        has Str $.Name;
        has Str $.Number;
        has Str $.Sentence;
    }

    $in = './t/Files/ugly.csv';

    $out = './t/Files/test.csv';

    $before = slurp $in;

    my @header = <Name Number Sentence>;

    my @csv = Text::CSV.parse-file($in, :output(UglyCSV));

    csv-write-file(:file($out), @csv, :header(@header));

    $after = slurp $out;

    is($before, $after, 'Object output for parse / write with provided header / accessor list on ugly.csv round-trips');
}

unlink $out;

done;

# vim:ft=perl6
