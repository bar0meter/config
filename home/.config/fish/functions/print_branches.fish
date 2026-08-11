function print_branches --description 'Show branches with ahead/behind counts vs current HEAD'
    set -l red (set_color red)
    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l yellow (set_color yellow)
    set -l normal (set_color normal)

    set -l w1 5
    set -l w2 6
    set -l w3 30
    set -l w4 20
    set -l w5 40

    set -l main_branch (git rev-parse HEAD)

    printf "$green%-"$w1"s $red%-"$w2"s $blue%-"$w3"s $yellow%-"$w4"s $normal%-"$w5"s\n" "Ahead" "Behind" "Branch" "Last Commit" " "
    printf "$green%-"$w1"s $red%-"$w2"s $blue%-"$w3"s $yellow%-"$w4"s $normal%-"$w5"s\n" "-----" "------" "------------------------------" "-------------------" " "

    for branchdata in (git for-each-ref --sort=-authordate --format="%(objectname:short)@%(refname:short)@%(committerdate:relative)" refs/heads/ --no-merged)
        set -l parts (string split '@' -- $branchdata)
        set -l sha $parts[1]
        set -l branch $parts[2]
        set -l time $parts[3]

        test "$branch" = "$main_branch"; and continue

        set -l description (git config branch."$branch".description)

        set -l ahead_behind (git rev-list --left-right --count "$main_branch"..."$sha" | string split \t)
        set -l behind $ahead_behind[1]
        set -l ahead $ahead_behind[2]

        printf "$green%-"$w1"s $red%-"$w2"s $blue%-"$w3"s $yellow%-"$w4"s $normal%-"$w5"s\n" $ahead $behind $branch "$time" "$description"
    end
end
