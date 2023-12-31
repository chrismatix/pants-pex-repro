#!/usr/bin/env bash

# Taken from

set -euo pipefail

PYTHON_BIN=python3
VIRTUALENV=dist/export/python/virtualenvs/python-default
PIP="${VIRTUALENV}/bin/pip"
CONSTRAINTS_FILE=python-default.lock

"${PYTHON_BIN}" -m venv "${VIRTUALENV}"
"${PIP}" install pip --upgrade
# Install all our requirements.txt, and also any 3rdparty
# dependencies specified outside requirements.txt, e.g. via a
# handwritten python_requirement_library target.
"${PIP}" install \
  -r <(pants dependencies :: |
    xargs pants filter --target-type=python_requirement |
    xargs pants peek |
    jq -r '.[]["requirements"][]')
echo "# Generated by build-support/generate_constraints.sh on $(date)" > "${CONSTRAINTS_FILE}"
"${PIP}" freeze --all >> "${CONSTRAINTS_FILE}"

# If you are using multiple resolves, you will need to use JQ to filter to all
# requirements from a single resolve. For most resolves, use this JQ snippet:
#
#   '.[] | select(.resolve == "my-resolve") | .["requirements"][]'
#
# If the resolve is the default, you must also add `or .resolve == null`, like this:
#
#   '.[] | select(.resolve == "python-default" or .resolve == null) | .["requirements"][]'
