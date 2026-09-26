#!/bin/sh
# Type-check every module of luce-browser-css with warnings as errors and run the unit tests
# of the modules that have them. Stops at the first failing step.
set -e
cd "$(dirname "$0")"

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

# Unit tests (TestCSSTokenStream, the CSS tokenizer corpora of tests/, focused cases), run from
# the package root because the corpus tests read tests/css_tokenizer*.
for module in css_syntax; do
    echo "== luce-base test src/luce_browser_css/$module"
    luce-base test "src/luce_browser_css/$module"
done
