import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/expediente.dart';
import 'expedientes_providers.dart';

class ExpedientesNotifier extends StateNotifier<List<Expediente>> {
  ExpedientesNotifier(List<Expediente> initial) : super(initial);

  void addManiobra({required String expedienteId, required Maniobra maniobra}) {
    state = state
        .map((e) => e.id == expedienteId
            ? Expediente(
                id: e.id,
                folio: e.folio,
                cliente: e.cliente,
                tipo: e.tipo,
                bodega: e.bodega,
                creadoEn: e.creadoEn,
                status: e.status,
                maniobras: [...e.maniobras, maniobra],
              )
            : e)
        .toList();
  }

  void updateAvance({required String expedienteId, required String maniobraId, required int avance}) {
    state = state
        .map((e) => e.id == expedienteId
            ? Expediente(
                id: e.id,
                folio: e.folio,
                cliente: e.cliente,
                tipo: e.tipo,
                bodega: e.bodega,
                creadoEn: e.creadoEn,
                status: e.status,
                maniobras: e.maniobras
                    .map((m) => m.id == maniobraId
                        ? Maniobra(id: m.id, tipo: m.tipo, supervisor: m.supervisor, avance: avance)
                        : m)
                    .toList(),
              )
            : e)
        .toList();
  }
}

final expedientesStateProvider =
    StateNotifierProvider<ExpedientesNotifier, List<Expediente>>((ref) {
  final initial = ref.watch(expedientesRepositoryProvider);
  return ExpedientesNotifier(initial);
});
