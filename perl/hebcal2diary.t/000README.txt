# …

	    … merge … into ~/diary :
		~/git-servers/github.com/JochenHayek/misc/diary/JHdiary-utils2 --job_merge --left ~/diary --right hebcal--torah-readings-diaspora.20190927124245.csv.diary > ~/transfer/000diary/diary
	    is it alright?
		diff -c ~/diary ~/transfer/000diary/diary
	    then replace ...
		mv --verbose ~/transfer/000diary/diary ~/diary

	    … merge … into ~/diary :
		~/git-servers/github.com/JochenHayek/misc/diary/JHdiary-utils2 --job_merge --left ~/diary --right hebcal--jewish-holidays-all.20190927124604.csv.diary > ~/transfer/000diary/diary
	    is it alright?
		diff -c ~/diary ~/transfer/000diary/diary
	    then replace ...
		mv --verbose ~/transfer/000diary/diary ~/diary

	    … merge … into ~/diary :
		~/git-servers/github.com/JochenHayek/misc/diary/JHdiary-utils2 --job_merge --left ~/diary --right diary.tmp > ~/transfer/000diary/diary

			"now printing the remaining right lines"

	    is it alright?
		diff -c ~/diary ~/transfer/000diary/diary
	    then replace ...
		mv --verbose ~/transfer/000diary/diary ~/diary
