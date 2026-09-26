#!/bin/sh
# Type-check every module of luce-browser-css with warnings as errors, run the unit tests of the
# modules that have them, regenerate css_data's generated fragments into a temporary directory
# and compare them with the committed ones, and compare css_data's dump with the donor's. Stops at
# the first failing step.
set -e
cd "$(dirname "$0")"

# Every hand-written fragment is laid out as the pinned compiler's formatter lays it out
# (generated fragments are compared with their generator's output instead).
echo "== luce-base fmt --check"
for file in $(git ls-files '*.lucb' | grep -v -e '/generated_' -e '_tables\.lucb$'); do
    luce-base fmt "$file" --check > /dev/null || { echo "$file is not formatted (luce-base fmt $file --write)"; exit 1; }
done

check() {
    echo "== luce-base check $1 -W"
    # -W reports warnings without failing, so any output at all fails the run.
    output=$(luce-base check "$1" -W 2>&1) || { echo "$output"; exit 1; }
    if [ -n "$output" ]; then
        echo "$output"
        exit 1
    fi
}

for module in css_syntax css_data; do
    check "src/luce_browser_css/$module"
done

# Unit tests (TestCSSTokenStream, the CSS tokenizer corpora of tests/, TestCSSIDSpeed,
# TestCSSInheritedProperty, focused cases), run from the package root because the corpus tests
# read tests/css_tokenizer*.
for module in css_syntax css_data; do
    echo "== luce-base test src/luce_browser_css/$module"
    luce-base test "src/luce_browser_css/$module"
done

mkdir -p build tests/build
generated=$(mktemp -d)
trap 'rm -rf "$generated"' EXIT

echo "== tools/gen_css: regenerate css_data's generated fragments and compare"
luce-base build tools/gen_css -o build/gen_css
build/gen_css data/css "$generated"
for file in "$generated"/*.lucb; do
    cmp "$file" "src/luce_browser_css/css_data/$(basename "$file")"
done
for file in src/luce_browser_css/css_data/generated_*.lucb; do
    [ -f "$generated/$(basename "$file")" ] || { echo "$file is not generated any more"; exit 1; }
done

# tests/data/css_data_dump.txt was printed by Ladybird's generated C++ (47c82b38d0) for the same
# inputs; css_data must answer every question the same way.
echo "== tests/css_data_dump: compare css_data with the donor's generated C++"
(cd tests && luce-base build css_data_dump -o build/css_data_dump)
tests/build/css_data_dump tests/data/css_data_inputs.txt > "$generated/css_data_dump.txt"
cmp "$generated/css_data_dump.txt" tests/data/css_data_dump.txt
