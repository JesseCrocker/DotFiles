ZSH=$HOME/.oh-my-zsh

ZSH_THEME="clean"
COMPLETION_WAITING_DOTS="true"

plugins=(git osx sublime github brew git-flow django fabric github urltools)

source $ZSH/oh-my-zsh.sh

# prompt
PROMPT='%{$fg[$NCOLOR]%}%B%n${SSH_TTY:+@%m}%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%} $(git_prompt_info)%(!.#.$) '

# ssh user names
zstyle ":completion:*" users jessecrocker jesse ubuntu

# path
PATH=~/local-bin:~/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin
#PATH=$PATH:/Library/Frameworks/GDAL.framework/Programs
PATH=$PATH:/usr/libexec/git-core

# python
PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
export PYTHONPATH

# Go
export GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin

# Android
export ANDROID_HOME=/Volumes/storage/android/android-sdk-macosx
PATH=$PATH:$ANDROID_HOME/platform-tools
PATH=$PATH:$ANDROID_HOME/tools
alias android-screenshot="adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' >  screen-`date \"+%m-%d-%H:%M:%S\"`.png"
test -e ~/droid-devices && source ~/.droid-devices
export GRADLE_OPTS="-Xmx2048m -Xms256m -XX:MaxPermSize=512m -XX:+CMSClassUnloadingEnabled -XX:+HeapDumpOnOutOfMemoryError"

# aliases for running postgres db from command line
PG_DATA_DIR=/Volumes/Storage/pgdb/
alias RUN_POSTGRES='postgres -D $PG_DATA_DIR'
alias RUN_POSTGRES_DEBUG='postgres -d 1 -s -D $PG_DATA_DIR'

# assorted commands
export EDITOR=emacs
alias ql="quick-look"

export PATH

# geo functions
function gdal_extent() {
    if [ -z "$1" ]; then 
        echo "Missing arguments. Syntax:"
        echo "  gdal_extent <input_raster>"
        return
    fi
    EXTENT=$(gdalinfo $1 |\
        grep "Upper Left\|Lower Right" |\
        sed "s/Upper Left  //g;s/Lower Right //g;s/).*//g" |\
        tr "\n" " " |\
        sed 's/ *$//g' |\
        tr -d "[(,]")
    echo -n "$EXTENT"
}

function ogr_extent() {
    if [ -z "$1" ]; then 
        echo "Missing arguments. Syntax:"
        echo "  ogr_extent <input_vector>"
        return
    fi
    EXTENT=$(ogrinfo -al -so $1 |\
        grep Extent |\
        sed 's/Extent: //g' |\
        sed 's/(//g' |\
        sed 's/)//g' |\
        sed 's/ - /, /g')
    EXTENT=`echo $EXTENT | awk -F ',' '{print $1 " " $4 " " $3 " " $2}'`
    echo -n "$EXTENT"
}

function ogr_layer_extent() {
    if [ -z "$2" ]; then 
        echo "Missing arguments. Syntax:"
        echo "  ogr_extent <input_vector> <layer_name>"
        return
    fi
    EXTENT=$(ogrinfo -so $1 $2 |\
        grep Extent |\
        sed 's/Extent: //g' |\
        sed 's/(//g' |\
        sed 's/)//g' |\
        sed 's/ - /, /g')
    EXTENT=`echo $EXTENT | awk -F ',' '{print $1 " " $4 " " $3 " " $2}'`
    echo -n "$EXTENT"
}

function exportf (){
    export $(echo $1)="`whence -f $1 | sed -e "s/$1 //" `"
}

function fp () { 
    ps Ao pid,comm|awk '{match($0,/[^\/]+$/); print substr($0,RSTART,RLENGTH)": "$1}'|grep -i $1|grep -v grep
}

# build a menu of processes matching (case-insensitive, partial) first parameter
# now automatically tries to use the `quit` script if process is a Mac app <http://jon.stovell.info/personal/Software.html>
function fk () {
    local cmd OPT
    IFS=$'\n'
    PS3='Kill which process? (q to cancel): '
    select OPT in $(fp $1); do
        if [[ $OPT =~ [0-9]$ ]]; then
            cmd=$(ps -p ${OPT##* } -o command|tail -n 1)
            if [[ "$cmd" =~ "Contents/MacOS" ]] && [[ -f /usr/local/bin/quit ]]; then
                echo "Quitting ${OPT%%:*}"
                cmd=$(echo "$cmd"| sed -E 's/.*\/(.*)\.app\/.*/\1/')
                /usr/local/bin/quit -n "$cmd"
            else
                echo "killing ${OPT%%:*}"
                kill ${OPT##* }
            fi
        fi
        break
    done
    unset IFS
}

export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
alias symbolicatecrash=/Applications/Xcode.app/Contents/SharedFrameworks/DTDeviceKitBase.framework/Resources/symbolicatecrash
alias timestamp=date +'%s'
