import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/coordinador_models.dart';
import '../providers/coordinador_providers.dart';

class KanbanPage extends ConsumerWidget {
  const KanbanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiculos = ref.watch(vehiculosStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Control - Vista Kanban'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportKanbanData(context),
            tooltip: 'Exportar datos',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Datos actualizados')),
              );
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: vehiculos.when(
        data: (vehiculosList) => _buildKanbanBoard(context, vehiculosList, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildKanbanBoard(BuildContext context, List<Vehiculo> vehiculos, WidgetRef ref) {
    final etapas = EtapaKanban.values;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: etapas.map((etapa) {
          final vehiculosEtapa = vehiculos.where((v) => v.estado.etapaKanban == etapa).toList();
          
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _buildKanbanColumn(context, etapa, vehiculosEtapa, ref),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKanbanColumn(BuildContext context, EtapaKanban etapa, List<Vehiculo> vehiculos, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la columna
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: etapa.color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: etapa.color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getEtapaIcon(etapa),
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        etapa.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: etapa.color,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: etapa.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        vehiculos.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getEtapaDescription(etapa),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido de la columna
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: vehiculos.isEmpty
                  ? _buildEmptyColumn(etapa)
                  : ListView.builder(
                      itemCount: vehiculos.length,
                      itemBuilder: (context, index) {
                        final vehiculo = vehiculos[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildKanbanCard(context, vehiculo, etapa, ref),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyColumn(EtapaKanban etapa) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getEtapaIcon(etapa),
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Sin vehículos',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _getEmptyMessage(etapa),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanCard(BuildContext context, Vehiculo vehiculo, EtapaKanban etapa, WidgetRef ref) {
    return Draggable<Vehiculo>(
      data: vehiculo,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 200,
          child: _buildCardContent(context, vehiculo, etapa, ref, isDragging: true),
        ),
      ),
      childWhenDragging: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[400]!, style: BorderStyle.solid),
        ),
        child: const Center(
          child: Text('Arrastrando...', style: TextStyle(color: Colors.grey)),
        ),
      ),
      child: DragTarget<Vehiculo>(
        onAccept: (draggedVehiculo) {
          if (draggedVehiculo.id != vehiculo.id) {
            _moveVehiculoToEtapa(context, draggedVehiculo, etapa, ref);
          }
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: candidateData.isNotEmpty
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
            child: _buildCardContent(context, vehiculo, etapa, ref),
          );
        },
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, Vehiculo vehiculo, EtapaKanban etapa, WidgetRef ref, {bool isDragging = false}) {
    final theme = Theme.of(context);
    final minutosEspera = DateTime.now().difference(vehiculo.llegada).inMinutes;
    
    return Card(
      elevation: isDragging ? 8 : 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con placas
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${vehiculo.placasTractor} / ${vehiculo.placasRemolque}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (etapa == EtapaKanban.espera && minutosEspera > 30)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: minutosEspera > 60 ? Colors.red : Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${minutosEspera}m',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            
            // Operador
            Text(
              vehiculo.operador,
              style: theme.textTheme.bodySmall,
            ),
            
            // Transportista
            Text(
              vehiculo.lineaTransportista,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            
            // Supervisor asignado
            if (vehiculo.supervisorAsignado != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.assignment_ind, size: 12, color: Colors.green),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      vehiculo.supervisorAsignado!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            // Botones de acción según la etapa
            if (etapa == EtapaKanban.espera && vehiculo.supervisorAsignado == null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showAssignDialog(context, vehiculo, ref),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text('Asignar', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getEtapaIcon(EtapaKanban etapa) {
    switch (etapa) {
      case EtapaKanban.espera:
        return Icons.schedule;
      case EtapaKanban.asignado:
        return Icons.local_parking;
      case EtapaKanban.enProceso:
        return Icons.play_circle;
      case EtapaKanban.finalizado:
        return Icons.check_circle;
    }
  }

  String _getEtapaDescription(EtapaKanban etapa) {
    switch (etapa) {
      case EtapaKanban.espera:
        return 'Vehículos esperando asignación';
      case EtapaKanban.asignado:
        return 'Supervisor asignado, en patio';
      case EtapaKanban.enProceso:
        return 'Maniobra en curso';
      case EtapaKanban.finalizado:
        return 'Maniobra completada';
    }
  }

  String _getEmptyMessage(EtapaKanban etapa) {
    switch (etapa) {
      case EtapaKanban.espera:
        return 'No hay vehículos en espera';
      case EtapaKanban.asignado:
        return 'No hay vehículos asignados';
      case EtapaKanban.enProceso:
        return 'No hay maniobras activas';
      case EtapaKanban.finalizado:
        return 'No hay maniobras finalizadas';
    }
  }

  void _moveVehiculoToEtapa(BuildContext context, Vehiculo vehiculo, EtapaKanban nuevaEtapa, WidgetRef ref) {
    EstadoVehiculo nuevoEstado;
    
    switch (nuevaEtapa) {
      case EtapaKanban.espera:
        nuevoEstado = EstadoVehiculo.enEspera;
        break;
      case EtapaKanban.asignado:
        nuevoEstado = EstadoVehiculo.enPatio;
        break;
      case EtapaKanban.enProceso:
        nuevoEstado = EstadoVehiculo.enManiobra;
        break;
      case EtapaKanban.finalizado:
        nuevoEstado = EstadoVehiculo.finalizado;
        break;
    }
    
    ref.read(coordinadorStateProvider.notifier).moverVehiculo(vehiculo.id, nuevoEstado);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${vehiculo.placasTractor} movido a ${nuevaEtapa.label}'),
      ),
    );
  }

  void _showAssignDialog(BuildContext context, Vehiculo vehiculo, WidgetRef ref) {
    final supervisores = ref.read(supervisoresProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Asignar Supervisor - ${vehiculo.placasTractor}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: supervisores.map((supervisor) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(supervisor.nombre[0]),
              ),
              title: Text(supervisor.nombre),
              subtitle: Text(supervisor.especialidades.join(', ')),
              onTap: () {
                ref.read(coordinadorStateProvider.notifier).asignarSupervisor(
                  vehiculo.id,
                  supervisor.id,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${supervisor.nombre} asignado a ${vehiculo.placasTractor}'),
                  ),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _exportKanbanData(BuildContext context) {
    // TODO: Implementar exportación de datos kanban
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportando datos kanban...')),
    );
  }
}
