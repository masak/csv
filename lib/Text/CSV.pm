grammar Text::CSV::Line {
    regex TOP { ^ <value> ** ',' $ }
    regex value {
        | <pure_text>
        | \s* \' <single_quote_contents> \' \s*
        | \s* \" <double_quote_contents> \" \s*
    }
    regex single_quote_contents { <pure_text> ** [ <[",]> | \h ] }
    regex double_quote_contents { <pure_text> ** [ <[',]> | \h ] }
    regex pure_text { [<!before <['",]>> .]+ }
}

class Text::CSV {
    sub extract_text($m, :$trim) {
        my $text = ($m<single_quote_contents>
                    // $m<double_quote_contents>
                    // $m).Str;
        return $trim ?? $text.trim !! $text;
    }

    sub parse_line($line) {
        Text::CSV::Line.parse($line)
            or die "Sorry, cannot parse: ", $line;
    }

    method read($input, :$trim) {
        my @lines = $input.split("\n");
        if @lines[*-1] ~~ /^ \s* $/ {
            @lines.pop;
        }
        return map {
            [map { extract_text($_, :$trim) }, parse_line($_)<value>]
        }, @lines;
    }

    method read-file($filename, *%_) {
        return self.read( slurp($filename), |%_ );
    }
}
