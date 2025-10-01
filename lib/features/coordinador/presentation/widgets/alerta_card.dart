import 'package:flutter/material.dart';
import '../../domain/coordinador_models.dart';

class AlertaCard extends StatelessWidget {
  const AlertaCard({
    super.key,
    required this.alerta,
    this.onResolve,
    this.onTap,
  });

  final Alerta alerta;
  final VoidCallback? onResolve;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = DateTime.now().difference(alerta.creadaEn);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Icono de alerta
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: alerta.tipo.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  alerta.tipo.icon,
                  color: alerta.tipo.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              
              // Contenido de la alerta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alerta.titulo,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          _formatTimeAgo(timeAgo),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alerta.descripcion,
                      style: theme.textTheme.bodySmall,
                    ),
                    if (alerta.minutosEspera != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: alerta.tipo.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${alerta.minutosEspera} minutos',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: alerta.tipo.color,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Botón de resolución
              if (onResolve != null && !alerta.resuelta) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onResolve,
                  icon: const Icon(Icons.check_circle_outline),
                  color: Colors.green,
                  tooltip: 'Resolver alerta',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(Duration duration) {
    if (duration.inMinutes < 1) {
      return 'Ahora';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inDays}d';
    }
  }
}
