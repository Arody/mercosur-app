import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/maniobra_supervisor.dart';
import '../providers/maniobras_supervisor_providers.dart';
import '../widgets/checklist_widget.dart';

class ManiobraDetailPage extends ConsumerStatefulWidget {
  const ManiobraDetailPage({super.key, required this.maniobra});

  final ManiobraSupervisor maniobra;

  @override
  ConsumerState<ManiobraDetailPage> createState() => _ManiobraDetailPageState();
}

class _ManiobraDetailPageState extends ConsumerState<ManiobraDetailPage> {
  late ManiobraSupervisor _currentManiobra;

  @override
  void initState() {
    super.initState();
    _currentManiobra = widget.maniobra;
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la maniobra actualizada desde el provider
    final maniobras = ref.watch(maniobrasSupervisorStateProvider);
    final maniobraActualizada = maniobras.firstWhere(
      (m) => m.id == widget.maniobra.id,
      orElse: () => _currentManiobra,
    );
    _currentManiobra = maniobraActualizada;

    return Scaffold(
      appBar: AppBar(
        title: Text('Maniobra ${maniobraActualizada.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _imprimirEtiquetaQR,
            tooltip: 'Imprimir etiqueta QR',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información general
            _buildInfoGeneral(context, maniobraActualizada),
            const SizedBox(height: 16),
            
            // Datos del vehículo y operador
            _buildDatosVehiculo(context, maniobraActualizada),
            const SizedBox(height: 16),
            
            // Controles de estado
            _buildControlesEstado(context, maniobraActualizada),
            const SizedBox(height: 16),
            
            // Checklists
            _buildChecklists(context, maniobraActualizada),
            const SizedBox(height: 16),
            
            // Observaciones generales
            _buildObservaciones(context, maniobraActualizada),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGeneral(BuildContext context, ManiobraSupervisor maniobra) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  maniobra.estado.icon,
                  color: maniobra.estado.color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Información General',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: maniobra.estado.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    maniobra.estado.label,
                    style: TextStyle(
                      color: maniobra.estado.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildInfoRow('Cliente', maniobra.datosMercancia.cliente),
            _buildInfoRow('Tipo de Carga', maniobra.datosMercancia.tipoCarga),
            _buildInfoRow('Número de Bultos', maniobra.datosMercancia.numeroBultos.toString()),
            _buildInfoRow('Peso', '${maniobra.datosMercancia.peso} kg'),
            _buildInfoRow('Remisión/Factura', maniobra.datosMercancia.remisionFactura),
            if (maniobra.datosMercancia.descripcionMercancia != null)
              _buildInfoRow('Descripción', maniobra.datosMercancia.descripcionMercancia!),
            _buildInfoRow('Supervisor', maniobra.supervisorAsignado),
            _buildInfoRow('Hora Programada', _formatDateTime(maniobra.horaInicioProgramada)),
            if (maniobra.horaInicioReal != null)
              _buildInfoRow('Hora Inicio Real', _formatDateTime(maniobra.horaInicioReal!)),
            if (maniobra.horaFinalizacion != null)
              _buildInfoRow('Hora Finalización', _formatDateTime(maniobra.horaFinalizacion!)),
          ],
        ),
      ),
    );
  }

  Widget _buildDatosVehiculo(BuildContext context, ManiobraSupervisor maniobra) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_shipping, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Datos del Vehículo y Operador',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildInfoRow('Tipo de Unidad', maniobra.datosVehiculo.tipoUnidad.label),
            _buildInfoRow('Placas Tractor', maniobra.datosVehiculo.placasTractor),
            _buildInfoRow('Placas Remolque', maniobra.datosVehiculo.placasRemolque),
            _buildInfoRow('Línea Transportista', maniobra.datosVehiculo.lineaTransportista),
            _buildInfoRow('Nombre Operador', maniobra.datosVehiculo.nombreOperador),
            if (maniobra.datosVehiculo.telefonoOperador != null)
              _buildInfoRow('Teléfono Operador', maniobra.datosVehiculo.telefonoOperador!),
          ],
        ),
      ),
    );
  }

  Widget _buildControlesEstado(BuildContext context, ManiobraSupervisor maniobra) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Controles de Estado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                if (maniobra.estado == EstadoManiobra.pendiente) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _iniciarManiobra(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Iniciar Maniobra'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
                if (maniobra.estado == EstadoManiobra.enProceso) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _finalizarManiobra(),
                      icon: const Icon(Icons.stop),
                      label: const Text('Finalizar Maniobra'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _imprimirEtiquetaQR,
                    icon: const Icon(Icons.print),
                    label: const Text('Imprimir QR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklists(BuildContext context, ManiobraSupervisor maniobra) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Checklists',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Checklist Antes de Maniobra
        if (maniobra.checklists.containsKey(TipoChecklist.antes))
          ChecklistWidget(
            tipoChecklist: TipoChecklist.antes,
            items: maniobra.checklists[TipoChecklist.antes]!,
            onItemToggle: (itemId, completado) => _toggleChecklistItem(
              TipoChecklist.antes,
              itemId,
              completado,
            ),
            onPhotoAdd: (itemId) => _addPhoto(TipoChecklist.antes, itemId),
            readOnly: maniobra.estado == EstadoManiobra.finalizada,
          ),
        
        const SizedBox(height: 16),
        
        // Checklist Durante Maniobra
        if (maniobra.checklists.containsKey(TipoChecklist.durante))
          ChecklistWidget(
            tipoChecklist: TipoChecklist.durante,
            items: maniobra.checklists[TipoChecklist.durante]!,
            onItemToggle: (itemId, completado) => _toggleChecklistItem(
              TipoChecklist.durante,
              itemId,
              completado,
            ),
            onPhotoAdd: (itemId) => _addPhoto(TipoChecklist.durante, itemId),
            readOnly: maniobra.estado == EstadoManiobra.finalizada,
          ),
        
        const SizedBox(height: 16),
        
        // Checklist Final
        if (maniobra.checklists.containsKey(TipoChecklist.finalizado))
          ChecklistWidget(
            tipoChecklist: TipoChecklist.finalizado,
            items: maniobra.checklists[TipoChecklist.finalizado]!,
            onItemToggle: (itemId, completado) => _toggleChecklistItem(
              TipoChecklist.finalizado,
              itemId,
              completado,
            ),
            onPhotoAdd: (itemId) => _addPhoto(TipoChecklist.finalizado, itemId),
            readOnly: maniobra.estado == EstadoManiobra.finalizada,
          ),
      ],
    );
  }

  Widget _buildObservaciones(BuildContext context, ManiobraSupervisor maniobra) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Observaciones Generales',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              decoration: const InputDecoration(
                hintText: 'Agregar observaciones generales sobre la maniobra...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                // TODO: Implementar guardado de observaciones
              },
              controller: TextEditingController(text: maniobra.observacionesGenerales),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _iniciarManiobra() {
    ref.read(maniobrasSupervisorStateProvider.notifier).iniciarManiobra(_currentManiobra.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Maniobra iniciada'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _finalizarManiobra() {
    ref.read(maniobrasSupervisorStateProvider.notifier).finalizarManiobra(_currentManiobra.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Maniobra finalizada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _toggleChecklistItem(TipoChecklist tipo, String itemId, bool completado) {
    final items = _currentManiobra.checklists[tipo] ?? [];
    final itemIndex = items.indexWhere((item) => item.id == itemId);
    
    if (itemIndex != -1) {
      final itemActualizado = items[itemIndex].copyWith(completado: completado);
      ref.read(maniobrasSupervisorStateProvider.notifier).updateChecklistItem(
        maniobraId: _currentManiobra.id,
        tipoChecklist: tipo,
        itemId: itemId,
        itemActualizado: itemActualizado,
      );
    }
  }

  void _addPhoto(TipoChecklist tipo, String itemId) {
    // TODO: Implementar captura de fotos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de captura de fotos en desarrollo'),
      ),
    );
  }

  void _imprimirEtiquetaQR() {
    // TODO: Implementar impresión QR con Zebra ZQ520
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Imprimiendo etiqueta QR - Zebra ZQ520 vía Bluetooth'),
      ),
    );
  }
}
