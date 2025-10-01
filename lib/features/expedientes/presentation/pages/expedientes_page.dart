import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/new_expediente_wizard.dart';
// import '../../../../core/widgets/metric_card.dart';
import '../../../../core/widgets/side_nav.dart';
// import '../../domain/expediente.dart';
import '../providers/expedientes_providers.dart';
import '../widgets/expediente_card.dart';
import 'expediente_detail_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExpedientesPage extends ConsumerStatefulWidget {
  const ExpedientesPage({super.key});

  @override
  ConsumerState<ExpedientesPage> createState() => _ExpedientesPageState();
}

class _ExpedientesPageState extends ConsumerState<ExpedientesPage> {
  int _navIndex = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNav(
            selectedIndex: _navIndex,
            onSelect: (i) {
              // sólo Expedientes implementado
            },
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Expedientes'),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      builder: (context, controller) => const NewExpedienteWizard(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) =>
                          ref.read(expedientesSearchQueryProvider.notifier).state = value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Buscar por folio, cliente, bodega, tipo o estado…',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildGrid(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final items = ref.watch(filteredExpedientesProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        // Grid adaptable a escritorio
        final crossAxisCount = (constraints.maxWidth ~/ 320).clamp(1, 6);
        return MasonryGridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            return ExpedienteCard(
              item: item,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ExpedienteDetailPage(item: item),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

