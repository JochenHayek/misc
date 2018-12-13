# …

$ ~/bin/rename -v 's/^ IMG_ (?<YYYYmmdd>\d{8}) _ (?<HHMMSS>\d{6})/$+{YYYYmmdd}$+{HHMMSS}--___/x' *.jpg
