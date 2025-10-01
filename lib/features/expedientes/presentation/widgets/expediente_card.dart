import 'package:flutter/material.dart';
import '../../domain/expediente.dart';
import '../../../../core/widgets/app_card.dart';

class ExpedienteCard extends StatelessWidget {
  const ExpedienteCard({super.key, required this.item, this.onTap});

  final Expediente item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 56,
                decoration: BoxDecoration(
                  color: item.status.color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(item.folio, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.status.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(item.status.label, style: theme.textTheme.labelSmall?.copyWith(color: item.status.color, fontWeight: FontWeight.w700)),
                        ),
                        // const Spacer(),
                        // Icon(_iconByTipo(item.tipo), size: 18),
                        // const SizedBox(width: 4),
                        // Text(item.tipo.label, style: theme.textTheme.labelLarge),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(item.cliente, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 2),
                    Text('Bodega: ${item.bodega}', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (item.maniobras.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Maniobras', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                ...item.maniobras.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(_iconByTipo(m.tipo), size: 14),
                                const SizedBox(width: 4),
                                Text(m.tipo.label, style: theme.textTheme.labelSmall),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                value: m.avance / 100,
                                backgroundColor: Colors.white10,
                                color: item.status.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${m.avance}%', style: theme.textTheme.labelSmall),
                          const SizedBox(width: 8),
                          Icon(Icons.supervisor_account, size: 14),
                          const SizedBox(width: 4),
                          Text(m.supervisor, style: theme.textTheme.labelSmall),
                        ],
                      ),
                    )),
              ],
            ),
        ],
      ),
    );
  }

  IconData _iconByTipo(TipoManiobra t) {
    switch (t) {
      case TipoManiobra.carga:
        return Icons.upload;
      case TipoManiobra.descarga:
        return Icons.download;
      case TipoManiobra.transbordo:
        return Icons.swap_vert;
    }
  }
}
