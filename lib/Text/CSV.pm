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

    method read($input, :$trim) {
        Text::CSV::File.parse($input)
            or die "Sorry, cannot parse";
        my @lines = $<line>;
        return map {
            [map { extract_text($_, :$trim) }, .<value>]
        }, @lines;
    }

    method read-file($filename, *%_) {
        return self.read( slurp($filename), |%_ );
    }
}
