# ...

# $Id: README--diff_and_snapshot.txt 1.3 2017/01/16 17:19:25 johayek Exp johayek $

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

$ ~/list_snapshot_diffs.sh a.txt

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

  ~/Computers/Software/Operating_Systems/Unix/Shell:
  wildcard *snapshot*
  -rwxr-xr-x 1 johayek 501 3672 Dec 21 11:59 create_snapshot.sh
  drwxr-sr-x 2 johayek 501 4096 Feb 26  2015 create_snapshot.t
  -rwxr-xr-x 1 johayek 501 1008 Jan  1  2016 create_snapshots_recursively.sh
  -rwxr-xr-x 1 johayek 501  407 Jan  1  2016 list_snapshot_diffs.sh
  -rwxr-xr-x 1 johayek 501  635 Jan  1  2016 purge_snapshots.sh

################################################################################
