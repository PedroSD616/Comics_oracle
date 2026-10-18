import 'dart:convert';

import 'package:comics_oracle_app/gerenciador_estado.dart';
import 'package:comics_oracle_app/componentes/controles_usuario.dart';
import 'package:comics_oracle_app/componentes/cartao_comentario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetalhesState();
  }
}

class _DetalhesState extends State<Detalhes> {
  dynamic _personagem;

  final TextEditingController _comentarioController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _carregarPersonagem();
    context.read<GerenciadorEstado>().carregarComentarios();
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<dynamic> _acessarPersonagem(int idPersonagem) async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/personagens.json",
    );
    final dynamic dicionario = await json.decode(conteudo);

    final personagem = dicionario["personagens"].firstWhere(
      (p) => p["_id"] == idPersonagem,
    );

    return personagem;
  }

  void _carregarPersonagem() {
    final id = estadoApp.idPersonagem;

    if (id == null) return;

    _acessarPersonagem(id).then((personagem) {
      if (!mounted) return;

      setState(() {
        _personagem = personagem;
      });
    });
  }

  Widget _construirSecaoComentarios(int idPersonagem) {
    final estado = context.watch<GerenciadorEstado>();

    final comentarios = estado.comentariosDoPersonagem(idPersonagem);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Comentários",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          if (estado.carregandoComentarios)
            const Center(child: CircularProgressIndicator()),

          if (estado.erroComentarios != null) ...[
            Text(estado.erroComentarios!),
            TextButton(
              onPressed: () {
                context.read<GerenciadorEstado>().carregarComentarios();
              },
              child: const Text("Tentar novamente"),
            ),
          ],

          if (!estado.carregandoComentarios &&
              estado.erroComentarios == null) ...[
            if (comentarios.isEmpty)
              const Text("Ainda não há comentários aqui.")
            else
              ...comentarios.map(
                (comentario) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CartaoComentario(
                    comentario: comentario,
                    somenteLeitura: true,
                  ),
                ),
              ),
          ],

          if (estado.usuarioLogado &&
              !estado.carregandoComentarios &&
              estado.erroComentarios == null) ...[
            const SizedBox(height: 16),

            const Text(
              "Adicionar comentário",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const SizedBox(height: 8),

            TextField(
              controller: _comentarioController,
              minLines: 2,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: "Escreva seu comentário...",
                border: OutlineInputBorder(),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  final texto = _comentarioController.text.trim();

                  if (texto.isEmpty) return;

                  final publicado = context
                      .read<GerenciadorEstado>()
                      .adicionarComentario(
                        idPersonagem: idPersonagem,
                        conteudo: texto,
                      );

                  if (publicado) {
                    _comentarioController.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Não foi possível publicar. Verifique se os comentários foram carregados e se você está logado.",
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text("Publicar"),
              ),
            ),
          ],

          if (!estado.usuarioLogado)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text("Faça login para publicar um comentário."),
            ),
        ],
      ),
    );
  }

  Widget _exibirPersonagem() {
    final personagem = _personagem["personagem"];

    final String nome = personagem["nome"];
    final String descricao = personagem["descricao"];
    final String imagem = personagem["imagem"];
    final int idPersonagem = _personagem["_id"];
    final String avatarMundo = _personagem["mundo"]["avatar"];

    final List<dynamic> leituras = _personagem["melhoresLeituras"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Image.asset(
              avatarMundo,
              width: 38,
              height: 38,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.menu_book, size: 30);
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _personagem["mundo"]["nome"],
                style: const TextStyle(fontSize: 15),
              ),
            ),
            IconButton(
              onPressed: () {
                estadoApp.exibirPersonagens();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem principal do personagem
            SizedBox(
              width: double.infinity,
              height: 280,
              child: Image.asset(
                imagem,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image_not_supported, size: 60),
                  );
                },
              ),
            ),

            // Nome do personagem
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Center(
                child: Text(
                  nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Descrição
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sobre o personagem",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descricao,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            ControlesUsuario(
              personagem: _personagem,
              usuarioLogado: estadoApp.usuario != null,
              usuarioCurtiu: estadoApp.usuarioCurtiu(idPersonagem),

              onCurtiu: () {
                estadoApp.curtirPersonagem(idPersonagem);
              },

              onDescurtiu: () {
                estadoApp.descurtirPersonagem(idPersonagem);
              },
            ),

            // Título das recomendações
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Indicações de Melhores Leituras",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            // Lista de HQs
            if (leituras.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Nenhuma leitura recomendada disponível."),
              )
            else
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: leituras.length,
                  itemBuilder: (context, index) {
                    return _construirLeitura(leituras[index]);
                  },
                ),
              ),
            _construirSecaoComentarios(idPersonagem),
          ],
        ),
      ),
    );
  }

  Widget _construirLeitura(dynamic leitura) {
    final String titulo = leitura["titulo"];
    final String imagem = leitura["imagem"];

    return Container(
      width: 125,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 125,
              height: 170,
              child: imagem.isNotEmpty
                  ? Image.asset(
                      imagem,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const ColoredBox(
                          color: Color(0xFFEAEAEA),
                          child: Center(child: Icon(Icons.menu_book, size: 40)),
                        );
                      },
                    )
                  : const ColoredBox(
                      color: Color(0xFFEAEAEA),
                      child: Center(child: Icon(Icons.menu_book, size: 40)),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            titulo,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget detalhes = SizedBox.expand(
      child: Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );

    if (_personagem != null) {
      detalhes = _exibirPersonagem();
    }

    return detalhes;
  }
}
