:

time_stamp='Time-stamp: <2002-10-28 16:07:02 johayek>'
      rcs_Id='$Id: path.sh 1.3 2002/10/28 15:07:10 johayek Exp $'
 rcs_RCSfile=$(echo '$RCSfile: path.sh $'|cut -d ' ' -f 2)
  rcs_Source=$(echo '$Source: /Users/johayek/git-servers/github.com/JochenHayek/misc/path/RCS/path.sh $'|cut -d ' ' -f 2)
  rcs_Locker=$(echo '$Locker:  $'|cut -d ' ' -f 2)
rcs_Revision=$(echo '$Revision: 1.3 $'|cut -d ' ' -f 2)

config=$($HOME_JoHa/comp.lang.shell/config.guess)

path_append()
{
    typeset dir=$1
    # ((
    case "$dir" in
      */)		;;
      *)  dir="$dir/"	;;
    esac

    export                       PATH=$PATH:${dir}bin
    test -n "$config" &&
    export                       PATH=$PATH:${dir}$config
    export                 MANPATH=$MANPATH:${dir}man
    export               INFOPATH=$INFOPATH:${dir}info

    if test  "$USER" = 'root' \
       -o "$LOGNAME" = 'root'
    then export                  PATH=$PATH:${dir}sbin
    fi

    if test "$(echo ${dir}lib/*.so*)" = "${dir}lib/*.so*"
    then :
    else export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${dir}lib
    fi
}

path_prepend()
{
    typeset dir=$1
    # ((
    case "$dir" in
      */)		;;
      *)  dir="$dir/"	;;
    esac

    export            PATH=${dir}bin:$PATH
    test -n "$config" &&
    export            PATH=${dir}$config:$PATH
    export LD_LIBRARY_PATH=${dir}lib:$LD_LIBRARY_PATH
    export         MANPATH=${dir}man:$MANPATH
    export        INFOPATH=${dir}info:$INFOPATH

    if test  "$USER" = 'root' \
       -o "$LOGNAME" = 'root'
    then export       PATH=${dir}sbin:$PATH
    fi

    if test "$(echo ${dir}lib/*.so)" = "${dir}lib/*.so"
    then :
    else export LD_LIBRARY_PATH=${dir}lib:$LD_LIBRARY_PATH		# ??????
    fi
}
