import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:comics_oracle_app/autenticador.dart';
import 'package:comics_oracle_app/usuario.dart';
import 'package:flutter/material.dart';

enum EmExibicao { telaPersonagens, telaDetalhes }

class GerenciadorEstado extends ChangeNotifier {
  EmExibicao _exibicao = EmExibicao.telaPersonagens;
  EmExibicao get exibicao => _exibicao;

  int? _idPersonagem;
  int? get idPersonagem => _idPersonagem;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  bool get usuarioLogado => _usuario != null;

  final Set<int> _personagensCurtidos = {};

  bool usuarioCurtiu(int idPersonagem) {
    return _personagensCurtidos.contains(idPersonagem);
  }

  final List<Map<String, dynamic>> _comentarios = [];

  bool _comentariosCarregados = false;
  bool _carregandoComentarios = false;
  String? _erroComentarios;

  bool get carregandoComentarios => _carregandoComentarios;
  String? get erroComentarios => _erroComentarios;

  Future<void> carregarComentarios() async {
    if (_comentariosCarregados || _carregandoComentarios) {
      return;
    }

    _carregandoComentarios = true;
    _erroComentarios = null;
    notifyListeners();

    try {
      final conteudo = await rootBundle.loadString(
        "recursos/jsons/comentarios.json",
      );

      final dynamic dados = json.decode(conteudo);
      final List<dynamic> lista = dados["comentarios"];

      _comentarios
        ..clear()
        ..addAll(lista.map((item) => Map<String, dynamic>.from(item as Map)));

      _comentariosCarregados = true;
    } catch (e) {
      _erroComentarios = "Não foi possível carregar os comentários.";
    } finally {
      _carregandoComentarios = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> comentariosDoPersonagem(int idPersonagem) {
    return _comentarios.where((comentario) {
      final feed = int.tryParse(comentario["feed"].toString());

      return feed == idPersonagem;
    }).toList();
  }

  bool adicionarComentario({
    required int idPersonagem,
    required String conteudo,
  }) {
    final usuarioAtual = _usuario;
    final texto = conteudo.trim();

    if (usuarioAtual == null || texto.isEmpty || !_comentariosCarregados) {
      return false;
    }

    int maiorId = 0;

    for (final comentario in _comentarios) {
      final id = int.tryParse(comentario["_id"].toString()) ?? 0;

      if (id > maiorId) {
        maiorId = id;
      }
    }

    _comentarios.insert(0, {
      "_id": maiorId + 1,
      "feed": idPersonagem,
      "usuario": {
        "usuarioId": 0,
        "email": usuarioAtual.email,
        "nome": usuarioAtual.nome,
      },
      "content": texto,
    });

    notifyListeners();

    return true;
  }

  void exibirPersonagens() {
    _exibicao = EmExibicao.telaPersonagens;
    _idPersonagem = null;

    notifyListeners();
  }

  void exibirDetalhes(int idPersonagem) {
    _exibicao = EmExibicao.telaDetalhes;
    _idPersonagem = idPersonagem;

    notifyListeners();
  }

  void curtirPersonagem(int idPersonagem) {
    if (!usuarioLogado) return;

    final adicionou = _personagensCurtidos.add(idPersonagem);

    if (adicionou) {
      notifyListeners();
    }
  }

  void descurtirPersonagem(int idPersonagem) {
    if (!usuarioLogado) return;

    final removeu = _personagensCurtidos.remove(idPersonagem);

    if (removeu) {
      notifyListeners();
    }
  }

  Future<void> login() async {
    final usuario = await Autenticador.login();

    if (usuario != null) {
      _usuario = usuario;
      notifyListeners();
    }
  }

  Future<void> recuperarUsuario() async {
    final usuario = await Autenticador.recuperarUsuario();

    _usuario = usuario;
    notifyListeners();
  }

  Future<void> logout() async {
    await Autenticador.logout();

    _usuario = null;
    _personagensCurtidos.clear();
    notifyListeners();
  }
}

late GerenciadorEstado estadoApp;
