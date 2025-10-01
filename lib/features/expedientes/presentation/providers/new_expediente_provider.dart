import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewExpedienteFormState {
  String? cliente;
  String tipo = 'carga';
  // Documentos cargados: bool flags solo placeholder
  Map<String, bool> docs = {
    'Carta Porte/Remisión': false,
    'Factura': false,
    'Otros': false,
  };
  // Transporte
  String placasTractor = '';
  String placasRemolque = '';
  String operador = '';
  String? transportista;
  String telefono = '';
  // Turno
  String? patio;
  TimeOfDay? horaIngreso;
}

class NewExpedienteFormNotifier extends StateNotifier<NewExpedienteFormState> {
  NewExpedienteFormNotifier() : super(NewExpedienteFormState());

  void updateCliente(String value) => state = NewExpedienteFormState()
    ..cliente = value;

  void updateTipo(String value) => state = NewExpedienteFormState()
    ..tipo = value;

  // Más setters según se necesite…
}

final newExpedienteFormProvider =
    StateNotifierProvider<NewExpedienteFormNotifier, NewExpedienteFormState>(
        (ref) => NewExpedienteFormNotifier());

