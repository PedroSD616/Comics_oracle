import 'dart:convert';

import 'package:comics_oracle_app/componentes/cartao_personagem.dart';
import 'package:comics_oracle_app/gerenciador_estado.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Personagens extends StatefulWidget {
  const Personagens({super.key});

  @override
  State<Personagens> createState() => _PersonagensState();
}

class _PersonagensState extends State<Personagens> {
  List<dynamic> _personagens = [];
  bool _carregandoPersonagens = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarPersonagens();
  }

  Future<List<dynamic>> _acessarPersonagens() async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/personagens.json",
    );

    final dynamic dicionario = json.decode(conteudo);

    return List<dynamic>.from(dicionario["personagens"]);
  }

  Future<void> _carregarPersonagens() async {
    setState(() {
      _carregandoPersonagens = true;
      _erro = null;
    });

    try {
      final personagens = await _acessarPersonagens();

      if (!mounted) return;

      setState(() {
        _personagens = personagens;
        _carregandoPersonagens = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = "Não foi possível carregar os personagens.";
        _carregandoPersonagens = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personagens Mais Populares"),
        actions: [
          if (estado.usuarioLogado) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  estado.usuario!.nome,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              tooltip: "Sair",
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await context.read<GerenciadorEstado>().logout();
              },
            ),
          ] else
            TextButton.icon(
              onPressed: () async {
                await context.read<GerenciadorEstado>().login();
              },
              icon: const Icon(Icons.login),
              label: const Text("Entrar"),
            ),
        ],
      ),
      body: _construirConteudo(),
    );
  }

  Widget _construirConteudo() {
    if (_carregandoPersonagens) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_erro!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _carregarPersonagens,
              child: const Text("Tentar novamente"),
            ),
          ],
        ),
      );
    }

    if (_personagens.isEmpty) {
      return const Center(child: Text("Nenhum personagem encontrado."));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 50,
        mainAxisSpacing: 50,
        childAspectRatio: 0.70,
      ),
      itemCount: _personagens.length,
      itemBuilder: (context, index) {
        return CartaoPersonagem(personagem: _personagens[index]);
      },
    );
  }
}
