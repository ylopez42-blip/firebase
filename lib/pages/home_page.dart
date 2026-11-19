import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = getUsuarios();
  }

  Future<void> _reloadUsuarios() async {
    final future = getUsuarios();
    setState(() => _usuariosFuture = future);
    await future;
  }

  Future<void> _openRoute(String route) async {
    await Navigator.pushNamed(context, route);
    if (mounted) await _reloadUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List>(
          future: _usuariosFuture,
          builder: (context, snapshot) {
            final usuarios = snapshot.data ?? [];
            final total =
                snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData
                ? '—'
                : '${usuarios.length}';

            return RefreshIndicator(
              color: nexoForest,
              onRefresh: _reloadUsuarios,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 36),
                children: [
                  _topBar(),
                  const SizedBox(height: 32),
                  Text(
                    'Tu gente,\nen un mismo lugar.',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Una forma más simple de mantener cada contacto en orden.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _overviewCard(total),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'Directorio',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Text(
                        'Desliza para eliminar',
                        style: TextStyle(
                          color: nexoMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData)
                    const _LoadingDirectory()
                  else if (snapshot.hasError)
                    _ErrorDirectory(onRetry: _reloadUsuarios)
                  else if (usuarios.isEmpty)
                    const _EmptyDirectory()
                  else
                    ...usuarios.map(
                      (usuario) => _usuarioCard(context, usuario, usuarios),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: nexoForest,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.hub_rounded, color: nexoLime, size: 23),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'nexo',
                style: TextStyle(
                  color: nexoInk,
                  fontSize: 21,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'TU ESPACIO PERSONAL',
                style: TextStyle(
                  color: nexoMuted,
                  fontSize: 9,
                  letterSpacing: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: () => _openRoute('/add'),
          style: FilledButton.styleFrom(
            backgroundColor: nexoForest,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text(
            'Añadir',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _overviewCard(String total) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: nexoForest,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONTACTOS GUARDADOS',
                  style: TextStyle(
                    color: Color(0xFFB8CDC4),
                    fontSize: 10,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  total,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Todo lo importante, a mano.',
                  style: TextStyle(color: Color(0xFFD8E1DC), fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: nexoLime,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.people_alt_rounded,
              color: nexoForest,
              size: 27,
            ),
          ),
        ],
      ),
    );
  }

  Widget _usuarioCard(BuildContext context, dynamic usuario, List usuarios) {
    final uid = usuario['uid'] as String;
    final nombre = (usuario['nombre'] ?? '').toString();
    final email = (usuario['email'] ?? '').toString();
    final cuenta = (usuario['numero de cuenta'] ?? '').toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey(uid),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFB54747),
            borderRadius: BorderRadius.circular(19),
          ),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
        ),
        confirmDismiss: (_) async {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text('¿Eliminar a $nombre?'),
              content: const Text('Esta persona se quitará de tu directorio.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFB54747),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          );
          if (shouldDelete != true) return false;
          await deleteUsuario(uid);
          return true;
        },
        onDismissed: (_) {
          setState(() => usuarios.removeWhere((item) => item['uid'] == uid));
        },
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          child: InkWell(
            borderRadius: BorderRadius.circular(19),
            onTap: () => _openEdit(context, usuario),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                border: Border.all(color: nexoLine),
                borderRadius: BorderRadius.circular(19),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFEAF1E7),
                    child: Text(
                      _initials(nombre),
                      style: const TextStyle(
                        color: nexoForest,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre.isEmpty ? 'Sin nombre' : nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: nexoInk,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email.isEmpty ? 'Sin correo' : email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: nexoMuted,
                            fontSize: 12,
                          ),
                        ),
                        if (cuenta.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            'CUENTA  $cuenta',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: nexoForest,
                              fontSize: 9,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: nexoMuted,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openEdit(BuildContext context, dynamic usuario) async {
    await Navigator.pushNamed(
      context,
      '/edit',
      arguments: {
        'uid': usuario['uid'],
        'nombre': usuario['nombre'],
        'email': usuario['email'],
        'numero de cuenta': usuario['numero de cuenta'],
      },
    );
    if (mounted) await _reloadUsuarios();
  }

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final words = trimmed.split(RegExp(r'\s+'));
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first[0]}${words[1][0]}'.toUpperCase();
  }
}

class _LoadingDirectory extends StatelessWidget {
  const _LoadingDirectory();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 38),
      child: Center(child: CircularProgressIndicator(color: nexoForest)),
    );
  }
}

class _ErrorDirectory extends StatelessWidget {
  const _ErrorDirectory({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: nexoLine),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, color: nexoMuted, size: 28),
          const SizedBox(height: 10),
          const Text(
            'No se pudo cargar el directorio.',
            style: TextStyle(color: nexoInk, fontWeight: FontWeight.w700),
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Intentar de nuevo'),
          ),
        ],
      ),
    );
  }
}

class _EmptyDirectory extends StatelessWidget {
  const _EmptyDirectory();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: nexoLine),
      ),
      child: const Column(
        children: [
          Icon(Icons.group_add_rounded, color: nexoForest, size: 32),
          SizedBox(height: 11),
          Text(
            'Tu directorio empieza aquí',
            style: TextStyle(
              color: nexoInk,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Añade una persona para tener sus datos siempre a mano.',
            textAlign: TextAlign.center,
            style: TextStyle(color: nexoMuted, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}
