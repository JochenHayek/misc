:

# e.g.:
#
# get_key_value NAME /etc/os-release

JHget_key_value()
{
  perl -s -ne '

    if( m/^ \s* ${lhs} \s* = \s* (?<q>")? (?<rhs>[^"]*?) \g{q}? \s* $/x )
      {
        print "$+{rhs}\n";
        $matched_lhs_p = 1;
      }

    ' \
    \
    -- \
    "-lhs=$1" \
    "-rhs_default=$3" \
    "$2";
}
