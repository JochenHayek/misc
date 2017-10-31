:

# -> ~/Computers/Software/Operating_Systems/Unix/Shell/README--rename.txt

################################################################################

# /scp:localhost#2222:Computers/Software/Operating_Systems/Unix/Shell/Telefax-rename.sh
# /scp:localhost#2222:Computers/Software/Operating_Systems/Unix/Shell/
# ~/Downloads/_fax/Telefax-rename.sh

################################################################################

# samples:

#   01.10.13_07.43_Telefax.unbekannt.pdf
#   26.05.13_08.00_Telefax.033202700199.pdf

################################################################################

# replacement à la Emacs dired mode:

# ================================================================================
# = -> 26.05.13_08.00_Telefax.033202700199.pdf
# ================================================================================
# ^\(..\)\.\(..\)\.\(..\)_\(..\)\.\(..\)_Telefax\.\([0-9a-z]*\)\(.*\)$
# ================================================================================
# 20\3\2\1\4\5__--From_\6.Telefax\7
# ================================================================================

################################################################################

set -x

~/Computers/Programming/Languages/Perl/rename \
  \
  's/^
     (?<dd>\d\d) \. (?<mm>\d\d) \. (?<YY>\d\d) _ (?<HH>\d\d) \. (?<MM>\d\d)
     _
     (?<device>.*)
     \.
     (?<From>.*)
     \.
     (?<extension>.*)
     $
    /999990-000--20$+{YY}$+{mm}$+{dd}$+{HH}$+{MM}__--From_$+{From}_$+{device}.$+{extension}/x' \
  \
  ??.??.??_??.??_Telefax.*.pdf
