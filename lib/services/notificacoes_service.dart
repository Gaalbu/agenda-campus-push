import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../data/eventos.dart';

/// Chave do Navigator para abrir telas a partir de uma notificação.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Mensagem do SnackBar quando o id recebido não existe.
final ValueNotifier<String?> avisoGlobal = ValueNotifier<String?>(null);

/// Token FCM atual (mostrado na Home).
final ValueNotifier<String?> tokenFcm = ValueNotifier<String?>(null);

/// Status da permissão de notificações (mostrado na Home).
final ValueNotifier<String> statusPermissao = ValueNotifier<String>('verificando...');

/// Id do evento aberto por notificação, usado para o selo na tela de detalhe.
final Set<String> abertosPorNotificacao = <String>{};

const String canalId = 'eventos_destaque';

final FlutterLocalNotificationsPlugin _locais = FlutterLocalNotificationsPlugin();

/// Handler de mensagens com o app em segundo plano/encerrado (top-level obrigatório).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM_BG: ${message.messageId} data=${message.data}');
}

class NotificacoesService {
  static Future<void> iniciar() async {
    final fcm = FirebaseMessaging.instance;

    // 1) Canal Android de alta importância (heads-up).
    const canal = AndroidNotificationChannel(
      canalId,
      'Eventos em destaque',
      description: 'Avisos sobre eventos do campus',
      importance: Importance.high,
    );
    await _locais
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(canal);

    await _locais.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_stat_evento'),
      ),
      onDidReceiveNotificationResponse: (resp) {
        // Toque em notificação exibida pelo app (primeiro plano).
        if (resp.payload == null || resp.payload!.isEmpty) return;
        final data = Map<String, dynamic>.from(jsonDecode(resp.payload!) as Map);
        abrirPelaMensagem(data);
      },
    );

    // 2) Permissão (diálogo POST_NOTIFICATIONS no Android 13+).
    final settings = await fcm.requestPermission(alert: true, badge: true, sound: true);
    statusPermissao.value = switch (settings.authorizationStatus) {
      AuthorizationStatus.authorized => 'permitidas',
      AuthorizationStatus.denied => 'negadas',
      _ => 'não definidas',
    };

    // 3) Token.
    final token = await fcm.getToken();
    tokenFcm.value = token;
    debugPrint('FCM_TOKEN: $token');
    fcm.onTokenRefresh.listen((t) {
      tokenFcm.value = t;
      debugPrint('FCM_TOKEN: $t');
    });

    // 4) Primeiro plano: o FCM não exibe sozinho; mostramos uma notificação local.
    FirebaseMessaging.onMessage.listen(_aoReceberEmPrimeiroPlano);

    // 5) Segundo plano: usuário tocou na notificação com o app vivo.
    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      debugPrint('FCM_OPENED_APP: ${m.data}');
      abrirPelaMensagem(m.data);
    });

    // 6) App encerrado: foi iniciado pelo toque na notificação.
    final inicial = await fcm.getInitialMessage();
    if (inicial != null) {
      debugPrint('FCM_INITIAL: ${inicial.data}');
      WidgetsBinding.instance.addPostFrameCallback((_) => abrirPelaMensagem(inicial.data));
    }
  }

  static Future<void> _aoReceberEmPrimeiroPlano(RemoteMessage m) async {
    debugPrint('FCM_FG: ${m.notification?.title} data=${m.data}');
    final n = m.notification;
    if (n == null) return;

    StyleInformation? estilo;
    final imagem = n.android?.imageUrl;
    if (imagem != null && imagem.isNotEmpty) {
      try {
        final resp = await http.get(Uri.parse(imagem)).timeout(const Duration(seconds: 10));
        if (resp.statusCode == 200) {
          final arq = File('${Directory.systemTemp.path}/push_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await arq.writeAsBytes(resp.bodyBytes);
          estilo = BigPictureStyleInformation(
            FilePathAndroidBitmap(arq.path),
            contentTitle: n.title,
            summaryText: n.body,
          );
        }
      } catch (e) {
        debugPrint('FCM_IMG_ERRO: $e');
      }
    }

    await _locais.show(
      m.hashCode,
      n.title,
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          canalId,
          'Eventos em destaque',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_stat_evento',
          styleInformation: estilo,
        ),
      ),
      payload: jsonEncode(m.data),
    );
  }

  /// Ponto único de navegação a partir dos dados da mensagem.
  static void abrirPelaMensagem(Map<String, dynamic> data) {
    final tela = data['tela'];
    final id = data['evento_id']?.toString();
    if (tela != 'evento' || id == null) return;

    final nav = navigatorKey.currentState;
    if (nav == null) return;

    if (eventoPorId(id) == null) {
      avisoGlobal.value = 'Evento não encontrado.';
      return;
    }
    abertosPorNotificacao.add(id);
    nav.pushNamed('/evento', arguments: id);
  }
}
