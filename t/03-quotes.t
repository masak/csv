use v6;
use Test;

use CSV;

sub ok_becomes($input, $output, $description = '') {
    is_deeply CSV.read($input), $output, $description;
}

ok_becomes q[[[foo,bar,baz
'foo','bar','baz'
'foo','bar' , 'baz']]], [ [<foo bar baz>] xx 3 ], 'single quotes';

ok_becomes q[[[foo,bar,baz
"foo","bar","baz"
"foo","bar" , "baz"]]], [ [<foo bar baz>] xx 3 ], 'double quotes';

dies_ok { CSV.read(q[[[foo,ba'r,ba'z]]]) }, 'mid-string single quotes illegal';
dies_ok { CSV.read(q[[[foo,ba"r,ba"z]]]) }, 'mid-string double quotes illegal';

done_testing;

# vim:ft=perl6
