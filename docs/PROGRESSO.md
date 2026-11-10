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
- [~] F2 App base: código escrito (Home, detalhe, serviço de notificações, Android configurado); falta compilar
- [ ] F3 Firebase: projeto GCP `agenda-campus-gaalbu` criado, mas `addFirebase` deu 403 (termos do Firebase não aceitos / Firefox sem login)
- [ ] F4–F9

## Bloqueio atual
Firefox (ponte MCP) está deslogado do Google. Precisa do usuário para logar em gabrielalencarem@gmail.com
e aceitar os termos do Firebase em https://console.firebase.google.com.
