#!/usr/bin/env bash
#
# Refresh the committed karabiner.json snapshot from karabiner.edn.
#
# This does not touch the live config — `goku` (via ../install.sh) does that.
# The snapshot exists so that the effect of an edn change shows up in a diff.

set -euo pipefail

here=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

# goku 0.5.7 prints the generated Default profile to stdout and *then* dies
# with a StackOverflowError on its own exit path. The output is complete and
# correct, so the status is discarded and the trailing stack trace stripped by
# taking only the top-level JSON object.
raw=$(GOKU_EDN_CONFIG_FILE=$here/karabiner.edn goku --dry-run 2>/dev/null || true)
profile=$(printf '%s\n' "$raw" | sed -n '/^{/,/^}$/p')

if [ -z "$profile" ]; then
    echo "goku produced no JSON — is karabiner.edn valid?" >&2
    exit 1
fi

printf '%s\n' "$profile" | python3 -c '
import json, sys
json.dump({"profiles": [json.load(sys.stdin)]}, sys.stdout, indent=2, sort_keys=True)
sys.stdout.write("\n")
' > "$here/karabiner.json"

echo "regenerated $here/karabiner.json"
