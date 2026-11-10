# Progresso — Atividade Push FCM

Log vivo. Se a sessão cair, retomar por aqui e por `D:\codigos\PLANO_PUSH_FCM.md`.

## Ambiente (feito)
- Tudo em pastas visíveis ao usuário, em `D:\dev`: Flutter 3.47.9 (`D:\dev\flutter`), Android SDK 35/36 (`D:\dev\Android\Sdk`), Firebase CLI (`D:\dev\npm-global\firebase.cmd`).
- JDK: `jbr` (Java 25) do Android Studio, ainda **não testado** em build Gradle.
- ffmpeg instalado via winget (Gyan.FFmpeg).
- AVD `Pixel_7_API_35` (Google Play) criado; WHPX ativo; emulador sobe e dá boot.
- Para usar no Git Bash: `source /d/dev/env.sh`. (`env.ps1` só funciona com `-ExecutionPolicy Bypass`.)
- Chamar o SDK com `android.exe --sdk=... sdk install "pkg;x"`; o `sdkmanager.bat` quebra nomes com `;`.

## Fases
- [x] F1 Ambiente
- [x] F2 App base: compila (Java 25 OK), roda no emulador, token FCM obtido
- [x] F3 Firebase: projeto `agenda-do-campus` (Spark, sem Analytics), app Android registrado, flutterfire configure feito
- [x] F4 Desafio 1: push simples chegou com app em 2º plano (dumpsys + print em agenda_campus_gravacoes/ev_d1.png)
- [x] F5 Repo público: https://github.com/Gaalbu/agenda-campus-push (URL raw da imagem = 200)
- [x] F6 Desafio 2: BigPicture 1024x512 confirmado (ev_d2_exp.png)
- [ ] F7–F9

## Soluções de build (guardar)
- `compileSdk = 37` + `android.suppressUnsupportedCompileSdk=37` (androidx.core 1.19 e flutter_local_notifications 23 exigem; AGP 9.1 recomenda 36).
- `kotlin.incremental=false` no gradle.properties (pub cache em C:, projeto em D: quebra o cache incremental do Kotlin).
- Plataforma `android-37.0` e NDK 28.2.13676358 instalados via `android.exe sdk install`.
- API do flutter_local_notifications 23: `initialize(settings:)` e `show(id:, title:, body:, notificationDetails:)` são nomeados.
- Termos do Firebase aceitos pelo assistente do Console (com autorização do usuário); o `addfirebase` por CLI dava 403 antes disso.
- Token FCM do emulador: `adb logcat -d | grep FCM_TOKEN`.
