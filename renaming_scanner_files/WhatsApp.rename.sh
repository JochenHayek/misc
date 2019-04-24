:

# e.g. WhatsApp_Image_2016-12-21_at_13.40.40.jpeg
# e.g. WhatsApp Video 2018-11-17 at 18.51.30.mp4
# e.g. WhatsApp Audio 2018-12-21 at 12.30.30.mp4

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ WhatsApp \s+ (Image|Video|Audio) \s+ (?<YYYY>....)-(?<mm>..)-(?<dd>..) \s+ at \s+ (?<HH>..)\.(?<MM>..)\.(?<SS>..)                  \.(?<suffix>jpeg|mp4) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{suffix}/x' \
  \
  WhatsApp?Image*.jpeg \
  WhatsApp?Audio*.mp4 \
  WhatsApp?Video*.mp4

~/bin/rename -v </dev/null \
  \
  's/^ WhatsApp \s+ (Image|Video|Audio) \s+ (?<YYYY>....)-(?<mm>..)-(?<dd>..) \s+ at \s+ (?<HH>..)\.(?<MM>..)\.(?<SS>..) \( (?<no>\d+) \) \.(?<suffix>jpeg|mp4) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{no}.$+{suffix}/x' \
  \
  WhatsApp?Image*.jpeg \
  WhatsApp?Audio*.mp4 \
  WhatsApp?Video*.mp4
