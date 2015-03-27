:

# e.g.:
#
# get_key_value NAME /etc/os-release

get_key_value()
{
  perl -s -ne 'm/^ ${lhs} = ( ?<q>")? (?<rhs>[^"]*?) $+{q}? $/x && print "$+{rhs}\n"; ' \
    -- \
    "-lhs=$1" \
    "$2";
}
