#!/usr/bin/env bash
#
# Fetch all resources of a website to be able to view it locally

cookies=$(mktemp)
~/bin/extract_cookies > "${cookies}"

if [[ "$1" == *.json ]]; then
  # Extract URLs from the JSON file using jq
  urls=$(jq -r '.[]' "$1")
  shift # Remove the JSON file argument
else
  # Use the provided arguments as URLs
  urls="$@"
fi

for url in ${urls}; do
  wget \
    --page-requisites \
    --convert-links \
    --no-parent \
    --level 0 \
    --adjust-extension \
	--random-wait=2 \
	--wait 2 \
    --span-hosts \
    --no-clobber \
    --timestamping \
    -e robots=off \
    --keep-session-cookies \
    --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:136.0) Gecko/20100101 Firefox/136.0" \
    --load-cookies "${cookies}" \
    "${url}"
done

rm -f "${cookies}"]]
