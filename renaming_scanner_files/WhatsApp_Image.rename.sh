:

# e.g. WhatsApp_Image_2016-12-21_at_13.40.40.jpeg

set -x

~/bin/rename \
  \
  's/^ WhatsApp.Image. (?<YYYY>....)-(?<mm>..)-(?<dd>..) . at . (?<HH>..)\.(?<MM>..)\.(?<SS>..) \.jpeg $/$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}--___.jpg/x' \
  \
  WhatsApp?Image*.jpeg
