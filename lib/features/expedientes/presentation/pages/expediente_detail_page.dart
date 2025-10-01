import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/expediente.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/expedientes_notifier.dart';

class ExpedienteDetailPage extends ConsumerWidget {
  const ExpedienteDetailPage({super.key, required this.item});

  final Expediente item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final expedientes = ref.watch(expedientesStateProvider);
    final current = expedientes.firstWhere((e) => e.id == item.id, orElse: () => item);
    return Scaffold(
      appBar: AppBar(title: Text('Detalle ${current.folio}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(current.folio, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 12, runSpacing: 8, children: [
                    _chip('Estado', current.status.label, color: current.status.color),
                    _chip('Cliente', current.cliente),
                    _chip('Bodega', current.bodega),
                    _chip('Creado', current.creadoEn.toString()),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Maniobras', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...current.maniobras.map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(children: [
                          Chip(label: Text(m.tipo.label)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                value: m.avance / 100,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${m.avance}%'),
                          const SizedBox(width: 12),
                          const Icon(Icons.supervisor_account, size: 16),
                          const SizedBox(width: 4),
                          Text(m.supervisor),
                        ]),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Agregar maniobra', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _AddManiobraForm(expedienteId: current.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, String value, {Color? color}) {
    return Chip(
      avatar: color != null ? CircleAvatar(backgroundColor: color) : null,
      label: Text('$label: $value'),
    );
  }
}

class _AddManiobraForm extends StatefulWidget {
  const _AddManiobraForm({required this.expedienteId});
  final String expedienteId;

  @override
  State<_AddManiobraForm> createState() => _AddManiobraFormState();
}

class _AddManiobraFormState extends State<_AddManiobraForm> {
  TipoManiobra _tipo = TipoManiobra.carga;
  final TextEditingController _supervisor = TextEditingController();
  double _avance = 0;

  @override
  void dispose() {
    _supervisor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Column(
        children: [
          Row(
            children: [
              DropdownButton<TipoManiobra>(
                value: _tipo,
                onChanged: (v) => setState(() => _tipo = v ?? TipoManiobra.carga),
                items: TipoManiobra.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                    .toList(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _supervisor,
                  decoration: const InputDecoration(labelText: 'Supervisor'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                final maniobra = Maniobra(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  tipo: _tipo,
                  supervisor: _supervisor.text.trim().isEmpty ? 'Sin asignar' : _supervisor.text.trim(),
                  avance: _avance.round(),
                );
                ref.read(expedientesStateProvider.notifier).addManiobra(
                      expedienteId: widget.expedienteId,
                      maniobra: maniobra,
                    );
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar maniobra'),
            ),
          ),
        ],
      );
    });
  }
}
