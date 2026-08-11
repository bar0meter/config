function git_clean
    echo "(FISH) Fetching and pruning remote-tracking refs/tags..."
    git fetch -p --prune-tags

    echo "Looking for local branches whose upstream is gone..."
    set gone_branches (git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}')

    if test (count $gone_branches) -eq 0
        echo "No gone local branches found."
    else
        for branch in $gone_branches
            echo "Deleting local branch: $branch"
            git branch -D "$branch"
        end
    end

    echo "Loading local tags..."
    set local_tags (mktemp)
    set remote_tags (mktemp)
    set stale_tags (mktemp)

    git tag -l | sort >$local_tags

    echo "Loading remote tags from origin..."
    git ls-remote --tags --refs origin | awk '{sub("refs/tags/", "", $2); print $2}' | sort >$remote_tags

    echo "Finding local tags missing from origin..."
    comm -23 $local_tags $remote_tags >$stale_tags

    if not test -s $stale_tags
        echo "No stale local tags found."
    else
        set count (wc -l $stale_tags | awk '{print $1}')
        echo "Deleting $count stale local tag(s)..."

        while read -l tag
            if test -z "$tag"
                continue
            end
            echo "Deleting local tag: $tag"
            git tag -d "$tag"
        end <$stale_tags
    end

    rm -f $local_tags $remote_tags $stale_tags

    echo "Git cleanup complete."
end
