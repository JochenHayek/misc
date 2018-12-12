:

# e.g. WhatsApp_Image_2016-12-21_at_13.40.40.jpeg
# e.g. WhatsApp Video 2018-11-17 at 18.51.30.mp4

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ WhatsApp \s+ (Image|Video) \s+ (?<YYYY>....)-(?<mm>..)-(?<dd>..) \s+ at \s+ (?<HH>..)\.(?<MM>..)\.(?<SS>..)                  \.(?<suffix>jpeg|mp4) 
     $/$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  WhatsApp?Image*.jpeg \
  WhatsApp?Video*.mp4

~/bin/rename -v </dev/null \
  \
  's/^ WhatsApp \s+ (Image|Video) \s+ (?<YYYY>....)-(?<mm>..)-(?<dd>..) \s+ at \s+ (?<HH>..)\.(?<MM>..)\.(?<SS>..) \( (?<no>\d+) \) \.(?<suffix>jpeg|mp4) 
     $/$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{no}.$+{suffix}/x' \
  \
  WhatsApp?Image*.jpeg \
  WhatsApp?Video*.mp4
