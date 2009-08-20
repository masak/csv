use v6;
use Test;

use Text::CSV;

sub ok_becomes($input, $output, $description = '') {
    is_deeply Text::CSV.read($input), $output, $description;
}

ok_becomes q[[[foo,bar,baz
'foo','bar','baz'
'foo','bar' , 'baz']]], [ [<foo bar baz>] xx 3 ], 'single quotes';

ok_becomes q[[[foo,bar,baz
"foo","bar","baz"
"foo","bar" , "baz"]]], [ [<foo bar baz>] xx 3 ], 'double quotes';

dies_ok { Text::CSV.read(q[[[foo,ba'r,ba'z]]]) },
        'mid-string single quotes illegal';
dies_ok { Text::CSV.read(q[[[foo,ba"r,ba"z]]]) },
        'mid-string double quotes illegal';

is +Text::CSV.read(q[[[foo,'bar,baz']]])[0], 2, 'can single-quote commas';
is +Text::CSV.read(q[[[foo,"bar,baz"]]])[0], 2, 'can double-quote commas';

done_testing;

# vim:ft=perl6
