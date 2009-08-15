class CSV {
    sub parse-quotes($_ is copy) {
        when /^\' (.*) \'$/ {
            $_ = ~$0;
        }
        return $_;
    }

    method read($input) {
        my @lines = $input.split("\n");
        if @lines[*-1] ~~ /^ \s* $/ {
            @lines.pop;
        }
        return map { [map { parse-quotes(.trim) }, .split(/','/)] }, @lines;
    }
}
