#!/usr/bin/env bash
# Rewrite author/committer on all commits to link to the ajitbasnet GitHub profile.
# Run once before any push — all commit SHAs will change.
#
# Usage:
#   ./scripts/rewrite_author.sh
#
# Verify after rewrite:
#   git log --format='%an <%ae>' | sort -u
set -euo pipefail
cd "$(dirname "$0")/.."

AUTHOR_NAME="ajitbasnet"
AUTHOR_EMAIL="ajitbasnet32@gmail.com"

echo "Rewriting author/committer on all commits to ${AUTHOR_NAME} <${AUTHOR_EMAIL}>..."
echo "Warning: this rewrites history. Run only once, before pushing to remote."
echo

git filter-branch -f --env-filter "
  export GIT_AUTHOR_NAME=\"${AUTHOR_NAME}\"
  export GIT_AUTHOR_EMAIL=\"${AUTHOR_EMAIL}\"
  export GIT_COMMITTER_NAME=\"${AUTHOR_NAME}\"
  export GIT_COMMITTER_EMAIL=\"${AUTHOR_EMAIL}\"
" -- --all

echo
echo "Verifying unique author/committer identities:"
git log --format='%an <%ae>' | sort -u

UNIQUE_AUTHORS=$(git log --format='%an <%ae>' | sort -u | wc -l | tr -d ' ')
if [[ "${UNIQUE_AUTHORS}" -ne 1 ]]; then
  echo "Error: expected exactly one author identity, found ${UNIQUE_AUTHORS}." >&2
  exit 1
fi

EXPECTED="${AUTHOR_NAME} <${AUTHOR_EMAIL}>"
ACTUAL=$(git log --format='%an <%ae>' | sort -u)
if [[ "${ACTUAL}" != "${EXPECTED}" ]]; then
  echo "Error: expected '${EXPECTED}', got '${ACTUAL}'." >&2
  exit 1
fi

echo
echo "Done. All $(git rev-list --count HEAD) commits now show ${EXPECTED}."
