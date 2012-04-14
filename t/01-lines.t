use v6;
use Test;

use Text::CSV;

sub ok_becomes($input, $output, $description = '') {
    is_deeply Text::CSV.parse($input), $output, $description;
}

ok_becomes q[[[foo
bar
baz]]], [['foo'], ['bar'], ['baz']], 'three lines, no commas';

ok_becomes q[[[foo
bar
baz
]]], [['foo'], ['bar'], ['baz']], 'three lines, no commas, final empty line';

done;

# vim:ft=perl6
