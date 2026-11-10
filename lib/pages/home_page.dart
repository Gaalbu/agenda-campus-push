import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/eventos.dart';
import '../services/notificacoes_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    avisoGlobal.addListener(_mostrarAviso);
  }

  @override
  void dispose() {
    avisoGlobal.removeListener(_mostrarAviso);
    super.dispose();
  }

  void _mostrarAviso() {
    final msg = avisoGlobal.value;
    if (msg == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    avisoGlobal.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda do Campus')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const _CardNotificacoes(),
          const SizedBox(height: 8),
          for (final e in eventos) _CardEvento(evento: e),
        ],
      ),
    );
  }
}

class _CardNotificacoes extends StatelessWidget {
  const _CardNotificacoes();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<String>(
              valueListenable: statusPermissao,
              builder: (_, s, __) => Row(children: [
                const Icon(Icons.notifications_active_outlined, size: 20),
                const SizedBox(width: 8),
                Text('Notificações: $s', style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(height: 6),
            ValueListenableBuilder<String?>(
              valueListenable: tokenFcm,
              builder: (_, t, __) => Row(children: [
                Expanded(
                  child: Text(
                    t == null ? 'Token FCM: obtendo...' : 'Token FCM: ${t.substring(0, 18)}…',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton.icon(
                  onPressed: t == null
                      ? null
                      : () {
                          Clipboard.setData(ClipboardData(text: t));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text('Token copiado')));
                        },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copiar'),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardEvento extends StatelessWidget {
  final Evento evento;
  const _CardEvento({required this.evento});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed('/evento', arguments: evento.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(evento.banner, height: 140, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(evento.titulo, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('${evento.data} • ${evento.local}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
