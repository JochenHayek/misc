:

##time_stamp='Time-stamp: <2006-08-09 12:19:05 johayek>'
##      rcs_Id='$Id: path.sh 1.9 2006/08/09 10:19:10 johayek Exp $'
## rcs_RCSfile=$(echo '$RCSfile: path.sh $'|cut -d ' ' -f 2)
##  rcs_Source=$(echo '$Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/path/RCS/path.sh $'|cut -d ' ' -f 2)
##  rcs_Locker=$(echo '$Locker:  $'|cut -d ' ' -f 2)
##rcs_Revision=$(echo '$Revision: 1.9 $'|cut -d ' ' -f 2)

path_append()
{
    typeset dir=$1
    # ((
    case "$dir" in
      */)		;;
      *)  dir="$dir/"	;;
    esac

    export                       PATH=$PATH:${dir}bin

    if test -n "$config"
    then :
      ##export                   PATH=$PATH:${dir}$config		# long time ago binaries got installed right under $EXEC_PREFIX, i.e. / e.g. /usr/local/sparc-sun-solaris2.7/
    	export                   PATH=$PATH:${dir}$config/bin		# nowadays, a couple of subdirectories get created below $EXEC_PREFIX, like: bin, lib, libexec, sbin.
    fi

    export                 MANPATH=$MANPATH:${dir}man
    export               INFOPATH=$INFOPATH:${dir}info

    if test  "$USER" = 'root' -o "$LOGNAME" = 'root'
    then export                  PATH=$PATH:${dir}sbin

	if test -n "$config"
	then :
	    export               PATH=$PATH:${dir}$config/sbin
	fi
    fi

    if test "$(echo ${dir}lib/*.so*)" = "${dir}lib/*.so*"
    then :
    else export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${dir}lib
    fi 2>/dev/null
}

path_prepend()
{
    typeset dir=$1
    # ((
    case "$dir" in
      */)		;;
      *)  dir="$dir/"	;;
    esac

    export         MANPATH=${dir}man:$MANPATH
    export        INFOPATH=${dir}info:$INFOPATH

    export   LD_LIBRARY_PATH=${dir}lib:$LD_LIBRARY_PATH
    export              PATH=${dir}bin:$PATH

    if test  "$USER" = 'root' -o "$LOGNAME" = 'root'
    then :
	  export        PATH=${dir}sbin:$PATH
    fi

    if test -n "$config"
    then :
      export LD_LIBRARY_PATH=${dir}$config/lib:$LD_LIBRARY_PATH

    ##export            PATH=${dir}$config:$PATH
      export            PATH=${dir}$config/bin:$PATH

      if test  "$USER" = 'root' -o "$LOGNAME" = 'root'
      then :
          export        PATH=${dir}$config/sbin:$PATH
      fi
    fi


    if test "$(echo ${dir}lib/*.so*)" = "${dir}lib/*.so"
    then :
    else export LD_LIBRARY_PATH=${dir}lib:$LD_LIBRARY_PATH		# ??????
    fi 2>/dev/null
}
