#!/usr/bin/env bash
#
# This script will check the response code from a list of sites to ensure
# that they are protected. Expected response code is a 401, access denied.

SITE_LIST="site_list.txt"

if [[ ! -f $SITE_LIST ]];then
  echo "No site_list.txt file available! Please create one first."
  exit 1
fi

FAIL_COUNT=0

while read url; do
  RESPONSE=`curl -L -s -m 5 -o /dev/null -w "%{http_code}" ${url}`
  if [[ $RESPONSE == 401 ]] || [[ $RESPONSE == 403 ]]; then
    echo "${url}: $RESPONSE OK"
  elif [[ $RESPONSE == 000 ]]; then
    echo "${url} timed out..."
  else
  	((FAIL_COUNT++))
    echo "${url} is NOT protected: ${RESPONSE}"
  fi
done <$SITE_LIST

echo
echo "---------------------"
echo "Failed: ${FAIL_COUNT}"
echo

exit 0
