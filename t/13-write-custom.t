use v6;
use Test;

use Text::CSV;

my ( $in, $out, $before, $after );


$in = './t/Files/ugly.csv';

$out = './t/Files/test.csv';

my @csv = Text::CSV.parse-file($in);

dies_ok { csv-write-file( @csv, :file($out), :quote('') ) },
  'Dies properly if tries to use blank quoting character';

dies_ok { csv-write-file( @csv, :file($out), :quote("''") ) },
  'Dies properly if tries to use multi-char quoting character';

csv-write-file(@csv, :file($out), :quote("'") );

$before = slurp './t/Files/single-q.csv';

$after = slurp $out;

is($before, $after, 'Writes file with single quote as quoting character correctly');

csv-write-file(@csv, :file($out), :quote('@') );

$before = slurp './t/Files/at-q.csv';

$after = slurp $out;

is($before, $after, 'Writes file with "@" as quoting character correctly');

dies_ok { csv-write-file( @csv, :file($out), :separator('') ) },
  'Dies properly if tries to use blank separator character';

dies_ok { csv-write-file( @csv, :file($out), :separator("''") ) },
  'Dies properly if tries to use multi-char separator character';

dies_ok { csv-write-file( @csv, :file($out), :separator("'"), :quote("'") ) },
  'Dies properly if tries to usethe same characters for both separator and quote character';

csv-write-file(@csv, :file($out), :separator("\t") );

$before = slurp './t/Files/tab-s.csv';

$after = slurp $out;

is($before, $after, 'Writes file with Tab as separator character correctly');

unlink $out;

done;

# vim:ft=perl6
