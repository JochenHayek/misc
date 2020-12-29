:

# DYLD_LIBRARY_PATH : according to an ImageMagick.org installation descr. for Mac OS X, this env. var. is being used there

path_append()
{
  typeset dir=$1
  # ((
  case "$dir" in
    */)		;;
    *)  dir="$dir/"	;;
  esac

  export                             PATH=$PATH:${dir}bin
  export                       MANPATH=$MANPATH:${dir}man:${dir}share/man
  export                     INFOPATH=$INFOPATH:${dir}info
  export        LD_LIBRARY_PATH=$LD_LIBRARY_PATH${dir}lib
  export   DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:${dir}lib

  if test -n "$config"
  then :
    export      LD_LIBRARY_PATH=$LD_LIBRARY_PATH${dir}$config/lib
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:${dir}$config/lib
    export                           PATH=$PATH:${dir}$config/bin
  fi

  if test "$USER" = 'root' -o "$LOGNAME" = 'root'
  then :
    export                           PATH=$PATH:${dir}sbin
    if test -n "$config"
    then :
      export                         PATH=$PATH:${dir}$config/sbin
    fi
  fi

##  if test "$(echo ${dir}lib/*.so*)" = "${dir}lib/*.so*"
##  then :
##  else
##    export   LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${dir}lib
##    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:${dir}lib
##  fi 2>/dev/null
}

path_prepend()
{
  typeset dir=$1
  # ((
  case "$dir" in
    */)		;;
    *)  dir="$dir/"	;;
  esac

  export                PATH=${dir}bin:$PATH
  export             MANPATH=${dir}man:${dir}share/man:$MANPATH
  export            INFOPATH=${dir}info:$INFOPATH
  export     LD_LIBRARY_PATH=${dir}lib:$LD_LIBRARY_PATH
  export   DYLD_LIBRARY_PATH=${dir}lib:$DYLD_LIBRARY_PATH

  if test -n "$config"
  then :
    export   LD_LIBRARY_PATH=${dir}$config/lib:$LD_LIBRARY_PATH
    export DYLD_LIBRARY_PATH=${dir}$config/lib:$DYLD_LIBRARY_PATH
    export              PATH=${dir}$config/bin:$PATH
  fi

  if test  "$USER" = 'root' -o "$LOGNAME" = 'root'
  then :
    export            PATH=${dir}sbin:$PATH
    if test -n "$config"
    then :
      export          PATH=${dir}$config/sbin:$PATH
    fi
  fi

##  if test "$(echo ${dir}lib/*.so*)" = "${dir}lib/*.so*"
##  then :
##  else
##    export   LD_LIBRARY_PATH=${dir}lib:$LD_LIBRARY_PATH
##    export DYLD_LIBRARY_PATH=${dir}lib:$DYLD_LIBRARY_PATH
##  fi 2>/dev/null
}
