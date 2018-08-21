:

# e.g. WhatsApp_Image_2016-12-21_at_13.40.40.jpeg

set -x

~/bin/rename -v \
  \
  's/^ WhatsApp \s+ Image \s+ (?<YYYY>....)-(?<mm>..)-(?<dd>..) \s+ at \s+ (?<HH>..)\.(?<MM>..)\.(?<SS>..) \.jpeg $/$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.jpg/x' \
  \
  WhatsApp?Image*.jpeg

~/bin/rename -v \
  \
  's/^ WhatsApp \s+ Image \s+ (?<YYYY>....)-(?<mm>..)-(?<dd>..) \s+ at \s+ (?<HH>..)\.(?<MM>..)\.(?<SS>..) \( (?<no>\d+) \) \.jpeg $/$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.$+{no}.jpg/x' \
  \
  WhatsApp?Image*.jpeg
