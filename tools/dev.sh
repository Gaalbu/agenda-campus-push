#!/usr/bin/env bash
# Auxiliares de ADB para os testes e gravações. Uso: source tools/dev.sh
source /d/dev/env.sh
export MSYS_NO_PATHCONV=1
PKG=com.gaalbu.agenda_campus
UI=D:/dev/ui.xml

dump() { adb shell uiautomator dump /sdcard/ui.xml >/dev/null 2>&1; adb pull /sdcard/ui.xml $UI >/dev/null 2>&1; }

# center_of <regex-de-texto>  -> "X Y" do primeiro nó cujo text ou content-desc casa
center_of() {
  dump
  grep -oE "(text|content-desc)=\"[^\"]*\"[^>]*bounds=\"\[[0-9]+,[0-9]+\]\[[0-9]+,[0-9]+\]\"" $UI \
   | grep -E "(text|content-desc)=\"($1)" | head -1 | grep -oE "bounds=\"[^\"]*\"" \
   | sed 's/[^0-9,]/ /g;s/,/ /g' | awk '{print int(($1+$3)/2), int(($2+$4)/2)}'
}
tap_text() { local xy; xy=$(center_of "$1"); if [ -z "$xy" ]; then echo "nao achei: $1"; return 1; fi; adb shell input tap $xy; }

home()        { adb shell input keyevent KEYCODE_HOME; }
open_app()    { adb shell monkey -p $PKG -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1; }
kill_app()    { adb shell input keyevent KEYCODE_HOME; sleep 1; adb shell am kill $PKG; adb shell am kill $PKG; }   # nunca force-stop
shade()       { adb shell cmd statusbar expand-notifications; }
collapse()    { adb shell cmd statusbar collapse; }
clear_notifs() { shade; sleep 1.5; tap_text "Clear all" >/dev/null 2>&1; sleep 1; collapse; }
snap()        { adb exec-out screencap -p > "D:/codigos/agenda_campus_gravacoes/$1.png"; }
