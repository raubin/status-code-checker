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
PROTECTED_COUNT=0
FAIL_COUNT=0
UNPROTECTED_COUNT=0
LINE=0

echo "Verifying protected sites are unreachable..."
echo

while read url; do

  RESPONSE=`curl -L -s -m 5 -o /dev/null -w "%{http_code}" ${url}`
  ((CHECKED_COUNT++))

  if [[ $RESPONSE == 401 ]] || [[ $RESPONSE == 403 ]]; then
    ((PROTECTED_COUNT++))
    # echo "${url}: $RESPONSE OK"
  elif [[ $RESPONSE == 000 ]] || [[ $RESPONSE == 500 ]] || [[ $RESPONSE == 400 ]]; then
    ((LINE++))
    ((FAIL_COUNT++))
    echo "${LINE}. ${url} could not be reached"
  else
    ((LINE++))
  	((UNPROTECTED_COUNT++))
    echo "${LINE}. ${url} is NOT protected: ${RESPONSE}"
  fi

done <$SITE_LIST

echo
echo "---------------------"
echo "Checked: ${CHECKED_COUNT}"
echo "Passed: ${PROTECTED_COUNT}"
echo "Unreachable: ${FAIL_COUNT}"
echo "Unprotected: ${UNPROTECTED_COUNT}"
echo ""
echo

exit 0
