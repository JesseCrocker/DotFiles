ZSH=$HOME/.oh-my-zsh

ZSH_THEME="clean"
COMPLETION_WAITING_DOTS="true"

plugins=(git osx sublime github brew git-flow django fabric github urltools)

source $ZSH/oh-my-zsh.sh

export GOPATH=$HOME/go

# set path
PATH=~/bin:/usr/local/share/python:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin
PATH=$PATH:/Library/Frameworks/GDAL.framework/Programs
PATH=$PATH:/usr/libexec/git-core
PATH=$PATH:$GOPATH/bin

#ssh user names
zstyle ":completion:*" users jessecrocker jesse ubuntu

export EDITOR=emacs

PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
export PYTHONPATH

#setup android enviroment
export ANDROID_HOME=/Volumes/Untitled/android/sdks
PATH=$PATH:$ANDROID_HOME/platform-tools
PATH=$PATH:$ANDROID_HOME/tools

alias android-screenshot="adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' >  screen-`date \"+%m-%d-%H:%M:%S\"`.png"

#aliases for running postgres db from command line
PG_DATA_DIR=/Volumes/Untitled/pgdb/
alias RUN_POSTGRES='postgres -D $PG_DATA_DIR'
alias RUN_POSTGRES_DEBUG='postgres -d 1 -s -D $PG_DATA_DIR'

alias GC_ENV='source ~/python/gaiacloud/bin/activate && cd ~/projects/GaiaCloud/'

PROMPT='%{$fg[$NCOLOR]%}%B%n${SSH_TTY:+@%m}%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%} $(git_prompt_info)%(!.#.$) '

source ~/.droid-devices

export PATH
