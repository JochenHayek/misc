# …

$ ~/bin/rename -v 's/^ (?<prefix>IMG|VID) _ (?<YYYYmmdd>\d{8}) _ (?<HHMMSS>\d{6})/999990-000--$+{YYYYmmdd}$+{HHMMSS}--___/x' *.jpg *.mp4

$ ~/bin/rename -v 's/^ 999990-000-- //x' 999990-*
