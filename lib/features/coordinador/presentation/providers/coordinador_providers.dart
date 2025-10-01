import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/coordinador_models.dart';

// Simulador de datos en tiempo real
class CoordinadorDataSimulator {
  static final CoordinadorDataSimulator _instance = CoordinadorDataSimulator._internal();
  factory CoordinadorDataSimulator() => _instance;
  CoordinadorDataSimulator._internal();

  final StreamController<List<Vehiculo>> _vehiculosController = StreamController.broadcast();
  final StreamController<List<Alerta>> _alertasController = StreamController.broadcast();
  final StreamController<EstadisticaTiempoReal> _estadisticasController = StreamController.broadcast();

  Stream<List<Vehiculo>> get vehiculosStream => _vehiculosController.stream;
  Stream<List<Alerta>> get alertasStream => _alertasController.stream;
  Stream<EstadisticaTiempoReal> get estadisticasStream => _estadisticasController.stream;

  Timer? _updateTimer;

  void startSimulation() {
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _simulateDataUpdate();
    });
  }

  void stopSimulation() {
    _updateTimer?.cancel();
  }

  void _simulateDataUpdate() {
    // Simular cambios en tiempo real
    final now = DateTime.now();
    
    // Actualizar estadísticas
    final stats = _calculateStats();
    _estadisticasController.add(stats);
    
    // Generar alertas dinámicas
    final alertas = _generateAlerts(now);
    _alertasController.add(alertas);
    
    // Actualizar vehículos (simular cambios de estado)
    final vehiculos = _getVehiculosWithUpdates(now);
    _vehiculosController.add(vehiculos);
  }

  EstadisticaTiempoReal _calculateStats() {
    final vehiculos = _getCurrentVehiculos();
    return EstadisticaTiempoReal(
      vehiculosEnEspera: vehiculos.where((v) => v.estado == EstadoVehiculo.enEspera).length,
      vehiculosEnPatio: vehiculos.where((v) => v.estado == EstadoVehiculo.enPatio).length,
      vehiculosEnManiobra: vehiculos.where((v) => v.estado == EstadoVehiculo.enManiobra).length,
      vehiculosFinalizados: vehiculos.where((v) => v.estado == EstadoVehiculo.finalizado).length,
      supervisoresActivos: 8, // Fake data
      alertasActivas: _getCurrentAlertas().where((a) => !a.resuelta).length,
      tiempoPromedioEspera: 45.5,
      tiempoPromedioManiobra: 120.3,
    );
  }

  List<Alerta> _generateAlerts(DateTime now) {
    final vehiculos = _getCurrentVehiculos();
    final alertas = <Alerta>[];
    
    for (final vehiculo in vehiculos) {
      final minutosEspera = now.difference(vehiculo.llegada).inMinutes;
      
      // Alerta por espera excesiva (>60 minutos)
      if (vehiculo.estado == EstadoVehiculo.enEspera && minutosEspera > 60) {
        alertas.add(Alerta(
          id: 'alert_${vehiculo.id}_espera',
          tipo: TipoAlerta.esperaExcesiva,
          titulo: 'Espera Excesiva',
          descripcion: '${vehiculo.placasTractor} lleva ${minutosEspera} minutos en espera',
          creadaEn: now,
          vehiculoId: vehiculo.id,
          minutosEspera: minutosEspera,
        ));
      }
      
      // Alerta por retraso en maniobra (>3 horas)
      if (vehiculo.estado == EstadoVehiculo.enManiobra && vehiculo.horaAsignacion != null) {
        final minutosManiobra = now.difference(vehiculo.horaAsignacion!).inMinutes;
        if (minutosManiobra > 180) {
          alertas.add(Alerta(
            id: 'alert_${vehiculo.id}_retraso',
            tipo: TipoAlerta.retraso,
            titulo: 'Retraso en Maniobra',
            descripcion: '${vehiculo.placasTractor} lleva ${minutosManiobra} minutos en maniobra',
            creadaEn: now,
            vehiculoId: vehiculo.id,
            supervisorId: vehiculo.supervisorAsignado,
          ));
        }
      }
    }
    
    return alertas;
  }

  List<Vehiculo> _getVehiculosWithUpdates(DateTime now) {
    final vehiculos = _getCurrentVehiculos();
    return vehiculos.map((vehiculo) {
      // Simular cambio de estado ocasional
      if (vehiculo.estado == EstadoVehiculo.enEspera && 
          now.difference(vehiculo.llegada).inMinutes > 30 &&
          vehiculo.supervisorAsignado == null) {
        // Auto-asignar supervisor después de 30 minutos
        return vehiculo.copyWith(
          supervisorAsignado: 'Laura García',
          horaAsignacion: now,
          estado: EstadoVehiculo.enPatio,
        );
      }
      return vehiculo;
    }).toList();
  }

  List<Vehiculo> _getCurrentVehiculos() {
    final now = DateTime.now();
    return [
      Vehiculo(
        id: 'v1',
        placasTractor: 'ABC-123',
        placasRemolque: 'DEF-456',
        lineaTransportista: 'Transp. A',
        operador: 'Carlos Mendoza',
        telefonoOperador: '555-0123',
        llegada: now.subtract(const Duration(minutes: 75)), // En espera excesiva
        estado: EstadoVehiculo.enEspera,
        expedienteId: '1',
      ),
      Vehiculo(
        id: 'v2',
        placasTractor: 'GHI-789',
        placasRemolque: 'JKL-012',
        lineaTransportista: 'Transp. B',
        operador: 'Ana Rodríguez',
        telefonoOperador: '555-0456',
        llegada: now.subtract(const Duration(minutes: 45)),
        estado: EstadoVehiculo.enPatio,
        supervisorAsignado: 'Pablo López',
        horaAsignacion: now.subtract(const Duration(minutes: 15)),
        expedienteId: '2',
      ),
      Vehiculo(
        id: 'v3',
        placasTractor: 'MNO-345',
        placasRemolque: 'PQR-678',
        lineaTransportista: 'Transp. C',
        operador: 'Miguel Torres',
        telefonoOperador: '555-0789',
        llegada: now.subtract(const Duration(hours: 2)),
        estado: EstadoVehiculo.enManiobra,
        supervisorAsignado: 'Sofía Martínez',
        horaAsignacion: now.subtract(const Duration(hours: 1, minutes: 45)),
        expedienteId: '3',
      ),
      Vehiculo(
        id: 'v4',
        placasTractor: 'STU-901',
        placasRemolque: 'VWX-234',
        lineaTransportista: 'Transp. A',
        operador: 'Roberto Silva',
        telefonoOperador: '555-0321',
        llegada: now.subtract(const Duration(hours: 3)),
        estado: EstadoVehiculo.finalizado,
        supervisorAsignado: 'Laura García',
        horaAsignacion: now.subtract(const Duration(hours: 2, minutes: 30)),
        expedienteId: '4',
      ),
      Vehiculo(
        id: 'v5',
        placasTractor: 'YZA-567',
        placasRemolque: 'BCD-890',
        lineaTransportista: 'Transp. D',
        operador: 'Elena Vargas',
        telefonoOperador: '555-0987',
        llegada: now.subtract(const Duration(minutes: 20)),
        estado: EstadoVehiculo.enEspera,
        expedienteId: '5',
      ),
      Vehiculo(
        id: 'v6',
        placasTractor: 'EFG-123',
        placasRemolque: 'HIJ-456',
        lineaTransportista: 'Transp. B',
        operador: 'Diego Morales',
        telefonoOperador: '555-0543',
        llegada: now.subtract(const Duration(hours: 1, minutes: 15)),
        estado: EstadoVehiculo.enManiobra,
        supervisorAsignado: 'Miguel Torres',
        horaAsignacion: now.subtract(const Duration(minutes: 45)),
        expedienteId: '6',
      ),
    ];
  }

  List<Alerta> _getCurrentAlertas() {
    final now = DateTime.now();
    return [
      Alerta(
        id: 'alert_1',
        tipo: TipoAlerta.esperaExcesiva,
        titulo: 'Espera Excesiva',
        descripcion: 'ABC-123 lleva 75 minutos en espera',
        creadaEn: now.subtract(const Duration(minutes: 5)),
        vehiculoId: 'v1',
        minutosEspera: 75,
      ),
      Alerta(
        id: 'alert_2',
        tipo: TipoAlerta.retraso,
        titulo: 'Retraso en Maniobra',
        descripcion: 'MNO-345 lleva 105 minutos en maniobra',
        creadaEn: now.subtract(const Duration(minutes: 2)),
        vehiculoId: 'v3',
        supervisorId: 'Sofía Martínez',
      ),
    ];
  }

  List<Supervisor> get supervisores => [
    const Supervisor(
      id: 'sup1',
      nombre: 'Laura García',
      email: 'laura.garcia@mercosur.com',
      especialidades: ['carga', 'descarga'],
    ),
    const Supervisor(
      id: 'sup2',
      nombre: 'Pablo López',
      email: 'pablo.lopez@mercosur.com',
      especialidades: ['descarga', 'transbordo'],
    ),
    const Supervisor(
      id: 'sup3',
      nombre: 'Sofía Martínez',
      email: 'sofia.martinez@mercosur.com',
      especialidades: ['carga', 'descarga', 'transbordo'],
    ),
    const Supervisor(
      id: 'sup4',
      nombre: 'Miguel Torres',
      email: 'miguel.torres@mercosur.com',
      especialidades: ['carga'],
    ),
    const Supervisor(
      id: 'sup5',
      nombre: 'Ana Rodríguez',
      email: 'ana.rodriguez@mercosur.com',
      especialidades: ['descarga', 'transbordo'],
    ),
    const Supervisor(
      id: 'sup6',
      nombre: 'Carlos Mendoza',
      email: 'carlos.mendoza@mercosur.com',
      especialidades: ['carga', 'descarga'],
    ),
    const Supervisor(
      id: 'sup7',
      nombre: 'Elena Vargas',
      email: 'elena.vargas@mercosur.com',
      especialidades: ['transbordo'],
    ),
    const Supervisor(
      id: 'sup8',
      nombre: 'Diego Morales',
      email: 'diego.morales@mercosur.com',
      especialidades: ['carga', 'descarga', 'transbordo'],
    ),
  ];

  void dispose() {
    _updateTimer?.cancel();
    _vehiculosController.close();
    _alertasController.close();
    _estadisticasController.close();
  }
}

// Providers
final coordinadorSimulatorProvider = Provider<CoordinadorDataSimulator>((ref) {
  final simulator = CoordinadorDataSimulator();
  ref.onDispose(() => simulator.dispose());
  return simulator;
});

final vehiculosStreamProvider = StreamProvider<List<Vehiculo>>((ref) {
  final simulator = ref.watch(coordinadorSimulatorProvider);
  simulator.startSimulation();
  return simulator.vehiculosStream;
});

final alertasStreamProvider = StreamProvider<List<Alerta>>((ref) {
  final simulator = ref.watch(coordinadorSimulatorProvider);
  return simulator.alertasStream;
});

final estadisticasStreamProvider = StreamProvider<EstadisticaTiempoReal>((ref) {
  final simulator = ref.watch(coordinadorSimulatorProvider);
  return simulator.estadisticasStream;
});

final supervisoresProvider = Provider<List<Supervisor>>((ref) {
  final simulator = ref.watch(coordinadorSimulatorProvider);
  return simulator.supervisores;
});

// Providers para filtros y búsquedas
final vehiculosEnEsperaProvider = Provider<List<Vehiculo>>((ref) {
  final vehiculos = ref.watch(vehiculosStreamProvider).value ?? [];
  return vehiculos.where((v) => v.estado == EstadoVehiculo.enEspera).toList();
});

final vehiculosEnPatioProvider = Provider<List<Vehiculo>>((ref) {
  final vehiculos = ref.watch(vehiculosStreamProvider).value ?? [];
  return vehiculos.where((v) => v.estado == EstadoVehiculo.enPatio).toList();
});

final vehiculosEnManiobraProvider = Provider<List<Vehiculo>>((ref) {
  final vehiculos = ref.watch(vehiculosStreamProvider).value ?? [];
  return vehiculos.where((v) => v.estado == EstadoVehiculo.enManiobra).toList();
});

final vehiculosFinalizadosProvider = Provider<List<Vehiculo>>((ref) {
  final vehiculos = ref.watch(vehiculosStreamProvider).value ?? [];
  return vehiculos.where((v) => v.estado == EstadoVehiculo.finalizado).toList();
});

final alertasActivasProvider = Provider<List<Alerta>>((ref) {
  final alertas = ref.watch(alertasStreamProvider).value ?? [];
  return alertas.where((a) => !a.resuelta).toList();
});

// Provider para asignación de supervisores
class CoordinadorNotifier extends StateNotifier<List<Vehiculo>> {
  CoordinadorNotifier(List<Vehiculo> initial) : super(initial);

  void asignarSupervisor(String vehiculoId, String supervisorId) {
    state = state.map((vehiculo) {
      if (vehiculo.id == vehiculoId) {
        return vehiculo.copyWith(
          supervisorAsignado: supervisorId,
          horaAsignacion: DateTime.now(),
          estado: EstadoVehiculo.enPatio,
        );
      }
      return vehiculo;
    }).toList();
  }

  void moverVehiculo(String vehiculoId, EstadoVehiculo nuevoEstado) {
    state = state.map((vehiculo) {
      if (vehiculo.id == vehiculoId) {
        return vehiculo.copyWith(estado: nuevoEstado);
      }
      return vehiculo;
    }).toList();
  }

  void resolverAlerta(String alertaId) {
    // Esta funcionalidad se implementaría cuando se conecte a Supabase
    // Por ahora solo simulamos la resolución
  }
}

final coordinadorStateProvider = StateNotifierProvider<CoordinadorNotifier, List<Vehiculo>>((ref) {
  final vehiculos = ref.watch(vehiculosStreamProvider).value ?? [];
  return CoordinadorNotifier(vehiculos);
});
