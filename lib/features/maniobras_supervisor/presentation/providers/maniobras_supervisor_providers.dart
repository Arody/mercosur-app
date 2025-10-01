import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/maniobra_supervisor.dart';

final maniobrasSupervisorRepositoryProvider = Provider<List<ManiobraSupervisor>>((ref) {
  // Datos fake para las maniobras de supervisores
  final now = DateTime.now();
  
  return [
    ManiobraSupervisor(
      id: 'ms1',
      expedienteId: '1',
      datosMercancia: const DatosMercancia(
        cliente: 'ACME S.A.',
        tipoCarga: 'Productos electrónicos',
        numeroBultos: 45,
        peso: 1250.5,
        remisionFactura: 'REM-2024-001',
        descripcionMercancia: 'Dispositivos móviles y accesorios',
      ),
      datosVehiculo: const DatosVehiculo(
        placasTractor: 'ABC-123',
        placasRemolque: 'DEF-456',
        lineaTransportista: 'Transp. A',
        nombreOperador: 'Carlos Mendoza',
        telefonoOperador: '555-0123',
        tipoUnidad: TipoUnidad.caja,
      ),
      horaInicioProgramada: now.subtract(const Duration(hours: 1)),
      horaInicioReal: now.subtract(const Duration(minutes: 45)),
      estado: EstadoManiobra.enProceso,
      supervisorAsignado: 'Laura García',
      checklists: {
        TipoChecklist.antes: [
          const ChecklistItem(
            id: 'c1',
            descripcion: 'Estado del piso de caja/plataforma/jaula',
            completado: true,
          ),
          const ChecklistItem(
            id: 'c2',
            descripcion: 'Llantas en buen estado + presión',
            completado: true,
          ),
          const ChecklistItem(
            id: 'c3',
            descripcion: 'Tuercas completas',
            completado: true,
          ),
          const ChecklistItem(
            id: 'c4',
            descripcion: 'Luces e intermitentes funcionando',
            completado: false,
          ),
          const ChecklistItem(
            id: 'c5',
            descripcion: 'Sonidos y reflejantes reglamentarios',
            completado: false,
          ),
          const ChecklistItem(
            id: 'c6',
            descripcion: 'Equipos de sujeción y protección',
            completado: true,
          ),
        ],
        TipoChecklist.durante: [
          const ChecklistItem(
            id: 'd1',
            descripcion: 'Foto inicial de descarga',
            completado: true,
          ),
          const ChecklistItem(
            id: 'd2',
            descripcion: 'Foto mitad de maniobra',
            completado: false,
          ),
          const ChecklistItem(
            id: 'd3',
            descripcion: 'Registro de anomalías',
            completado: false,
          ),
        ],
        TipoChecklist.finalizado: [],
      },
      fotosGenerales: ['foto1.jpg', 'foto2.jpg'],
    ),
    ManiobraSupervisor(
      id: 'ms2',
      expedienteId: '2',
      datosMercancia: const DatosMercancia(
        cliente: 'Globex Corp.',
        tipoCarga: 'Materias primas',
        numeroBultos: 120,
        peso: 3200.0,
        remisionFactura: 'FAC-2024-002',
        descripcionMercancia: 'Materiales para construcción',
      ),
      datosVehiculo: const DatosVehiculo(
        placasTractor: 'GHI-789',
        placasRemolque: 'JKL-012',
        lineaTransportista: 'Transp. B',
        nombreOperador: 'Ana Rodríguez',
        telefonoOperador: '555-0456',
        tipoUnidad: TipoUnidad.plataforma,
      ),
      horaInicioProgramada: now.add(const Duration(hours: 2)),
      estado: EstadoManiobra.pendiente,
      supervisorAsignado: 'Pablo López',
      checklists: {
        TipoChecklist.antes: [
          const ChecklistItem(id: 'c1', descripcion: 'Estado del piso de caja/plataforma/jaula'),
          const ChecklistItem(id: 'c2', descripcion: 'Llantas en buen estado + presión'),
          const ChecklistItem(id: 'c3', descripcion: 'Tuercas completas'),
          const ChecklistItem(id: 'c4', descripcion: 'Luces e intermitentes funcionando'),
          const ChecklistItem(id: 'c5', descripcion: 'Sonidos y reflejantes reglamentarios'),
          const ChecklistItem(id: 'c6', descripcion: 'Equipos de sujeción y protección'),
        ],
        TipoChecklist.durante: [],
        TipoChecklist.finalizado: [],
      },
    ),
    ManiobraSupervisor(
      id: 'ms3',
      expedienteId: '3',
      datosMercancia: const DatosMercancia(
        cliente: 'Initech',
        tipoCarga: 'Productos químicos',
        numeroBultos: 25,
        peso: 850.0,
        remisionFactura: 'REM-2024-003',
        descripcionMercancia: 'Químicos industriales',
      ),
      datosVehiculo: const DatosVehiculo(
        placasTractor: 'MNO-345',
        placasRemolque: 'PQR-678',
        lineaTransportista: 'Transp. C',
        nombreOperador: 'Miguel Torres',
        telefonoOperador: '555-0789',
        tipoUnidad: TipoUnidad.jaula,
      ),
      horaInicioProgramada: now.subtract(const Duration(hours: 3)),
      horaInicioReal: now.subtract(const Duration(hours: 3, minutes: 15)),
      horaFinalizacion: now.subtract(const Duration(minutes: 30)),
      estado: EstadoManiobra.finalizada,
      supervisorAsignado: 'Sofía Martínez',
      checklists: {
        TipoChecklist.antes: [
          const ChecklistItem(
            id: 'c1',
            descripcion: 'Estado del piso de caja/plataforma/jaula',
            completado: true,
          ),
          const ChecklistItem(
            id: 'c2',
            descripcion: 'Llantas en buen estado + presión',
            completado: true,
          ),
          const ChecklistItem(
            id: 'c3',
            descripcion: 'Tuercas completas',
            completado: true,
          ),
          const ChecklistItem(
            id: 'c4',
            descripcion: 'Luces e intermitentes funcionando',
            completado: true,
          ),
          const ChecklistItem(
            id: 'c5',
            descripcion: 'Sonidos y reflejantes reglamentarios',
            completado: true,
          ),
          const ChecklistItem(
            id: 'c6',
            descripcion: 'Equipos de sujeción y protección',
            completado: true,
          ),
        ],
        TipoChecklist.durante: [
          const ChecklistItem(
            id: 'd1',
            descripcion: 'Foto inicial de descarga',
            completado: true,
          ),
          const ChecklistItem(
            id: 'd2',
            descripcion: 'Foto mitad de maniobra',
            completado: true,
          ),
          const ChecklistItem(
            id: 'd3',
            descripcion: 'Registro de anomalías',
            completado: true,
            observaciones: 'Sin anomalías reportadas',
          ),
        ],
        TipoChecklist.finalizado: [
          const ChecklistItem(
            id: 'f1',
            descripcion: '¿Mercancía recibida completa?',
            completado: true,
          ),
          const ChecklistItem(
            id: 'f2',
            descripcion: '¿Mercancía en buen estado?',
            completado: true,
          ),
          const ChecklistItem(
            id: 'f3',
            descripcion: 'Servicios adicionales aplicados',
            completado: false,
          ),
          const ChecklistItem(
            id: 'f4',
            descripcion: 'Fotos finales capturadas',
            completado: true,
          ),
          const ChecklistItem(
            id: 'f5',
            descripcion: 'Firma digital operador',
            completado: true,
          ),
          const ChecklistItem(
            id: 'f6',
            descripcion: 'Firma digital supervisor',
            completado: true,
          ),
        ],
      },
      fotosGenerales: ['foto_final1.jpg', 'foto_final2.jpg', 'foto_final3.jpg'],
    ),
    ManiobraSupervisor(
      id: 'ms4',
      expedienteId: '4',
      datosMercancia: const DatosMercancia(
        cliente: 'Umbrella Co.',
        tipoCarga: 'Productos alimentarios',
        numeroBultos: 80,
        peso: 1800.0,
        remisionFactura: 'FAC-2024-004',
        descripcionMercancia: 'Productos congelados',
      ),
      datosVehiculo: const DatosVehiculo(
        placasTractor: 'STU-901',
        placasRemolque: 'VWX-234',
        lineaTransportista: 'Transp. A',
        nombreOperador: 'Roberto Silva',
        telefonoOperador: '555-0321',
        tipoUnidad: TipoUnidad.rabon,
      ),
      horaInicioProgramada: now.add(const Duration(hours: 4)),
      estado: EstadoManiobra.pendiente,
      supervisorAsignado: 'Laura García',
      checklists: {
        TipoChecklist.antes: [
          const ChecklistItem(id: 'c1', descripcion: 'Estado del piso de caja/plataforma/jaula'),
          const ChecklistItem(id: 'c2', descripcion: 'Llantas en buen estado + presión'),
          const ChecklistItem(id: 'c3', descripcion: 'Tuercas completas'),
          const ChecklistItem(id: 'c4', descripcion: 'Luces e intermitentes funcionando'),
          const ChecklistItem(id: 'c5', descripcion: 'Sonidos y reflejantes reglamentarios'),
          const ChecklistItem(id: 'c6', descripcion: 'Equipos de sujeción y protección'),
        ],
        TipoChecklist.durante: [],
        TipoChecklist.finalizado: [],
      },
    ),
  ];
});

// Filtros para las maniobras
enum FiltroManiobras { todas, hoy, pendientes, enProceso, finalizadas }

final filtroManiobrasProvider = StateProvider<FiltroManiobras>((ref) => FiltroManiobras.todas);

final maniobrasFiltradasProvider = Provider<List<ManiobraSupervisor>>((ref) {
  final list = ref.watch(maniobrasSupervisorRepositoryProvider);
  final filtro = ref.watch(filtroManiobrasProvider);
  
  switch (filtro) {
    case FiltroManiobras.todas:
      return list;
    case FiltroManiobras.hoy:
      final hoy = DateTime.now();
      return list.where((m) {
        final fechaManiobra = m.horaInicioProgramada;
        return fechaManiobra.year == hoy.year &&
               fechaManiobra.month == hoy.month &&
               fechaManiobra.day == hoy.day;
      }).toList();
    case FiltroManiobras.pendientes:
      return list.where((m) => m.estado == EstadoManiobra.pendiente).toList();
    case FiltroManiobras.enProceso:
      return list.where((m) => m.estado == EstadoManiobra.enProceso).toList();
    case FiltroManiobras.finalizadas:
      return list.where((m) => m.estado == EstadoManiobra.finalizada).toList();
  }
});

// Provider para actualizar maniobras
class ManiobrasSupervisorNotifier extends StateNotifier<List<ManiobraSupervisor>> {
  ManiobrasSupervisorNotifier(List<ManiobraSupervisor> initial) : super(initial);

  void updateManiobra(ManiobraSupervisor maniobraActualizada) {
    state = state.map((m) => m.id == maniobraActualizada.id ? maniobraActualizada : m).toList();
  }

  void updateChecklistItem({
    required String maniobraId,
    required TipoChecklist tipoChecklist,
    required String itemId,
    required ChecklistItem itemActualizado,
  }) {
    state = state.map((m) {
      if (m.id == maniobraId) {
        final checklistsActualizados = Map<TipoChecklist, List<ChecklistItem>>.from(m.checklists);
        final itemsActualizados = checklistsActualizados[tipoChecklist] ?? [];
        final index = itemsActualizados.indexWhere((item) => item.id == itemId);
        
        if (index != -1) {
          itemsActualizados[index] = itemActualizado;
          checklistsActualizados[tipoChecklist] = itemsActualizados;
        }
        
        return m.copyWith(checklists: checklistsActualizados);
      }
      return m;
    }).toList();
  }

  void iniciarManiobra(String maniobraId) {
    state = state.map((m) {
      if (m.id == maniobraId) {
        return m.copyWith(
          estado: EstadoManiobra.enProceso,
          horaInicioReal: DateTime.now(),
        );
      }
      return m;
    }).toList();
  }

  void finalizarManiobra(String maniobraId) {
    state = state.map((m) {
      if (m.id == maniobraId) {
        return m.copyWith(
          estado: EstadoManiobra.finalizada,
          horaFinalizacion: DateTime.now(),
        );
      }
      return m;
    }).toList();
  }
}

final maniobrasSupervisorStateProvider =
    StateNotifierProvider<ManiobrasSupervisorNotifier, List<ManiobraSupervisor>>((ref) {
  final initial = ref.watch(maniobrasSupervisorRepositoryProvider);
  return ManiobrasSupervisorNotifier(initial);
});
