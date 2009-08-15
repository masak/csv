class CSV {
    sub parse-quotes($_ is copy) {
        if $_ ~~ /^\' (.*) \'$/ {
            $_ = ~$0;
        }
        if $_ ~~ /^\" (.*) \"$/ {
            $_ = ~$0;
        }
        if $_ ~~ /<!before \\>[\\\\]*\'/ {
            die "Cannot have unquoted single quotes in value: ", $_;
        }
        if $_ ~~ /<!before \\>[\\\\]*\"/ {
            die "Cannot have unquoted double quotes in value: ", $_;
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
