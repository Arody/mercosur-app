import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewExpedienteWizard extends ConsumerStatefulWidget {
  const NewExpedienteWizard({super.key});

  @override
  ConsumerState<NewExpedienteWizard> createState() => _NewExpedienteWizardState();
}

class _NewExpedienteWizardState extends ConsumerState<NewExpedienteWizard> {
  int _currentStep = 0;

  final _clienteController = TextEditingController();
  final _placasTractorController = TextEditingController();
  final _placasRemolqueController = TextEditingController();
  final _operadorController = TextEditingController();
  final _telefonoController = TextEditingController();

  String _tipoManiobra = 'Carga';
  String? _patio;
  TimeOfDay? _horaIngreso;

  @override
  void dispose() {
    _clienteController.dispose();
    _placasTractorController.dispose();
    _placasRemolqueController.dispose();
    _operadorController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Nuevo Expediente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        steps: [
          Step(title: const Text('Generales'), content: _stepDatosGenerales()),
          Step(title: const Text('Transporte'), content: _stepTransporte()),
          Step(title: const Text('Turno'), content: _stepTurno()),
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep == 2) {
      _crearExpediente();
    } else {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _onStepCancel() {
    if (_currentStep == 0) return;
    setState(() {
      _currentStep -= 1;
    });
  }

  Widget _stepDatosGenerales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _clienteController,
          decoration: const InputDecoration(
            labelText: 'Cliente',
            helperText: 'Escriba para buscar… (fake)',
          ),
        ),
        const SizedBox(height: 12),
        const Text('Tipo de Maniobra'),
        Wrap(
          spacing: 8,
          children: ['Carga', 'Descarga', 'Transbordo']
              .map(
                (e) => ChoiceChip(
                  label: Text(e),
                  selected: _tipoManiobra == e,
                  onSelected: (_) {
                    setState(() {
                      _tipoManiobra = e;
                    });
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        const Text('Documentos Requeridos (placeholder):'),
        const ListTile(
          leading: Icon(Icons.picture_as_pdf),
          title: Text('Carta Porte / Remisión'),
          trailing: Icon(Icons.upload_file),
        ),
        const ListTile(
          leading: Icon(Icons.receipt_long),
          title: Text('Factura'),
          trailing: Icon(Icons.upload_file),
        ),
      ],
    );
  }

  Widget _stepTransporte() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _placasTractorController,
          decoration: const InputDecoration(labelText: 'Placas Tractor'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _placasRemolqueController,
          decoration: const InputDecoration(labelText: 'Placas Remolque'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _operadorController,
          decoration: const InputDecoration(labelText: 'Nombre Operador'),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: null,
          items: ['Transp. A', 'Transp. B', 'Transp. C']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          decoration: const InputDecoration(labelText: 'Empresa Transportista'),
          onChanged: (v) {},
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _telefonoController,
          decoration: const InputDecoration(labelText: 'Teléfono Operador (opcional)'),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _stepTurno() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _patio,
          items: ['Bodega Norte', 'Bodega Sur', 'Patio 1']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          decoration: const InputDecoration(labelText: 'Patio/Bodega'),
          onChanged: (v) => setState(() => _patio = v),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(_horaIngreso != null
              ? _horaIngreso!.format(context)
              : 'Hora estimada de ingreso'),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() => _horaIngreso = picked);
            }
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _patio != null && _horaIngreso != null ? _crearExpediente : null,
          icon: const Icon(Icons.save),
          label: const Text('Asignar & Generar Expediente'),
        ),
      ],
    );
  }

  void _crearExpediente() {
    // Aquí sólo simulamos con datos fake
    final folio = DateTime.now().millisecondsSinceEpoch;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Expediente creado'),
        content: Text('Folio: EXP-$folio'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                ..pop() // dialogo
                ..pop(); // wizard
            },
            child: const Text('Cerrar'),
          )
        ],
      ),
    );
  }
}

