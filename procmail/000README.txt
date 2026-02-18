# …

use ~/var/log/diary.procmail-from
to find out,
which folders got used:

	Shell command on region: 

		fgrep Folder: | perl -pe 's,/new/.*,,' | sort -u | fgrep -v bulk
