import 'package:flutter/material.dart';
import '../../domain/coordinador_models.dart';

class VehiculoCard extends StatelessWidget {
  const VehiculoCard({
    super.key,
    required this.vehiculo,
    required this.onTap,
    this.onAssign,
    this.showAssignButton = false,
  });

  final Vehiculo vehiculo;
  final VoidCallback onTap;
  final Function(String supervisorId)? onAssign;
  final bool showAssignButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutosEspera = DateTime.now().difference(vehiculo.llegada).inMinutes;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con estado
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: vehiculo.estado.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              vehiculo.estado.icon,
                              size: 16,
                              color: vehiculo.estado.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              vehiculo.estado.label,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: vehiculo.estado.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatTime(vehiculo.llegada),
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${vehiculo.placasTractor} / ${vehiculo.placasRemolque}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Información del vehículo
              _buildInfoRow(Icons.person, 'Operador', vehiculo.operador),
              _buildInfoRow(Icons.business, 'Transportista', vehiculo.lineaTransportista),
              if (vehiculo.supervisorAsignado != null)
                _buildInfoRow(Icons.assignment_ind, 'Supervisor', vehiculo.supervisorAsignado!),
              
              // Tiempo de espera
              if (vehiculo.estado == EstadoVehiculo.enEspera) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: minutosEspera > 60 
                        ? Colors.red.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: minutosEspera > 60 ? Colors.red : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${minutosEspera} min',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: minutosEspera > 60 ? Colors.red : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // Botón de asignación
              if (showAssignButton && vehiculo.supervisorAsignado == null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showAssignDialog(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Asignar Supervisor'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[400]),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showAssignDialog(BuildContext context) {
    // TODO: Implementar diálogo de asignación de supervisor
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Asignar Supervisor'),
        content: const Text('Funcionalidad de asignación en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
