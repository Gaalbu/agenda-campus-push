import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'data/eventos.dart';
import 'firebase_options.dart';
import 'pages/evento_detalhe_page.dart';
import 'pages/home_page.dart';
import 'services/notificacoes_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const AgendaCampusApp());
  // Depois do runApp, para que o Navigator exista quando uma mensagem inicial chegar.
  await NotificacoesService.iniciar();
}

class AgendaCampusApp extends StatelessWidget {
  const AgendaCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda do Campus',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/evento') {
          final id = settings.arguments as String?;
          final evento = eventoPorId(id);
          if (evento != null) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => EventoDetalhePage(evento: evento),
            );
          }
        }
        return MaterialPageRoute(settings: settings, builder: (_) => const HomePage());
      },
    );
  }
}
