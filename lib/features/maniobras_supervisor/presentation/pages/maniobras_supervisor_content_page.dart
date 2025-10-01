import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/maniobras_supervisor_providers.dart';
import '../widgets/maniobra_card.dart';
import 'maniobra_detail_page.dart';

class ManiobrasSupervisorContentPage extends ConsumerStatefulWidget {
  const ManiobrasSupervisorContentPage({super.key});

  @override
  ConsumerState<ManiobrasSupervisorContentPage> createState() => _ManiobrasSupervisorContentPageState();
}

class _ManiobrasSupervisorContentPageState extends ConsumerState<ManiobrasSupervisorContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maniobras Supervisor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad de impresión en desarrollo'),
                ),
              );
            },
            tooltip: 'Imprimir etiqueta QR',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros rápidos
          _buildFilters(),
          const SizedBox(height: 16),
          // Lista de maniobras
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildManiobrasGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filtroActual = ref.watch(filtroManiobrasProvider);
    final maniobrasFiltradas = ref.watch(maniobrasFiltradasProvider);
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filtros',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${maniobrasFiltradas.length} maniobras',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: FiltroManiobras.values.map((filtro) {
                final isSelected = filtroActual == filtro;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(_getFiltroLabel(filtro)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(filtroManiobrasProvider.notifier).state = filtro;
                      }
                    },
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManiobrasGrid() {
    final maniobras = ref.watch(maniobrasFiltradasProvider);
    
    if (maniobras.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay maniobras para mostrar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona un filtro diferente o espera nuevas asignaciones',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Grid adaptable a escritorio
        final crossAxisCount = (constraints.maxWidth ~/ 380).clamp(1, 4);
        return MasonryGridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: maniobras.length,
          itemBuilder: (_, i) {
            final maniobra = maniobras[i];
            return ManiobraCard(
              maniobra: maniobra,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ManiobraDetailPage(maniobra: maniobra),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _getFiltroLabel(FiltroManiobras filtro) {
    switch (filtro) {
      case FiltroManiobras.todas:
        return 'Todas';
      case FiltroManiobras.hoy:
        return 'Hoy';
      case FiltroManiobras.pendientes:
        return 'Pendientes';
      case FiltroManiobras.enProceso:
        return 'En Proceso';
      case FiltroManiobras.finalizadas:
        return 'Finalizadas';
    }
  }
}
