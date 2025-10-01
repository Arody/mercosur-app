import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/expediente.dart';

final expedientesRepositoryProvider = Provider<List<Expediente>>((ref) {
  // Fake data
  final now = DateTime.now();
  return [
    Expediente(
      id: '1',
      folio: 'EXP-1001',
      cliente: 'ACME S.A.',
      tipo: TipoManiobra.carga,
      bodega: 'Bodega Norte',
      creadoEn: now.subtract(const Duration(hours: 2)),
      status: ExpedienteStatus.activo,
      maniobras: const [
        Maniobra(id: 'm1', tipo: TipoManiobra.carga, supervisor: 'Laura', avance: 60),
        Maniobra(id: 'm2', tipo: TipoManiobra.descarga, supervisor: 'Pablo', avance: 0),
      ],
    ),
    Expediente(
      id: '2',
      folio: 'EXP-1002',
      cliente: 'Globex Corp.',
      tipo: TipoManiobra.descarga,
      bodega: 'Bodega Sur',
      creadoEn: now.subtract(const Duration(days: 1)),
      status: ExpedienteStatus.completado,
      maniobras: const [
        Maniobra(id: 'm3', tipo: TipoManiobra.descarga, supervisor: 'Ana', avance: 100),
      ],
    ),
    Expediente(
      id: '3',
      folio: 'EXP-1003',
      cliente: 'Initech',
      tipo: TipoManiobra.transbordo,
      bodega: 'Patio 1',
      creadoEn: now.subtract(const Duration(minutes: 45)),
      status: ExpedienteStatus.pendiente,
      maniobras: const [
        Maniobra(id: 'm4', tipo: TipoManiobra.carga, supervisor: 'Miguel', avance: 20),
        Maniobra(id: 'm5', tipo: TipoManiobra.transbordo, supervisor: 'Sofía', avance: 10),
      ],
    ),
    Expediente(
      id: '4',
      folio: 'EXP-1004',
      cliente: 'Umbrella Co.',
      tipo: TipoManiobra.carga,
      bodega: 'Bodega Norte',
      creadoEn: now.subtract(const Duration(hours: 6)),
      status: ExpedienteStatus.cancelado,
    ),
  ];
});

final expedientesSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredExpedientesProvider = Provider<List<Expediente>>((ref) {
  final list = ref.watch(expedientesRepositoryProvider);
  final query = ref.watch(expedientesSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return list;
  return list.where((e) {
    return e.folio.toLowerCase().contains(query) ||
        e.cliente.toLowerCase().contains(query) ||
        e.bodega.toLowerCase().contains(query) ||
        e.tipo.label.toLowerCase().contains(query) ||
        e.status.label.toLowerCase().contains(query);
  }).toList();
});
