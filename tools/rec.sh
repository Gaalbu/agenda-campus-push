#!/usr/bin/env bash
# Gravação de tela do desktop (ffmpeg gdigrab) + tela do emulador (adb screenrecord), com duração fixa.
# Ambos terminam sozinhos (arquivos sempre íntegros).
# Uso:  bash tools/rec.sh start <nome> <segundos>   |   bash tools/rec.sh wait
source /d/dev/env.sh
export MSYS_NO_PATHCONV=1
OUT="D:/codigos/agenda_campus_gravacoes"
mkdir -p "$OUT"
case "$1" in
  start)
    N="$2"; T="${3:-60}"
    rm -f "$OUT/$N.mp4" "$OUT/${N}_emulador.mp4"
    echo "$N" > /d/dev/rec.name
    # tela do aparelho (nativa, nitidez total); limite do Android: 180 s
    adb shell "screenrecord --bit-rate 8000000 --time-limit $T /sdcard/rec_$N.mp4" < /dev/null > /dev/null 2>&1 &
    # desktop inteiro 1920x1080 (Firefox + emulador)
    ffmpeg -y -loglevel error -f gdigrab -framerate 30 -draw_mouse 1 -offset_x 0 -offset_y 0 -video_size 1680x1040 -t "$T" -i desktop \
      -c:v libx264 -preset ultrafast -crf 23 -pix_fmt yuv420p -movflags +faststart "$OUT/$N.mp4" < /dev/null > /d/dev/rec_ffmpeg.log 2>&1 &
    sleep 1
    echo "gravando $N por ${T}s"
    ;;
  wait)
    N=$(cat /d/dev/rec.name)
    while tasklist /FI "IMAGENAME eq ffmpeg.exe" 2>/dev/null | grep -qi ffmpeg; do sleep 1; done
    sleep 2
    adb pull "/sdcard/rec_$N.mp4" "$OUT/${N}_emulador.mp4" > /dev/null 2>&1
    adb shell "rm /sdcard/rec_$N.mp4" > /dev/null 2>&1
    for f in "$OUT/$N.mp4" "$OUT/${N}_emulador.mp4"; do
      [ -f "$f" ] && echo "$(basename "$f"): $(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f")s $(du -h "$f" | cut -f1)"
    done
    ;;
esac
