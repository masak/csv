use v6;
use Test;

use Text::CSV;

my $input = q[[[subject,predicate,object
dog,bites,man
child,gets,cake
arthur,extracts,excalibur]]];

is_deeply Text::CSV.read($input),
          [ [<subject predicate object>],
            [<dog bites man>],
            [<child gets cake>],
            [<arthur extracts excalibur>] ],
          'with no :output parameter, an AoA is returned, header included';

is_deeply Text::CSV.read($input, :output<arrays>),
          [ [<subject predicate object>],
            [<dog bites man>],
            [<child gets cake>],
            [<arthur extracts excalibur>] ],
          'with :output<arrays>, an AoA is returned, header included';

is_deeply Text::CSV.read($input, :output<hashes>),
          [ { :subject<dog>,    :predicate<bites>,    :object<man>       },
            { :subject<child>,  :predicate<gets>,     :object<cake>      },
            { :subject<arthur>, :predicate<extracts>, :object<excalibur> } ],
          'with :output<hashes>, an AoH is returned, header as hash keys';

done_testing;

# vim:ft=perl6
