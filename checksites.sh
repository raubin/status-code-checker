#!/usr/bin/env bash
#
# This script will check the response code from a list of sites to ensure
# that they are protected. Expected response code is a 401, access denied.

SITE_LIST="site_list.txt"

while read url; do
  RESPONSE=`curl -L -s -o /dev/null -w "%{http_code}" ${url}`
  if [[ $RESPONSE == 401 ]]; then
    echo "${url}: OK"
  else
    echo "${url} is NOT protected: ${RESPONSE}"
  fi
done <$SITE_LIST
