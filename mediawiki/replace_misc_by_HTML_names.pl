#! /usr/bin/perl -i~ -p

s/\[/\&lbrack;/g;		# "["
s/\]/\&rbrack;/g;		# "]"

##s/\{/\&lcubk;/g;		# "{"
##s/\}/\&rcub;/g;		# "}"

s/#/\&#35;/g;		# any nicer replacement?

s/\|/{{!}}/g;
