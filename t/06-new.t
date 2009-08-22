use v6;
use Test;

use Text::CSV;

my $input = q[[[one,two
three,four,excess
five]]];

my Text::CSV $reader .= new( :output<hashes>, :!strict );
is_deeply $reader.read($input),
          [ { one => 'three', two => 'four' },
            { one => 'five' } ],
          'the defaults are stored in attributes in the class';

done_testing;

# vim:ft=perl6
