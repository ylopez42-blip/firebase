import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

class EditUsuario extends StatefulWidget {
  const EditUsuario({super.key});

  @override
  State<EditUsuario> createState() => _EditUsuarioState();
}

class _EditUsuarioState extends State<EditUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _cuentaController = TextEditingController();
  bool _initialized = false;
  late String _uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _uid = arguments['uid'] as String;
    _nombreController.text = (arguments['nombre'] ?? '').toString();
    _emailController.text = (arguments['email'] ?? '').toString();
    _cuentaController.text = (arguments['numero de cuenta'] ?? '').toString();
    _initialized = true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _cuentaController.dispose();
    super.dispose();
  }

  Future<void> _saveUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    await editUsuario(
      _uid,
      _nombreController.text.trim(),
      _emailController.text.trim(),
      _cuentaController.text.trim(),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar registro')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            const _EditIntro(),
            const SizedBox(height: 25),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: nexoLine),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Nombre completo',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Escribe el nombre'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) return 'Escribe el correo';
                            if (!email.contains('@')) return 'Revisa el correo';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _cuentaController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Número de cuenta',
                            prefixIcon: Icon(Icons.credit_card_rounded),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Escribe el número de cuenta'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _saveUsuario,
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Guardar cambios'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditIntro extends StatelessWidget {
  const _EditIntro();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: nexoForest,
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(Icons.edit_note_rounded, color: nexoLime, size: 27),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ACTUALIZA LOS DATOS',
                style: TextStyle(
                  color: nexoForest,
                  fontSize: 9,
                  letterSpacing: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Un perfil al día.',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontSize: 21, height: 1.15),
              ),
              const SizedBox(height: 5),
              Text(
                'Edita la información y conserva tus cambios.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
