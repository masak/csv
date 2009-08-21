use v6;
use Test;

use Text::CSV;

my $input = q[[[one,line,four,words
five,words,in,one,line
only,three,words]]];

lives_ok { Text::CSV.read($input) },
         'varying numbers of fields parse OK';

dies_ok { Text::CSV.read($input, :strict) },
        'when strict more is on, varying numbers of fields cause an error';

done_testing;

# vim:ft=perl6
