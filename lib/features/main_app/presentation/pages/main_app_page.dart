import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/side_nav.dart';
import '../../../expedientes/presentation/pages/expedientes_content_page.dart';
import '../../../maniobras_supervisor/presentation/pages/maniobras_supervisor_content_page.dart';
import '../../../coordinador/presentation/pages/coordinador_content_page.dart';

// Provider para manejar el índice de la página actual
final currentPageIndexProvider = StateProvider<int>((ref) => 1); // Iniciar en Expedientes

class MainAppPage extends ConsumerWidget {
  const MainAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentPageIndexProvider);

    return Scaffold(
      body: Row(
        children: [
          SideNav(
            selectedIndex: currentIndex,
            onSelect: (index) {
              ref.read(currentPageIndexProvider.notifier).state = index;
            },
          ),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: const [
                // Dashboard (índice 0) - placeholder por ahora
                Center(
                  child: Text(
                    'Dashboard\n(En desarrollo)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ),
                // Expedientes (índice 1)
                const ExpedientesContentPage(),
                // Supervisor (índice 2)
                const ManiobrasSupervisorContentPage(),
                // Coordinador (índice 3)
                const CoordinadorContentPage(),
                // Reportes (índice 4) - placeholder por ahora
                Center(
                  child: Text(
                    'Reportes\n(En desarrollo)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

