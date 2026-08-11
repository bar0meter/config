function dusort
    du -sk ./* 2>/dev/null \
    | sort -nr \
    | awk '
        function human(x) {
            split("KB MB GB TB PB", units)
            i = 1

            while (x >= 1024 && i < 5) {
                x /= 1024
                i++
            }

            return sprintf("%.1f %s", x, units[i])
        }

        {
            size = $1
            $1 = ""
            sub(/^[ \t]+/, "")
            printf "%10s  %s\n", human(size), $0
        }
    '
end
