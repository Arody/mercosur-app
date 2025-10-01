import 'package:flutter/material.dart';

enum EstadoVehiculo { enEspera, enPatio, enManiobra, finalizado }

enum TipoAlerta { esperaExcesiva, anomalia, retraso, completado }

enum EtapaKanban { espera, asignado, enProceso, finalizado }

class Supervisor {
  final String id;
  final String nombre;
  final String email;
  final bool activo;
  final List<String> especialidades; // Tipos de maniobras que maneja

  const Supervisor({
    required this.id,
    required this.nombre,
    required this.email,
    this.activo = true,
    this.especialidades = const [],
  });
}

class Vehiculo {
  final String id;
  final String placasTractor;
  final String placasRemolque;
  final String lineaTransportista;
  final String operador;
  final String? telefonoOperador;
  final DateTime llegada;
  final EstadoVehiculo estado;
  final String? supervisorAsignado;
  final DateTime? horaAsignacion;
  final String expedienteId;

  const Vehiculo({
    required this.id,
    required this.placasTractor,
    required this.placasRemolque,
    required this.lineaTransportista,
    required this.operador,
    this.telefonoOperador,
    required this.llegada,
    required this.estado,
    this.supervisorAsignado,
    this.horaAsignacion,
    required this.expedienteId,
  });

  Vehiculo copyWith({
    String? id,
    String? placasTractor,
    String? placasRemolque,
    String? lineaTransportista,
    String? operador,
    String? telefonoOperador,
    DateTime? llegada,
    EstadoVehiculo? estado,
    String? supervisorAsignado,
    DateTime? horaAsignacion,
    String? expedienteId,
  }) {
    return Vehiculo(
      id: id ?? this.id,
      placasTractor: placasTractor ?? this.placasTractor,
      placasRemolque: placasRemolque ?? this.placasRemolque,
      lineaTransportista: lineaTransportista ?? this.lineaTransportista,
      operador: operador ?? this.operador,
      telefonoOperador: telefonoOperador ?? this.telefonoOperador,
      llegada: llegada ?? this.llegada,
      estado: estado ?? this.estado,
      supervisorAsignado: supervisorAsignado ?? this.supervisorAsignado,
      horaAsignacion: horaAsignacion ?? this.horaAsignacion,
      expedienteId: expedienteId ?? this.expedienteId,
    );
  }
}

class Alerta {
  final String id;
  final TipoAlerta tipo;
  final String titulo;
  final String descripcion;
  final DateTime creadaEn;
  final bool resuelta;
  final String vehiculoId;
  final String? supervisorId;
  final int? minutosEspera;

  const Alerta({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.descripcion,
    required this.creadaEn,
    this.resuelta = false,
    required this.vehiculoId,
    this.supervisorId,
    this.minutosEspera,
  });

  Alerta copyWith({
    String? id,
    TipoAlerta? tipo,
    String? titulo,
    String? descripcion,
    DateTime? creadaEn,
    bool? resuelta,
    String? vehiculoId,
    String? supervisorId,
    int? minutosEspera,
  }) {
    return Alerta(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      creadaEn: creadaEn ?? this.creadaEn,
      resuelta: resuelta ?? this.resuelta,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      supervisorId: supervisorId ?? this.supervisorId,
      minutosEspera: minutosEspera ?? this.minutosEspera,
    );
  }
}

class EstadisticaTiempoReal {
  final int vehiculosEnEspera;
  final int vehiculosEnPatio;
  final int vehiculosEnManiobra;
  final int vehiculosFinalizados;
  final int supervisoresActivos;
  final int alertasActivas;
  final double tiempoPromedioEspera; // en minutos
  final double tiempoPromedioManiobra; // en minutos

  const EstadisticaTiempoReal({
    required this.vehiculosEnEspera,
    required this.vehiculosEnPatio,
    required this.vehiculosEnManiobra,
    required this.vehiculosFinalizados,
    required this.supervisoresActivos,
    required this.alertasActivas,
    required this.tiempoPromedioEspera,
    required this.tiempoPromedioManiobra,
  });
}

// Extensions para UI
extension EstadoVehiculoX on EstadoVehiculo {
  Color get color {
    switch (this) {
      case EstadoVehiculo.enEspera:
        return Colors.orange;
      case EstadoVehiculo.enPatio:
        return Colors.blue;
      case EstadoVehiculo.enManiobra:
        return Colors.green;
      case EstadoVehiculo.finalizado:
        return Colors.grey;
    }
  }

  String get label {
    switch (this) {
      case EstadoVehiculo.enEspera:
        return 'En Espera';
      case EstadoVehiculo.enPatio:
        return 'En Patio';
      case EstadoVehiculo.enManiobra:
        return 'En Maniobra';
      case EstadoVehiculo.finalizado:
        return 'Finalizado';
    }
  }

  IconData get icon {
    switch (this) {
      case EstadoVehiculo.enEspera:
        return Icons.schedule;
      case EstadoVehiculo.enPatio:
        return Icons.local_parking;
      case EstadoVehiculo.enManiobra:
        return Icons.play_circle;
      case EstadoVehiculo.finalizado:
        return Icons.check_circle;
    }
  }

  EtapaKanban get etapaKanban {
    switch (this) {
      case EstadoVehiculo.enEspera:
        return EtapaKanban.espera;
      case EstadoVehiculo.enPatio:
        return EtapaKanban.asignado;
      case EstadoVehiculo.enManiobra:
        return EtapaKanban.enProceso;
      case EstadoVehiculo.finalizado:
        return EtapaKanban.finalizado;
    }
  }
}

extension TipoAlertaX on TipoAlerta {
  Color get color {
    switch (this) {
      case TipoAlerta.esperaExcesiva:
        return Colors.red;
      case TipoAlerta.anomalia:
        return Colors.orange;
      case TipoAlerta.retraso:
        return Colors.yellow;
      case TipoAlerta.completado:
        return Colors.green;
    }
  }

  String get label {
    switch (this) {
      case TipoAlerta.esperaExcesiva:
        return 'Espera Excesiva';
      case TipoAlerta.anomalia:
        return 'Anomalía';
      case TipoAlerta.retraso:
        return 'Retraso';
      case TipoAlerta.completado:
        return 'Completado';
    }
  }

  IconData get icon {
    switch (this) {
      case TipoAlerta.esperaExcesiva:
        return Icons.access_time;
      case TipoAlerta.anomalia:
        return Icons.warning;
      case TipoAlerta.retraso:
        return Icons.schedule;
      case TipoAlerta.completado:
        return Icons.check_circle;
    }
  }
}

extension EtapaKanbanX on EtapaKanban {
  String get label {
    switch (this) {
      case EtapaKanban.espera:
        return 'En Espera';
      case EtapaKanban.asignado:
        return 'Asignado';
      case EtapaKanban.enProceso:
        return 'En Proceso';
      case EtapaKanban.finalizado:
        return 'Finalizado';
    }
  }

  Color get color {
    switch (this) {
      case EtapaKanban.espera:
        return Colors.orange;
      case EtapaKanban.asignado:
        return Colors.blue;
      case EtapaKanban.enProceso:
        return Colors.green;
      case EtapaKanban.finalizado:
        return Colors.grey;
    }
  }
}
