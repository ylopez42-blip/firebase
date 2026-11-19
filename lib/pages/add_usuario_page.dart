import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

class AddUsuario extends StatefulWidget {
  const AddUsuario({super.key});

  @override
  State<AddUsuario> createState() => _AddUsuarioState();
}

class _AddUsuarioState extends State<AddUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _cuentaController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _cuentaController.dispose();
    super.dispose();
  }

  Future<void> _saveUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    await agregarUsuario(
      _nombreController.text.trim(),
      _emailController.text.trim(),
      _cuentaController.text.trim(),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo registro')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            _FormIntro(
              icon: Icons.person_add_alt_1_rounded,
              eyebrow: 'UN NUEVO VÍNCULO',
              title: 'Conecta a alguien nuevo.',
              description: 'Guarda sus datos para tenerlos siempre cerca.',
            ),
            const SizedBox(height: 25),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _FormCard(
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _saveUsuario,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Guardar contacto'),
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

class _FormIntro extends StatelessWidget {
  const _FormIntro({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String description;

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
          child: Icon(icon, color: nexoLime, size: 25),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  color: nexoForest,
                  fontSize: 9,
                  letterSpacing: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontSize: 21, height: 1.15),
              ),
              const SizedBox(height: 5),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: nexoLine),
      ),
      child: Column(children: children),
    );
  }
}
