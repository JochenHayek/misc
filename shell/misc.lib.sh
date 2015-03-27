:

# e.g.:
#
# get_key_value NAME /etc/os-release

JHget_key_value()
{
  perl -s -ne 'm/^ \s* ${lhs} \s* = \s* (?<q>")? (?<rhs>[^"]*?) $+{q}? \s* $/x && print "$+{rhs}\n"; ' \
    -- \
    "-lhs=$1" \
    "$2";
}
