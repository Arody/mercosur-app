import 'package:flutter/material.dart';
import '../../domain/maniobra_supervisor.dart';

class ChecklistWidget extends StatelessWidget {
  const ChecklistWidget({
    super.key,
    required this.tipoChecklist,
    required this.items,
    required this.onItemToggle,
    required this.onPhotoAdd,
    this.readOnly = false,
  });

  final TipoChecklist tipoChecklist;
  final List<ChecklistItem> items;
  final Function(String itemId, bool completado) onItemToggle;
  final Function(String itemId) onPhotoAdd;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedItems = items.where((item) => item.completado).length;
    final progress = items.isEmpty ? 0.0 : completedItems / items.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del checklist
            Row(
              children: [
                Icon(
                  _getChecklistIcon(tipoChecklist),
                  color: progress == 1.0 ? Colors.green : theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tipoChecklist.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!readOnly) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: progress == 1.0 
                          ? Colors.green.withOpacity(0.2)
                          : theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$completedItems/${items.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: progress == 1.0 ? Colors.green : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            
            // Barra de progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 1.0 ? Colors.green : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Items del checklist
            ...items.map((item) => _buildChecklistItem(context, item)),
            
            // Botón para agregar fotos si es necesario
            if (!readOnly && tipoChecklist == TipoChecklist.antes) ...[
              const SizedBox(height: 16),
              _buildPhotoSection(context, items),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(BuildContext context, ChecklistItem item) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          if (!readOnly)
            Checkbox(
              value: item.completado,
              onChanged: (value) {
                onItemToggle(item.id, value ?? false);
              },
              activeColor: theme.colorScheme.primary,
            )
          else
            Icon(
              item.completado ? Icons.check_circle : Icons.radio_button_unchecked,
              color: item.completado ? Colors.green : Colors.grey,
              size: 20,
            ),
          const SizedBox(width: 12),
          
          // Descripción del item
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.descripcion,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: item.completado ? TextDecoration.lineThrough : null,
                    color: item.completado ? Colors.grey[600] : null,
                  ),
                ),
                
                // Observaciones si las hay
                if (item.observaciones != null && item.observaciones!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.observaciones!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
                
                // Fotos si las hay
                if (item.fotos.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.fotos.map((foto) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            'assets/placeholder_image.png', // Placeholder
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          
          // Botón para agregar foto
          if (!readOnly && _needsPhoto(item.descripcion)) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                item.fotos.isEmpty ? Icons.add_a_photo_outlined : Icons.photo_library,
                size: 20,
              ),
              onPressed: () => onPhotoAdd(item.id),
              tooltip: 'Agregar foto',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context, List<ChecklistItem> items) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evidencia Fotográfica Inicial',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fotos requeridas: Vehículo (frente, laterales, placas) y mercancía empacada',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implementar captura de fotos
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad de captura de fotos en desarrollo'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt, size: 16),
                  label: const Text('Tomar Fotos'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // TODO: Implementar impresión QR
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Imprimir etiqueta QR - Zebra ZQ520'),
                    ),
                  );
                },
                icon: const Icon(Icons.print),
                tooltip: 'Imprimir etiqueta QR',
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getChecklistIcon(TipoChecklist tipo) {
    switch (tipo) {
      case TipoChecklist.antes:
        return Icons.checklist;
      case TipoChecklist.durante:
        return Icons.play_circle_outline;
      case TipoChecklist.finalizado:
        return Icons.check_circle_outline;
    }
  }

  bool _needsPhoto(String descripcion) {
    // Determina si un item necesita foto basado en su descripción
    final photoKeywords = ['foto', 'evidencia', 'estado del piso', 'mercancía'];
    return photoKeywords.any((keyword) => 
        descripcion.toLowerCase().contains(keyword));
  }
}
