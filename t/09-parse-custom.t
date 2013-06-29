use v6;
use Test;

use Text::CSV;


my $in = './t/Files/ugly.csv';

my @csv = Text::CSV.parse-file($in);

dies_ok { Text::CSV.parse-file( $in, :quote("") ) },
  'Dies properly if tries to use blank quoting character';

dies_ok { Text::CSV.parse-file( $in, :quote(" ") ) },
  'Dies properly if tries to use a space for a quoting character';

dies_ok { Text::CSV.parse-file( $in, :quote("''") ) },
  'Dies properly if tries to use multi characters for a quoting character';

dies_ok { Text::CSV.parse-file( $in, :separator("") ) },
  'Dies properly if tries to use blank separator character';

dies_ok { Text::CSV.parse-file( $in, :quote("\n") ) },
  'Dies properly if tries to use a space for a separator character';

dies_ok { Text::CSV.parse-file( $in, :quote("''") ) },
  'Dies properly if tries to use multi characters for a separator character';

dies_ok { Text::CSV.parse-file( $in, :quote("'"), :seoarator("'") ) },
  'Dies properly if tries to usethe same characters for both separator and quote character';

is_deeply Text::CSV.parse-file( './t/Files/single-q.csv', :quote("'") ),
    @csv, 'Parsing using custom quote "\'" works correctly';

is_deeply Text::CSV.parse-file( './t/Files/at-q.csv', :quote("@") ),
    @csv, 'Parsing using custom quote "@" works correctly';

is_deeply Text::CSV.parse-file( './t/Files/tab-s.csv', :separator("\t") ),
    @csv, 'Parsing using custom separator "\t" works correctly';

done;

# vim:ft=perl6
