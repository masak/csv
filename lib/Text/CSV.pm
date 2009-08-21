grammar Text::CSV::File {
    regex TOP { ^ <line> ** \n <empty_line>? $ }
    regex line { <value> ** ',' }
    regex value {
        | <pure_text>
        | \s* \" <quoted_contents> \" \s*
    }
    regex quoted_contents { <pure_text> ** [ <[,]> | \s | '""' ] }
    regex pure_text { [<!before <[",]>> \N]+ }
    regex empty_line { \h* \n }
}

class Text::CSV {
    sub extract_text($m, :$trim) {
        my $text = ($m<quoted_contents> // $m).subst('""', '"', :global);
        return $trim ?? $text.trim !! $text;
    }

    method read($input, :$trim, :$output = 'arrays', :$skip-header,
                        :$strict is copy = 'default') {
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
                my %hash = map {; @header[$_] => @line[$_] }, ^@line;
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
                my %attrs = map {; @header[$_] => @line[$_] }, ^@line;
                $type.new( |%attrs );
            }, @values;
        }
        return @values;
    }

    method read-file($filename, *%_) {
        return self.read( slurp($filename), |%_ );
    }
}
