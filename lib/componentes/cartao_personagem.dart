import 'package:comics_oracle_app/gerenciador_estado.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartaoPersonagem extends StatelessWidget {
  final dynamic personagem;

  const CartaoPersonagem({super.key, required this.personagem});

  @override
  Widget build(BuildContext context) {
    final dadosPersonagem = personagem["personagem"];
    final mundo = personagem["mundo"];

    final estado = context.watch<GerenciadorEstado>();
    final int idPersonagem = int.parse(personagem["_id"].toString());
    final bool favorito =
        estado.usuarioLogado && estado.usuarioCurtiu(idPersonagem);

    return GestureDetector(
      onTap: () {
        estadoApp.exibirDetalhes(personagem["_id"]);
      },
      child: Card(
        color: Colors.blueGrey.shade900,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: Image.asset(
                dadosPersonagem["imagem"],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image_not_supported, size: 40),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    child: Image.asset(
                      mundo["avatar"],
                      width: 100,
                      height: 70,
                      fit: BoxFit.scaleDown,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.public);
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                dadosPersonagem["nome"],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Row(
                children: [
                  if (favorito) ...[
                    const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                  ],
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (favorito) ...[
                        const SizedBox(width: 4),
                        const Text("Favorito"),
                      ],
                    ],
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
