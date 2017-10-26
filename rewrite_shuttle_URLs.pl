#! /usr/bin/perl -w

# in:
#   http://www.b.shuttle.de/hayek/Hayek/Jochen/wp/blog-de/wp-admin/edit.php?post_type=post
#   http://www.b.shuttle.de/hayek/Hayek/Jochen/...
# out:
#   http://Jochen.Hayek.name/wp/blog-de/wp-admin/edit.php?post_type=post
#   http://Jochen.Hayek.name/...

{
  while(<>)
    {
      my($x_n) = $_;
      my($x_B) = $_;

      $x_n =~ s( ^ (?<protocol>https?) :// www\.b\.shuttle\.de/hayek/Hayek/Jochen/ )($+{protocol}://Jochen.Hayek.name/)xi;
      $x_B =~ s( ^ (?<protocol>https?) :// www\.b\.shuttle\.de/hayek/Hayek/Jochen/ )($+{protocol}://Jochen.Hayek.Berlin/)xi;

      print $x_n;
      print $x_B;
    }
}
