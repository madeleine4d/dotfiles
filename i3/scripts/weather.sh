#!/usr/bin/bash
if [ $BLOCK_BUTTON == 1 ]; then
  kitty --hold echo 'v1.wttr.in?m&format=%l\n%c%t/%f+%h+%w\nRain:+%p\nUV:+%u\nSun+Set:+%s\nMoon:+%m+day+%M\n' 'v1.wttr.in?m&1&F&Q'
fi

curl -Ss 'v1.wttr.in?m&format=1' | xargs echo

