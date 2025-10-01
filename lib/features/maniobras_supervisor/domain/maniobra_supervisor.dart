import 'package:flutter/material.dart';

enum EstadoManiobra { pendiente, enProceso, finalizada }

enum TipoUnidad { rabon, caja, plataforma, jaula }

enum TipoChecklist { antes, durante, finalizado }

class ChecklistItem {
  final String id;
  final String descripcion;
  final bool completado;
  final String? observaciones;
  final List<String> fotos; // URLs de las fotos

  const ChecklistItem({
    required this.id,
    required this.descripcion,
    this.completado = false,
    this.observaciones,
    this.fotos = const [],
  });

  ChecklistItem copyWith({
    String? id,
    String? descripcion,
    bool? completado,
    String? observaciones,
    List<String>? fotos,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      completado: completado ?? this.completado,
      observaciones: observaciones ?? this.observaciones,
      fotos: fotos ?? this.fotos,
    );
  }
}

class DatosVehiculo {
  final String placasTractor;
  final String placasRemolque;
  final String lineaTransportista;
  final String nombreOperador;
  final String? telefonoOperador;
  final TipoUnidad tipoUnidad;

  const DatosVehiculo({
    required this.placasTractor,
    required this.placasRemolque,
    required this.lineaTransportista,
    required this.nombreOperador,
    this.telefonoOperador,
    required this.tipoUnidad,
  });
}

class DatosMercancia {
  final String cliente;
  final String tipoCarga;
  final int numeroBultos;
  final double peso;
  final String remisionFactura;
  final String? descripcionMercancia;

  const DatosMercancia({
    required this.cliente,
    required this.tipoCarga,
    required this.numeroBultos,
    required this.peso,
    required this.remisionFactura,
    this.descripcionMercancia,
  });
}

class ManiobraSupervisor {
  final String id;
  final String expedienteId;
  final DatosMercancia datosMercancia;
  final DatosVehiculo datosVehiculo;
  final DateTime horaInicioProgramada;
  final DateTime? horaInicioReal;
  final DateTime? horaFinalizacion;
  final EstadoManiobra estado;
  final Map<TipoChecklist, List<ChecklistItem>> checklists;
  final List<String> fotosGenerales;
  final String? observacionesGenerales;
  final String supervisorAsignado;

  const ManiobraSupervisor({
    required this.id,
    required this.expedienteId,
    required this.datosMercancia,
    required this.datosVehiculo,
    required this.horaInicioProgramada,
    this.horaInicioReal,
    this.horaFinalizacion,
    required this.estado,
    this.checklists = const {},
    this.fotosGenerales = const [],
    this.observacionesGenerales,
    required this.supervisorAsignado,
  });

  ManiobraSupervisor copyWith({
    String? id,
    String? expedienteId,
    DatosMercancia? datosMercancia,
    DatosVehiculo? datosVehiculo,
    DateTime? horaInicioProgramada,
    DateTime? horaInicioReal,
    DateTime? horaFinalizacion,
    EstadoManiobra? estado,
    Map<TipoChecklist, List<ChecklistItem>>? checklists,
    List<String>? fotosGenerales,
    String? observacionesGenerales,
    String? supervisorAsignado,
  }) {
    return ManiobraSupervisor(
      id: id ?? this.id,
      expedienteId: expedienteId ?? this.expedienteId,
      datosMercancia: datosMercancia ?? this.datosMercancia,
      datosVehiculo: datosVehiculo ?? this.datosVehiculo,
      horaInicioProgramada: horaInicioProgramada ?? this.horaInicioProgramada,
      horaInicioReal: horaInicioReal ?? this.horaInicioReal,
      horaFinalizacion: horaFinalizacion ?? this.horaFinalizacion,
      estado: estado ?? this.estado,
      checklists: checklists ?? this.checklists,
      fotosGenerales: fotosGenerales ?? this.fotosGenerales,
      observacionesGenerales: observacionesGenerales ?? this.observacionesGenerales,
      supervisorAsignado: supervisorAsignado ?? this.supervisorAsignado,
    );
  }
}

extension EstadoManiobraX on EstadoManiobra {
  Color get color {
    switch (this) {
      case EstadoManiobra.pendiente:
        return Colors.amber;
      case EstadoManiobra.enProceso:
        return Colors.blue;
      case EstadoManiobra.finalizada:
        return Colors.green;
    }
  }

  String get label {
    switch (this) {
      case EstadoManiobra.pendiente:
        return 'Pendiente';
      case EstadoManiobra.enProceso:
        return 'En Proceso';
      case EstadoManiobra.finalizada:
        return 'Finalizada';
    }
  }

  IconData get icon {
    switch (this) {
      case EstadoManiobra.pendiente:
        return Icons.schedule;
      case EstadoManiobra.enProceso:
        return Icons.play_circle;
      case EstadoManiobra.finalizada:
        return Icons.check_circle;
    }
  }
}

extension TipoUnidadX on TipoUnidad {
  String get label {
    switch (this) {
      case TipoUnidad.rabon:
        return 'Rabón';
      case TipoUnidad.caja:
        return 'Caja';
      case TipoUnidad.plataforma:
        return 'Plataforma';
      case TipoUnidad.jaula:
        return 'Jaula';
    }
  }
}

extension TipoChecklistX on TipoChecklist {
  String get label {
    switch (this) {
      case TipoChecklist.antes:
        return 'Antes de Maniobra';
      case TipoChecklist.durante:
        return 'Durante Maniobra';
      case TipoChecklist.finalizado:
        return 'Final de Maniobra';
    }
  }
}
