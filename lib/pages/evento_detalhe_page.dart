import 'package:flutter/material.dart';

import '../data/eventos.dart';
import '../services/notificacoes_service.dart';

class EventoDetalhePage extends StatefulWidget {
  final Evento evento;
  const EventoDetalhePage({super.key, required this.evento});

  @override
  State<EventoDetalhePage> createState() => _EventoDetalhePageState();
}

class _EventoDetalhePageState extends State<EventoDetalhePage> {
  bool _interesse = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.evento;
    final porNotificacao = abertosPorNotificacao.contains(e.id);
    return Scaffold(
      appBar: AppBar(title: Text(e.titulo)),
      body: ListView(
        children: [
          Image.asset(e.banner, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (porNotificacao)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.notifications_active, size: 16),
                      SizedBox(width: 6),
                      Text('Aberto pela notificação'),
                    ]),
                  ),
                Text(e.titulo, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(e.categoria, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 16),
                _linha(Icons.schedule, e.data),
                _linha(Icons.place_outlined, e.local),
                _linha(Icons.person_outline, e.organizador),
                const SizedBox(height: 16),
                Text(e.descricao, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => setState(() => _interesse = !_interesse),
                  icon: Icon(_interesse ? Icons.check : Icons.star_border),
                  label: Text(_interesse ? 'Interesse registrado' : 'Tenho interesse'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _linha(IconData icone, String texto) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Icon(icone, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ]),
      );
}
