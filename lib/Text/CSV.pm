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
    sub extract_text($m) {
        return ($m<single_quote_contents>
                // $m<double_quote_contents>
                // $m).Str;
    }

    sub parse_line($line) {
        Text::CSV::Line.parse($line)
            or die "Sorry, cannot parse: ", $line;
    }

    method read($input) {
        my @lines = $input.split("\n");
        if @lines[*-1] ~~ /^ \s* $/ {
            @lines.pop;
        }
        return map {
            [map { extract_text($_) }, parse_line($_)<value>]
        }, @lines;
    }

    method read-file($filename) {
        return self.read( slurp($filename) );
    }
}
