use v6;
use Test;

use Text::CSV;

is_deeply Text::CSV.read(q[[[foo,bar,baz
foo,bar , baz
foo,bar  ,  baz]]]),
          [ [<foo bar baz>],
            ['foo', 'bar ', ' baz'],
            ['foo', 'bar  ', '  baz'] ],
          'spaces are not trimmed by default';

is_deeply Text::CSV.read(q[[[foo,bar,baz
foo,bar , baz
foo,bar  ,  baz]]], :trim),
          [ [<foo bar baz>] xx 3 ],
          'spaces are trimmed when :trim is passed';

done_testing;

# vim:ft=perl6
