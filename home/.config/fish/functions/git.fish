function git --wraps git
    set -l cmd $argv[1]
    set -l ignore_tests_cmds diff df status st

    # ponytail: intercept our own --ignore-tests flag on the commands above
    if contains -- --ignore-tests $argv; and contains -- $cmd $ignore_tests_cmds
        set -l args
        set -l has_sep 0

        for a in $argv[2..-1]
            if test "$a" = "--ignore-tests"
                continue
            end
            if test "$a" = "--"
                set has_sep 1
            end
            set -a args $a
        end

        if test $has_sep -eq 1
            command git $cmd $args $__git_ignore_tests
        else
            command git $cmd $args -- . $__git_ignore_tests
        end
    else
        command git $argv
    end
end
