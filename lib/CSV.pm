class CSV {
    method read($input) {
        my @lines = $input.split("\n");
        if @lines[*-1] ~~ /^ \s* $/ {
            @lines.pop;
        }
        return map { [.split(/','/)>>.trim] }, @lines;
    }
}
