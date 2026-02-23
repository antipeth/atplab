#!/usr/bin/env bash

VALUE_PATHS=(./machines/*/values/* ./modules/values/*)
KEYWORDS=("data" "sops" "age" "lastmodified" "mac")
CHECK_STAGED_ONLY=true

fail=0

if [[ "$CHECK_STAGED_ONLY" == true ]]; then
    mapfile -t files < <(git diff --cached --name-only --diff-filter=ACMR | grep -E '^(machines/.*/values/|modules/values/)')
else
    mapfile -t files < <(find "${VALUE_PATHS[@]}" -type f 2>/dev/null)
fi

for f in "${files[@]}"; do
    [[ ! -f "$f" ]] && continue

    if file "$f" | grep -q "binary\|compressed"; then
        continue
    fi

    match=1
    for k in "${KEYWORDS[@]}"; do
        if ! grep -q -- "$k" "$f"; then
            match=0
            break
        fi
    done

    if [[ $match -eq 0 ]]; then
        echo "Error: $f does not contain all required keywords: ${KEYWORDS[*]}"
        fail=1
    fi
done

if [[ $fail -eq 1 ]]; then
    echo "Commit aborted: Some values files are missing required keywords."
    echo "Required in every file under machines/*/values/ and modules/values/:"
    printf '  - %s\n' "${KEYWORDS[@]}"
    exit 1
fi

exit 0
