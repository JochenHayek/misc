#! /usr/bin/perl -i~ -p

s/\[/\&lbrack;/g;		# "["
s/\]/\&rbrack;/g;		# "]"

##s/\{/\&lcubk;/g;		# "{"
##s/\}/\&rcub;/g;		# "}"

s/\</\&lt;/g;			# "<"
s/\>/\&gt;/g;			# ">"

s/#/\&num;/g;			# "#"

s/\|/{{!}}/g;
