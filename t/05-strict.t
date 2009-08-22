use v6;
use Test;

use Text::CSV;

my $input = q[[[one,line,four,words
five,words,in,one,line
only,three,words]]];

lives_ok { Text::CSV.parse($input) },
         'varying numbers of fields parse OK';

dies_ok { Text::CSV.parse($input, :strict) },
        'when strict more is on, varying numbers of fields cause an error';

dies_ok { Text::CSV.parse($input, :output<hashes>) },
        ':output<hashes> turns on :strict by default';

dies_ok { Text::CSV.parse($input, :output(Any)) },
        ':output(Any) turns on :strict by default';

lives_ok { Text::CSV.parse($input, :output<hashes>, :!strict) },
         'default :strict can be turned back off for :output<hashes>';

lives_ok { Text::CSV.parse($input, :output(Any), :!strict) },
         'default :strict can be turned back off for :output(Any)';

is_deeply Text::CSV.parse($input, :output<hashes>, :!strict),
          [ { one => "five", line => "words", four => "in", words => "one" },
            { one => "only", line => "three", four => "words" } ],
          'the hashes output under :!strict makes only the necessary pairs';

done_testing;

# vim:ft=perl6
