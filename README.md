# Agenda do Campus — Notificações Push com Flutter + FCM

Atividade prática de *Programação para Dispositivos Móveis*: um app simples em Flutter que usa
**Firebase Cloud Messaging (FCM)** para avisar estudantes sobre os eventos da semana acadêmica.
Plano gratuito Spark, sem backend, sem login, sem banco. As notificações são enviadas manualmente pelo Firebase Console.

## Finalidade e público
Estudantes e visitantes de um campus acompanham a programação da **Semana Acadêmica** (palestras, hackathon, oficinas,
feira de projetos). O app tem duas telas:

| Tela | O que mostra |
|---|---|
| **Home** | Lista de eventos (banner, data, local) e um cartão com o status da permissão de notificações e o token FCM (botão "Copiar") |
| **Detalhe do evento** | Banner, título, data, local, organizador, descrição e botão "Tenho interesse". Quando aberta por uma notificação, mostra o selo **"Aberto pela notificação"** |

Os eventos ficam fixos em [`lib/data/eventos.dart`](lib/data/eventos.dart).

## As três notificações

Enviadas em *Firebase Console → Messaging → Nova campanha → Notificações do Firebase*.

| # | Situação | Título | Texto | Imagem | Dados personalizados |
|---|---|---|---|---|---|
| 1 | Abertura das inscrições | `Inscrições abertas! 🎓` | `A Semana Acadêmica começa segunda. Garanta sua vaga nas oficinas antes que esgotem.` | — | — |
| 2 | Evento em destaque | `Hackathon 24h: destaque da semana 🚀` | `Equipes de até 4 pessoas, prêmios e mentoria. Confira o banner!` | `https://raw.githubusercontent.com/Gaalbu/agenda-campus-push/main/docs/push/hackathon.jpg` | — |
| 3 | Evento prestes a começar | `Começa em 30 min: Oficina de Flutter` | `Sala 204, Bloco B. Toque para ver os detalhes.` | — | `tela = evento`, `evento_id = 3` |

**Por quê:** (1) é um aviso geral, útil mesmo com o app fechado; (2) um banner atrai mais atenção para um evento que
exige inscrição de equipes; (3) um lembrete só é útil se levar o aluno direto aos detalhes (sala, horário).

## Como cada requisito foi atendido

- **Segundo plano (D1):** mensagens do tipo *notification* são exibidas pelo próprio sistema. O canal Android
  `eventos_destaque` (importância alta) é criado no app e declarado no `AndroidManifest.xml`
  (`default_notification_channel_id`), para a notificação aparecer como *heads-up*.
- **Imagem (D2):** o campo "Imagem de notificação" do Console envia a URL; o Android baixa e mostra em `BigPictureStyle`.
  Com o app em primeiro plano, o FCM não exibe nada sozinho; por isso o app baixa a imagem e mostra uma notificação
  local com `flutter_local_notifications`.
- **Navegação (D3):** ponto único `NotificacoesService.abrirPelaMensagem` lê `tela` e `evento_id` e faz `pushNamed('/evento')`.
  Ligado a **três** caminhos: `getInitialMessage()` (app encerrado), `onMessageOpenedApp` (segundo plano) e
  `onDidReceiveNotificationResponse` (notificação local, primeiro plano). Um id inexistente mostra "Evento não encontrado".
  Detalhe importante: `getInitialMessage()` é consultado **antes** de qualquer `await` lento (permissão, token).
- **Permissão:** `requestPermission()` abre o diálogo de `POST_NOTIFICATIONS` (Android 13+).

## Como rodar

```bash
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure --project=<seu-projeto> --platforms=android --android-package-name=com.gaalbu.agenda_campus
flutter run
```

`lib/firebase_options.dart` e `android/app/google-services.json` não são versionados (gerados pelo `flutterfire configure`).
O token FCM aparece no cartão da Home e no log (`FCM_TOKEN`). No Console, use *Enviar mensagem de teste* com esse token,
ou publique a campanha para o app `com.gaalbu.agenda_campus`.

### Testar o app encerrado
Use `adb shell am kill com.gaalbu.agenda_campus` (ou deslize o app nos recentes). **Não use `force-stop`**: o Android passa o app
para o estado *stopped* e não entrega mais mensagens FCM até o usuário abri-lo de novo.

## Estrutura
```
lib/main.dart                         inicialização do Firebase e rotas
lib/services/notificacoes_service.dart  canal, permissão, token, handlers e navegação
lib/pages/home_page.dart, evento_detalhe_page.dart
lib/data/eventos.dart                 dados fixos
tools/                                scripts de apoio (banners, layout de janelas e gravação de tela)
docs/push/hackathon.jpg               imagem usada na notificação 2
docs/ROTEIRO_VIDEO.md, docs/PROGRESSO.md
```

## Ambiente usado
Flutter 3.47, Dart 3.13, Android SDK 35/37, emulador Pixel 7 (API 35, Google Play), Firebase plano Spark.
Problemas de build encontrados e resolvidos estão em [`docs/PROGRESSO.md`](docs/PROGRESSO.md).
