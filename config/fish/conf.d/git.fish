if command -sq gh
    set -l token (gh auth token 2>/dev/null)
    if test $status -eq 0; and test -n "$token"
        set -gx GITHUB_TOKEN "$token"
    end
end
