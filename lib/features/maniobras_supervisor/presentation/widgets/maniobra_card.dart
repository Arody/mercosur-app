import 'package:flutter/material.dart';
import '../../domain/maniobra_supervisor.dart';
import '../../../../core/widgets/app_card.dart';

class ManiobraCard extends StatelessWidget {
  const ManiobraCard({
    super.key,
    required this.maniobra,
    required this.onTap,
  });

  final ManiobraSupervisor maniobra;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con estado
          Row(
            children: [
              Container(
                width: 6,
                height: 60,
                decoration: BoxDecoration(
                  color: maniobra.estado.color,
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
                        Icon(
                          maniobra.estado.icon,
                          size: 16,
                          color: maniobra.estado.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          maniobra.estado.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: maniobra.estado.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(maniobra.horaInicioProgramada),
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      maniobra.datosMercancia.cliente,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      maniobra.datosMercancia.tipoCarga,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Información del vehículo
          _buildInfoRow(
            Icons.local_shipping,
            'Vehículo',
            '${maniobra.datosVehiculo.placasTractor} / ${maniobra.datosVehiculo.placasRemolque}',
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            Icons.person,
            'Operador',
            maniobra.datosVehiculo.nombreOperador,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            Icons.business,
            'Transportista',
            maniobra.datosVehiculo.lineaTransportista,
          ),
          const SizedBox(height: 8),
          
          // Información de la mercancía
          Row(
            children: [
              Expanded(
                child: _buildMetricChip(
                  'Bultos',
                  maniobra.datosMercancia.numeroBultos.toString(),
                  Icons.inventory_2,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricChip(
                  'Peso',
                  '${maniobra.datosMercancia.peso} kg',
                  Icons.scale,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progreso del checklist
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[400]),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final totalChecklists = 3; // antes, durante, final
    int checklistsCompletados = 0;
    
    for (final checklist in maniobra.checklists.values) {
      if (checklist.isNotEmpty && checklist.every((item) => item.completado)) {
        checklistsCompletados++;
      }
    }

    final progress = checklistsCompletados / totalChecklists;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progreso Checklist',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$checklistsCompletados/$totalChecklists',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            minHeight: 6,
            value: progress,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress == 1.0 ? Colors.green : maniobra.estado.color,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
