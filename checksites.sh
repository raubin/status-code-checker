#!/usr/bin/env bash
# set -eo pipefail

# This script will check the response code from a list of sites to ensure
# that they are protected. Expected response code is a 401, access denied.

SITE_LIST="${BASH_SOURCE%/*}/site_list.txt"

if [[ ! -f $SITE_LIST ]];then
  echo "No site_list.txt file available! Please create one first."
  exit 1
fi

CHECKED_COUNT=0
PASS_COUNT=0
FAIL_COUNT=0

while read url; do

  RESPONSE=`curl -L -s -m 5 -o /dev/null -w "%{http_code}" ${url}`
  ((CHECKED_COUNT++))

  if [[ $RESPONSE == 401 ]] || [[ $RESPONSE == 403 ]]; then
    ((PASS_COUNT++))
    # echo "${url}: $RESPONSE OK"
  elif [[ $RESPONSE == 000 ]]; then
    ((FAIL_COUNT++))
    echo "${FAIL_COUNT}. ${url} timed out..."
  else
  	((FAIL_COUNT++))
    echo "${FAIL_COUNT}. ${url} is NOT protected: ${RESPONSE}"
  fi

done <$SITE_LIST

echo
echo "---------------------"
echo "Checked: ${CHECKED_COUNT}"
echo "Passed: ${PASS_COUNT}"
echo "Failed: ${FAIL_COUNT}"
echo ""
echo

exit 0
