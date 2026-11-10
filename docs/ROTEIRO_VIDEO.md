# Roteiro do vídeo (narração em 1ª pessoa)

Duração-alvo: 6–8 min. Os clipes estão em `D:\codigos\agenda_campus_gravacoes\`. Cada clipe tem duas versões:
`<nome>.mp4` (tela do computador: Console do Firebase + emulador) e `<nome>_emulador.mp4` (só o celular, em alta resolução).
Fale por cima dos clipes; as falas abaixo são sugestões, adapte ao seu jeito.

## 1. Abertura (≈30 s) — clipe `01_visao_geral`
> "Oi, eu sou o Gabriel e esta é a minha atividade de notificações push. Fiz o **Agenda do Campus**, um app em Flutter
> que avisa estudantes sobre os eventos da Semana Acadêmica: palestras, hackathon, oficinas e feira de projetos.
> O app tem duas telas: uma lista de eventos e uma tela de detalhes. Ao abrir pela primeira vez ele pede permissão
> de notificações, que é obrigatória no Android 13 em diante."

*Mostrar:* diálogo de permissão → Home → abrir um evento → voltar.

## 2. Por que push faz sentido aqui (≈40 s)
> "Pensei em três situações em que um aviso é útil mesmo com o app fechado: **abrir as inscrições**, **destacar um
> evento com divulgação visual** e **lembrar de um evento prestes a começar**, levando direto à tela dele.
> Cada uma virou um dos desafios."

## 3. Desafio 1 — notificação simples (≈60 s) — clipe `02_desafio1_segundo_plano`
> "Aqui o app está em segundo plano, eu estou na tela inicial do Android. Pelo Firebase Console eu envio:
> título *Inscrições abertas*, texto *A Semana Acadêmica começa segunda, garanta sua vaga nas oficinas*.
> Escolhi esse conteúdo porque é um aviso geral que interessa a todos. Olha ela chegando como *heads-up* e
> ficando na gaveta de notificações."

*Observar:* heads-up no topo, depois a gaveta com título e texto.

## 4. Desafio 2 — notificação com imagem (≈60 s) — clipe `03_desafio2_imagem`
> "No segundo, a notificação leva uma imagem: o banner do **Hackathon 24h**. Escolhi o hackathon porque exige
> inscrição de equipes e um banner chama mais atenção que só texto. No Console eu informo a URL da imagem, que está
> hospedada no próprio repositório do GitHub. Ao expandir a notificação, o banner aparece inteiro."

*Observar:* expandir a notificação (seta) e mostrar o banner.

## 5. Desafio 3 — navegação (≈2 min) — clipes `04_desafio3_segundo_plano` e `05_desafio3_app_encerrado`
> "No terceiro desafio a notificação leva dados junto: no Console, em dados personalizados, coloquei
> `tela = evento` e `evento_id = 3`. O app lê esses dois campos e abre a tela de detalhes do evento 3, a **Oficina de
> Flutter**. Escolhi o id porque ele identifica o evento sem precisar mandar o conteúdo todo na mensagem.
>
> Primeiro com o app em segundo plano: toco na notificação e ele abre direto no detalhe, com o selo *Aberto pela
> notificação*. Agora com o app **encerrado**: eu fecho o app, envio, e toco. O app inicia já na tela do evento 3."

*Observar:* selo "Aberto pela notificação" nos dois casos; no segundo, o app foi fechado antes.

## 6. Bastidores técnicos (≈1 min) — clipe `07_codigo_android_studio`
> "No código, a classe `NotificacoesService` cria um canal de importância alta, pede a permissão, pega o token e
> trata a navegação em **três** lugares: `getInitialMessage` para app encerrado, `onMessageOpenedApp` para segundo
> plano e a notificação local para primeiro plano. Um detalhe que me custou tempo: o `getInitialMessage` precisa ser
> chamado antes de esperar a permissão e o token, senão a mensagem inicial não chega. E para testar o app encerrado
> eu uso `am kill`, nunca `force-stop`, porque o `force-stop` impede o Android de entregar mensagens."

## 7. Extra (opcional, ≈30 s) — clipe `06_extra_primeiro_plano`
> "Com o app aberto o FCM não mostra a notificação sozinho; por isso o app exibe uma notificação local com a imagem.
> Isso não vale ponto, mas mostra o comportamento completo."

## 8. Encerramento (≈15 s)
> "O código está no GitHub: **github.com/Gaalbu/agenda-campus-push**. Obrigado!"
