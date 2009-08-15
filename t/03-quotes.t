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

done_testing;

# vim:ft=perl6
