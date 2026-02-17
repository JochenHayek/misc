:

# emacs-shell $ FIRST_NAME='___' LAST_NAME='___' TOWN='___' COUNTRY='Germany' EMAIL_ADDRESS='___' ORG='___' PHONE_NUMBE='+49___' ~/git-servers/github.com/JochenHayek/misc/shell/create_vcf.sh | tee ~/transfer--DEFINITELY_NON-PERMANENT/___.vcf
# emacs-shell $ FIRST_NAME='___' LAST_NAME='___' TOWN='___' COUNTRY='Germany' EMAIL_ADDRESS='___' ORG='___' PHONE_NUMBE='+49___' ~/bin/create_vcf.sh | tee ~/transfer--DEFINITELY_NON-PERMANENT/___.vcf

# Q: why run it in an emacs shell?
# A: very likely one of the names includes an Umlaut or alike, and bash within the usual terminal bash does not deal with it properly.

################################################################################

cat <<EOF
BEGIN:VCARD
VERSION:3.0
FN;CHARSET=UTF-8: ${FIRST_NAME} ${LAST_NAME}
N;CHARSET=UTF-8:${LAST_NAME};${FIRST_NAME}
NICKNAME;CHARSET=UTF-8:
EMAIL;CHARSET=UTF-8;INTERNET:${EMAIL_ADDRESS}
TEL;TYPE=WORK,VOICE:${PHONE_NUMBE}
ADR;CHARSET=UTF-8;TYPE=WORK:;;;${TOWN};;;${COUNTRY}
ORG;CHARSET=UTF-8:${ORG}
NOTE;CHARSET=UTF-8:

END:VCARD
EOF
