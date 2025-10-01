import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/coordinador_models.dart';
import '../providers/coordinador_providers.dart';
import '../widgets/metric_card.dart';
import '../widgets/vehiculo_card.dart';
import '../widgets/alerta_card.dart';
import 'kanban_page.dart';

class CoordinadorContentPage extends ConsumerWidget {
  const CoordinadorContentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadisticas = ref.watch(estadisticasStreamProvider);
    final alertasActivas = ref.watch(alertasActivasProvider);
    final vehiculosEnEspera = ref.watch(vehiculosEnEsperaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordinador de Patio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_kanban),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const KanbanPage(),
                ),
              );
            },
            tooltip: 'Vista Kanban',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportData(context),
            tooltip: 'Exportar datos',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Datos actualizados'),
                ),
              );
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: estadisticas.when(
        data: (stats) => _buildDashboard(context, stats, alertasActivas, vehiculosEnEspera),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    EstadisticaTiempoReal stats,
    List<Alerta> alertas,
    List<Vehiculo> vehiculosEspera,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Métricas principales
          _buildMetricsSection(context, stats),
          const SizedBox(height: 24),
          
          // Alertas del día
          _buildAlertasSection(context, alertas),
          const SizedBox(height: 24),
          
          // Vehículos en espera
          _buildVehiculosEsperaSection(context, vehiculosEspera),
          const SizedBox(height: 24),
          
          // Acciones rápidas
          _buildAccionesRapidasSection(context),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(BuildContext context, EstadisticaTiempoReal stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard en Tiempo Real',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Determinar número de columnas según ancho disponible
            int crossAxisCount;
            if (constraints.maxWidth < 600) {
              crossAxisCount = 2; // Mobile: 2 columnas
            } else if (constraints.maxWidth < 900) {
              crossAxisCount = 3; // Tablet: 3 columnas
            } else {
              crossAxisCount = 4; // Desktop: 4 columnas
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.6,
              children: [
                MetricCard(
                  title: 'En Espera',
                  value: stats.vehiculosEnEspera.toString(),
                  icon: Icons.schedule,
                  color: Colors.orange,
                  subtitle: '${stats.tiempoPromedioEspera.toStringAsFixed(1)} min promedio',
                  onTap: () => _showVehiculosByEstado(context, EstadoVehiculo.enEspera),
                ),
                MetricCard(
                  title: 'En Patio',
                  value: stats.vehiculosEnPatio.toString(),
                  icon: Icons.local_parking,
                  color: Colors.blue,
                  onTap: () => _showVehiculosByEstado(context, EstadoVehiculo.enPatio),
                ),
                MetricCard(
                  title: 'En Maniobra',
                  value: stats.vehiculosEnManiobra.toString(),
                  icon: Icons.play_circle,
                  color: Colors.green,
                  subtitle: '${stats.tiempoPromedioManiobra.toStringAsFixed(1)} min promedio',
                  onTap: () => _showVehiculosByEstado(context, EstadoVehiculo.enManiobra),
                ),
                MetricCard(
                  title: 'Supervisores',
                  value: stats.supervisoresActivos.toString(),
                  icon: Icons.people,
                  color: Colors.purple,
                  subtitle: 'Activos',
                  onTap: () => _showSupervisores(context),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAlertasSection(BuildContext context, List<Alerta> alertas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Alertas del Día',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: alertas.isEmpty ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                alertas.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (alertas.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'Sin alertas activas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...alertas.take(5).map((alerta) => AlertaCard(
            alerta: alerta,
            onResolve: () => _resolverAlerta(context, alerta.id),
            onTap: () => _verDetalleVehiculo(context, alerta.vehiculoId),
          )),
        if (alertas.length > 5)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton(
              onPressed: () => _verTodasLasAlertas(context),
              child: Text('Ver ${alertas.length - 5} alertas más'),
            ),
          ),
      ],
    );
  }

  Widget _buildVehiculosEsperaSection(BuildContext context, List<Vehiculo> vehiculos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehículos en Espera',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (vehiculos.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.local_shipping, color: Colors.green, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'No hay vehículos en espera',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              // Determinar número de columnas según ancho disponible
              int crossAxisCount;
              if (constraints.maxWidth < 600) {
                crossAxisCount = 1; // Mobile: 1 columna
              } else if (constraints.maxWidth < 900) {
                crossAxisCount = 2; // Tablet: 2 columnas
              } else {
                crossAxisCount = 3; // Desktop: 3 columnas
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: vehiculos.length,
                itemBuilder: (context, index) {
                  final vehiculo = vehiculos[index];
                  return VehiculoCard(
                    vehiculo: vehiculo,
                    showAssignButton: true,
                    onTap: () => _verDetalleVehiculo(context, vehiculo.id),
                    onAssign: (supervisorId) => _asignarSupervisor(context, vehiculo.id, supervisorId),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildAccionesRapidasSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            // Determinar número de columnas según ancho disponible
            int crossAxisCount;
            double childAspectRatio;
            
            if (constraints.maxWidth < 600) {
              crossAxisCount = 1; // Mobile: 1 columna
              childAspectRatio = 4.0;
            } else if (constraints.maxWidth < 900) {
              crossAxisCount = 2; // Tablet: 2 columnas
              childAspectRatio = 3.5;
            } else {
              crossAxisCount = 3; // Desktop: 3 columnas
              childAspectRatio = 3.0;
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
              children: [
                _buildActionCard(
                  context,
                  'Asignar Supervisor',
                  Icons.assignment_ind,
                  Colors.blue,
                  () => _mostrarAsignacionMasiva(context),
                ),
                _buildActionCard(
                  context,
                  'Historial Turnos',
                  Icons.history,
                  Colors.purple,
                  () => _mostrarHistorial(context),
                ),
                _buildActionCard(
                  context,
                  'Exportar CSV',
                  Icons.table_chart,
                  Colors.green,
                  () => _exportToCSV(context),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos de navegación y acciones
  void _showVehiculosByEstado(BuildContext context, EstadoVehiculo estado) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mostrando vehículos: ${estado.label}')),
    );
  }

  void _showSupervisores(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vista de supervisores en desarrollo')),
    );
  }

  void _resolverAlerta(BuildContext context, String alertaId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alerta resuelta')),
    );
  }

  void _verDetalleVehiculo(BuildContext context, String vehiculoId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Detalle vehículo: $vehiculoId')),
    );
  }

  void _verTodasLasAlertas(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vista completa de alertas en desarrollo')),
    );
  }

  void _asignarSupervisor(BuildContext context, String vehiculoId, String supervisorId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Supervisor asignado')),
    );
  }

  void _mostrarAsignacionMasiva(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Asignación masiva en desarrollo')),
    );
  }

  void _mostrarHistorial(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Historial de turnos en desarrollo')),
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidad de exportación en desarrollo')),
    );
  }

  void _exportToCSV(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportando datos a CSV...')),
    );
  }
}
