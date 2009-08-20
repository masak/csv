use v6;
use Test;

use Text::CSV;

sub ok_becomes($input, $output, $description = '') {
    is_deeply Text::CSV.read($input), $output, $description;
}

is_deeply Text::CSV.read(q[[[foo,bar,baz
foo,bar , baz
foo,bar  ,  baz]]]),
          [ [<foo bar baz>],
            ['foo', 'bar ', ' baz'],
            ['foo', 'bar  ', '  baz'] ],
          'spaces are not trimmed by default';

done_testing;

# vim:ft=perl6
