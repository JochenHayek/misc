:

# before:
#
#   VirtualBox_win-en-uk_09_05_2018_17_25_35.png
#
# after:
#
#   VirtualBox_win-en-uk.20180509172535.png

shopt -s nullglob

set -x

~/bin/rename -v 'y/ /_/; s/^ (?<prefix>VirtualBox_.*) _ (?<d>\d{2}) _ (?<m>\d{2}) _ (?<Y>\d{4}) _ (?<H>\d{2}) _ (?<M>\d{2}) _ (?<S>\d{2}) \.png$/$+{prefix}.$+{Y}$+{m}$+{d}$+{H}$+{M}$+{S}.png/x' VirtualBox_*_*.png
