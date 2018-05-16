# Check for a 401 status/response
Check for a 401 response code for a list of sites that are supposed to be protected
from prying eyes. Ideally, you'd set this up on a cron task or something. This is
just a quick example of how to do this in bulk with cURL.

## Setup

1. Create a text file to list out the sites you want to check (default is `site_list.txt`)
1. Update the file name in the script if you name it something other than the default

## Running

```bash
./checksites.sh
```

If sites are protected, they get an `OK` and if not, it will tell you. The script
is configured to follow redirects, so don't worry about your 301's, etc.

