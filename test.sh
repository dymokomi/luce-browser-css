#!/bin/sh
# Type-check every module of luce-browser-css (and run its tests once there are any).
# Stops at the first failing step.
set -e
cd "$(dirname "$0")"

for module in css_syntax css_data; do
    echo "== luce-base check src/luce_browser_css/$module"
    luce-base check "src/luce_browser_css/$module"
done
