import 'package:flutter/material.dart';

enum ExpedienteStatus { activo, completado, cancelado, pendiente }

enum TipoManiobra { carga, descarga, transbordo }

class Maniobra {
  final String id;
  final TipoManiobra tipo;
  final String supervisor; // nombre del supervisor asignado
  final int avance; // 0..100

  const Maniobra({
    required this.id,
    required this.tipo,
    required this.supervisor,
    required this.avance,
  });
}

class Expediente {
  final String id;
  final String folio;
  final String cliente;
  final TipoManiobra tipo;
  final String bodega;
  final DateTime creadoEn;
  final ExpedienteStatus status;
  final List<Maniobra> maniobras;

  const Expediente({
    required this.id,
    required this.folio,
    required this.cliente,
    required this.tipo,
    required this.bodega,
    required this.creadoEn,
    required this.status,
    this.maniobras = const [],
  });
}

extension ExpedienteStatusX on ExpedienteStatus {
  Color get color {
    switch (this) {
      case ExpedienteStatus.activo:
        return Colors.green;
      case ExpedienteStatus.completado:
        return Colors.blue;
      case ExpedienteStatus.cancelado:
        return Colors.red;
      case ExpedienteStatus.pendiente:
        return Colors.amber;
    }
  }

  String get label {
    switch (this) {
      case ExpedienteStatus.activo:
        return 'Activo';
      case ExpedienteStatus.completado:
        return 'Completado';
      case ExpedienteStatus.cancelado:
        return 'Cancelado';
      case ExpedienteStatus.pendiente:
        return 'Pendiente';
    }
  }
}

extension TipoManiobraX on TipoManiobra {
  String get label {
    switch (this) {
      case TipoManiobra.carga:
        return 'Carga';
      case TipoManiobra.descarga:
        return 'Descarga';
      case TipoManiobra.transbordo:
        return 'Transbordo';
    }
  }
}
