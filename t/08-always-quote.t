use v6;
use Test;

use Text::CSV;

my $out = './t/Files/test.csv';

my $expected = q[[["subject","predicate","object"
"dog","bites","man"
"child","gets","cake"
"arthur","extracts","excalibur"
]]];

my @AoA = [<subject predicate object>],
          [<dog bites man>],
          [<child gets cake>],
          [<arthur extracts excalibur>];

csv-write-file( :file($out), @AoA, :always_quote );
my $after = slurp $out;

is($expected.subst(/ [\r | \r\n] /, "\n", :g),
   $after.subst(/ [\r | \r\n] /, "\n", :g),
      'Always quote works on easy CSV');


$expected = q[[["Name","Number","Sentence"
"Able","1/2/2013","It's got like, a comma"
"Baker","3.14e+0","New
Lines,
Lots    of
New Lines and   Tabs"
"Charlie","Nope","Quoth the raven, ""Nevermore"""
"Davidovich","√2","Это русский"
]]];


@AoA = [<Name Number Sentence>],
       [<Able 1/2/2013>, "It's got like, a comma"],
       ['Baker',"3.14e+0","New
Lines,
Lots    of
New Lines and   Tabs"],
       [<Charlie Nope>, 'Quoth the raven, "Nevermore"'],
       [<Davidovich √2>, 'Это русский'];

csv-write-file( :file($out), @AoA, :always_quote );
$after = slurp $out;

is($expected.subst(/ [\r | \r\n] /, "\n", :g),
   $after.subst(/ [\r | \r\n] /, "\n", :g),
      'Always quote works on hard CSV');

$expected = q[[["","","","","NotEmpty"
]]];


@AoA = ['','','','','NotEmpty'];

csv-write-file( :file($out), @AoA, :always_quote );
$after = slurp $out;

is($expected.subst(/ [\r | \r\n] /, "\n", :g),
   $after.subst(/ [\r | \r\n] /, "\n", :g),
      'Always quote works on empty CSV');

unlink $out;

done;

# vim:ft=perl6
