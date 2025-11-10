#!/usr/bin/env bash
set -euo pipefail

# --- argument check ---
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <urls_file> <downloads_dir> <archives_dir>"
    exit 1
fi

URLS_FILE="$1"
DOWNLOADS_DIR="$2"
ARCHIVES_DIR="$3"

# step 1
DATE_STR="$(date '+%Y-%m-%dT%H:%M:%S.%3N%z')"
echo "> Bash script starting at: ${DATE_STR}"

# step 2
SCRIPT_PATH="$(readlink -f "$0")"
echo "> Script full path: '${SCRIPT_PATH}'"

# step 3
TMP_DIR="tmp"
rm -rf "${TMP_DIR}"
mkdir -p "${TMP_DIR}"

# step 4
BLUE_UNDERLINE="\e[34;4m"
GREEN="\e[32m"
RESET="\e[0m"

# --- header: robust URL reading ---
# Handles: last-line no newline, CRLF, trailing %, spaces
while IFS= read -r URL || [[ -n "$URL" ]]; do

    # strip Windows CR
    URL="${URL//$'\r'/}"

    # strip trailing spaces
    URL="${URL%%[[:space:]]*}"

    # strip trailing '%' (common editing mistake)
    URL="${URL%%%}"

    # skip empty or commented lines
    [[ -z "$URL" ]] && continue
    [[ "$URL" =~ ^# ]] && continue

    # baby step 1
    printf "> Downloading '${BLUE_UNDERLINE}%s${RESET}'…\n" "$URL"

    # baby step 2
    FILENAME="$(basename "$URL")"
    JSON_PATH="${TMP_DIR}/${FILENAME}"
    HEADERS_PATH="${TMP_DIR}/${FILENAME}.headers"

    # baby step 3
    curl -sS -D "${HEADERS_PATH}" -o "${JSON_PATH}" "${URL}"

    # baby step 4
    printf "  ${GREEN}Done${RESET}\n"

done < "${URLS_FILE}"

# step 5
printf "> Copying JSON files from '%s' to '%s'…\n" "$TMP_DIR" "$DOWNLOADS_DIR"

# step 6
rm -rf "${DOWNLOADS_DIR}"
mkdir -p "${DOWNLOADS_DIR}"

# step 7 — protect cp if no json files exist
shopt -s nullglob
JSON_FILES=( "${TMP_DIR}"/*.json )
if (( ${#JSON_FILES[@]} )); then
    cp "${JSON_FILES[@]}" "${DOWNLOADS_DIR}/"
fi
shopt -u nullglob

# step 8
printf "  ${GREEN}Done${RESET}\n"

# step 9
printf "> Compiling HTTP response headers from '%s' to '%s'…\n" "$TMP_DIR" "$DOWNLOADS_DIR"

# step 11
HEADERS_OUTPUT="${DOWNLOADS_DIR}/headers.txt"
: > "${HEADERS_OUTPUT}"

# step 10
for HEADER_FILE in "${TMP_DIR}"/*.headers; do
    HEADER_NAME="$(basename "$HEADER_FILE")"
    printf "### %s:\n" "$HEADER_NAME" >> "${HEADERS_OUTPUT}"
    cat "$HEADER_FILE" >> "${HEADERS_OUTPUT}"
    printf "\n" >> "${HEADERS_OUTPUT}"
done

# step 12
printf "  ${GREEN}Done${RESET}\n"

# step 13
printf "> Compressing all files in '%s' to '%s'…\n" "$DOWNLOADS_DIR" "$ARCHIVES_DIR"

# step 14
ARCHIVE_TIMESTAMP="$(date '+%Y-%m-%dT%H-%M-%S')"
ARCHIVE_NAME="D${ARCHIVE_TIMESTAMP}.tar.gz"

mkdir -p "${ARCHIVES_DIR}"

tar -czf "${ARCHIVES_DIR}/${ARCHIVE_NAME}" -C "${DOWNLOADS_DIR}" .

# step 15
printf "  ${GREEN}Done${RESET} (archive file name: %s)\n" "$ARCHIVE_NAME"

# step 16
END_DATE_STR="$(date '+%Y-%m-%dT%H:%M:%S.%3N%z')"
printf "> Bash script ending at: %s\n" "$END_DATE_STR"

# step 17
printf "Bye! 👋\n"