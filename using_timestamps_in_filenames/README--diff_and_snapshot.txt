# ...

# git-servers/github.com/JochenHayek/misc/using_timestamps_in_filenames/README--diff_and_snapshot.txt

################################################################################
################################################################################
################################################################################

*** diffs ***

# * list_diffs.sh
# * list_snapshot_diffs.sh -- variant of list_diffs.sh targeted esp. towards snapshots

# * diff_last_2.sh
#   * quite well suited for lists of snapshots
#   * but very well usable in general

################################################################################
################################################################################
################################################################################

*** snapshots ***

################################################################################

# for many files at a time:

$ ~/bin/create_snapshot.sh *.txt *.sh *.pl *~

* creates snapshots for non-~-files
* creates snapshots for ~-files
* removes "*~", if the resp. snapshot file already exists.

################################################################################

# ...:

$ ~/bin/purge_snapshots.sh DIR

################################################################################

# for single arguments only:

$ ~/bin/list_snapshot_diffs.sh a.txt

################################################################################
################################################################################
################################################################################

  ~/Computers/Software/Operating_Systems/Unix/Shell:
  wildcard *diff*
  -r-xr-xr-x 1 johayek 501 731 Nov 20  2008 JHdiff_and_rm.sh
  -r-xr-xr-x 1 johayek 501 617 Nov 20  2008 diff_certain_files_within_2_dirs.sh
  -rwxr-xr-x 1 johayek 501 564 Dec  1 14:43 diff_last_2.sh
  -r-xr-xr-x 1 johayek 501 516 Nov 14  2007 diff_n.sh
  -rwxr-xr-x 1 johayek 501 915 Aug  5  2013 diff_n_silent.sh
  -rwxr-xr-x 1 johayek 501 202 Jan  1  2016 list_diffs.sh
  -rwxr-xr-x 1 johayek 501 407 Jan  1  2016 list_snapshot_diffs.sh

################################################################################

  git-servers/github.com/JochenHayek/misc/using_timestamps_in_filenames:
  wildcard *snapshot*
  -rw-r--r--  1 johayek _lpoperator 2753 04-05 20:05 README--diff_and_snapshot.txt
  -rwxr-xr-x  1 johayek _lpoperator 7304 04-15 08:40 create_snapshot.sh
  drwxr-xr-x  4 johayek _lpoperator  128 2018-01-18  create_snapshot.t
  -rwxr-xr-x  1 johayek _lpoperator 6451 2021-07-13  create_snapshot_from_ODF.sh
  -rwxr-xr-x  1 johayek _lpoperator 7715 2021-07-13  create_snapshot_from_OOXML.sh
  drwxr-xr-x  6 johayek _lpoperator  192 2020-04-27  create_snapshot_from_OOXML.t
  -rwxr-xr-x  1 johayek _lpoperator 5952 04-18 12:13 create_snapshot_from_zip_using_7z.sh
  -rwxr-xr-x  1 johayek _lpoperator  737 2018-06-04  list_snapshot_diffs.sh
  -rwxr-xr-x  1 johayek _lpoperator 1620 2021-07-13  purge_snapshots.sh
  -rwxr-xr-x  1 johayek _lpoperator 1485 2019-01-22  snapshots2git.sh

################################################################################
