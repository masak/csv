grammar CSV::Line {
    rule TOP { ^ <value> ** ',' $ }
    rule value {
        | <pure_text>
        | \' <single_quote_contents> \'
        | \" <double_quote_contents> \"
    }
    regex single_quote_contents { <pure_text> ** [\"|' '] }
    regex double_quote_contents { <pure_text> ** [\'|' '] }
    regex pure_text { <alnum>+ }
}

class CSV {
    sub extract_text($m) {
        return ($m<single_quote_contents>
                // $m<double_quote_contents>
                // $m).Str;
    }

    sub parse_line($line) {
        CSV::Line.parse($line)
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
}
