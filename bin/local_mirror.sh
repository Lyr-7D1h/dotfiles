#!/usr/bin/env bash
#
# Fetch all resources of a website to be able to view it locally
# Get cookies.txt using ~/bin/extract_cookies \
#
wget \
	--recursive \
	--mirror \
	--page-requisites \
	--convert-links \
	--no-parent \
	--adjust-extension \
	--span-hosts \
	--wait="2" \
	--random-wait \
	--no-clobber \
	--timestamping \
	-e robots=off \
	--keep-session-cookies \
	--user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:136.0) Gecko/20100101 Firefox/136.0" \
	--load-cookies cookies.txt \
	"${@}"

