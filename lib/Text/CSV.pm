grammar Text::CSV::File {
    regex TOP { ^ <line>+ % "\n" <empty_line>? $ }
    regex line { <value>+ % ',' }
    regex value {
        | <pure_text>
        | [\h* \"] ~ [\" \h*] <quoted_contents>
    }
    regex quoted_contents { [<pure_text> | <[,]> | \s | '""' ]* }
    regex pure_text { [<!before <[",]>> \N]+ }
    regex empty_line { \h* \n }
}

class Text::CSV {
    has $.trim;
    has $.strict;
    has $.skip-header;
    has $.output;

    my $trim-default = False;
    my $strict-default = 'default';
    my $skip-header-default = False;
    my $output-default = 'arrays';

    sub extract_text($m, :$trim) {
        my $text = ($m<quoted_contents> // $m).subst('""', '"', :global);
        return $trim ?? $text.trim !! ~$text;
    }

    method parse($input, :$trim is copy, :$strict is copy,
                         :$skip-header is copy, :$output is copy) {

        if self.defined {
            $trim        //= $.trim        // $trim-default;
            $strict      //= $.strict      // $strict-default;
            $skip-header //= $.skip-header // $skip-header-default;
            if $output ~~ Any {
                $output    = $.output      // $output-default;
            }
        }
        else {
            $trim        //= $trim-default;
            $strict      //= $strict-default;
            $skip-header //= $skip-header-default;
            if $output ~~ Any {
                $output    = $output-default;
            }
        }

        Text::CSV::File.parse($input)
            or die "Sorry, cannot parse";
        my @lines = $<line>;
        my @values = map {
            [map { extract_text($_, :$trim) }, .<value>]
        }, @lines;
        if $strict eq 'default' {
            $strict = $output.lc ne 'arrays';
        }
        if $strict {
            my $expected-columns = @values[0].elems;
            for ^@values -> $line {
                if (my $c = @values[$line]) > $expected-columns {
                    die "Too many columns ($c, expected $expected-columns) "
                        ~ "on line $line";
                }
                elsif $c < $expected-columns {
                    die "Too few columns ($c, expected $expected-columns) "
                        ~ "on line $line";
                }
            }
        }
        if $output.lc eq 'hashes' {
            my @header = @values.shift.list;
            @values = map -> @line {
                my %hash = map { @header[$_] => @line[$_] }, ^(+@line min +@header);
                \%hash
            }, @values;
        }
        elsif $output.lc eq 'arrays' {
            if $skip-header {
                @values.shift;
            }
        }
        else {
            my $type = $output;
            my @header = @values.shift.list;
            @values = map -> @line {
                my %attrs = map {; @header[$_] => @line[$_] },
                            ^(+@line min +@header);
                $type.new( |%attrs );
            }, @values;
        }
        return @values;
    }

    method parse-file($filename, *%_) {
        return self.parse( slurp($filename), |%_ );
    }
}
