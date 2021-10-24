:

# e.g. WhatsApp_Image_2021-10-23 at 4.38.44 PM.jpeg
# e.g. WhatsApp_Image_2016-12-21_at_13.40.40.jpeg
# e.g. WhatsApp Video 2018-11-17 at 18.51.30.mp4
# e.g. WhatsApp Audio 2018-12-21 at 12.30.30.mp4
# e.g. WhatsApp Ptt 2019-06-07 at 10.13.41.ogg

shopt -s nullglob

set -x

~/bin/rename -v </dev/null \
  \
  's/^ WhatsApp \s+ (Image|Video|Audio|Ptt) \s+ (?<YYYY>....)-(?<mm>..)-(?<dd>..) \s+ at \s+ (?<HH>..?)\.(?<MM>..)\.(?<SS>..) ( \s+ (?<ampm>[AP]M) )? \.(?<suffix>jpeg|mp4|ogg) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}$+{ampm}--___.$+{suffix}/x' \
  \
  "$@"

~/bin/rename -v </dev/null \
  \
  's/^ WhatsApp \s+ (Image|Video|Audio|Ptt) \s+ (?<YYYY>....)-(?<mm>..)-(?<dd>..) \s+ at \s+ (?<HH>..?)\.(?<MM>..)\.(?<SS>..) ( \s+ (?<ampm>[AP]M) )? \s* \( (?<no>\d+) \) \.(?<suffix>jpeg|mp4|ogg) 
     $/999990-000--$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}+{ampm}--___.$+{no}.$+{suffix}/x' \
  \
  "$@"

exit 0

################################################################################

  WhatsApp?Image*.jpeg \
  WhatsApp?Ptt*.ogg \
  WhatsApp?Audio*.mp4 \
  WhatsApp?Video*.mp4
  
  WhatsApp?Image*.jpeg \
  WhatsApp?Ptt*.ogg \
  WhatsApp?Audio*.mp4 \
  WhatsApp?Video*.mp4
