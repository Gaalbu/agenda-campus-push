#!/usr/bin/env bash
# Gera os banners 1024x512 (JPG) dos eventos com ffmpeg. Uso: source /d/dev/env.sh; bash tools/gerar_banners.sh
set -e
cd "$(dirname "$0")/.."
mkdir -p assets/banners docs/push .tmp_banner
FONT='C\:/Windows/Fonts/arialbd.ttf'

gen() { # arquivo cor1 cor2 linha1 linha2 linha3
  local out="$1" c1="$2" c2="$3"
  printf '%s' "$4" > .tmp_banner/l1.txt
  printf '%s' "$5" > .tmp_banner/l2.txt
  printf '%s' "$6" > .tmp_banner/l3.txt
  ffmpeg -y -loglevel error \
    -f lavfi -i "gradients=s=1024x512:c0=${c1}:c1=${c2}:x0=0:y0=0:x1=1024:y1=512:d=1:n=2" \
    -vf "drawbox=x=0:y=372:w=1024:h=140:color=black@0.35:t=fill,\
drawtext=fontfile='${FONT}':textfile=.tmp_banner/l1.txt:fontcolor=white@0.85:fontsize=34:x=60:y=70,\
drawtext=fontfile='${FONT}':textfile=.tmp_banner/l2.txt:fontcolor=white:fontsize=78:x=60:y=150,\
drawtext=fontfile='${FONT}':textfile=.tmp_banner/l3.txt:fontcolor=white:fontsize=40:x=60:y=412" \
    -frames:v 1 -q:v 3 "$out"
}

gen assets/banners/semana.jpg      0x1565C0 0x42A5F5 "SEMANA ACADEMICA 2026" "Abertura" "Segunda, 09:00 - Auditorio Central"
gen assets/banners/hackathon.jpg   0x4A148C 0xE040FB "CAMPUS HACK" "Hackathon 24h" "Sexta, 18:00 - Laboratorio de Inovacao"
gen assets/banners/flutter.jpg     0x00695C 0x26C6DA "OFICINA PRATICA" "Flutter na pratica" "Terca, 14:00 - Sala 204, Bloco B"
gen assets/banners/feira.jpg       0xE65100 0xFFB74D "EXPOSICAO" "Feira de Projetos" "Quinta, 10:00 - Patio do Campus"
gen assets/banners/carreira.jpg    0x283593 0x7986CB "BATE-PAPO" "Carreira em TI" "Quarta, 19:00 - Auditorio Central"

cp assets/banners/hackathon.jpg docs/push/hackathon.jpg
rm -rf .tmp_banner
ls -la assets/banners docs/push
