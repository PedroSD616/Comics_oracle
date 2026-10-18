import 'package:flutter/material.dart';

class CartaoDetalhesPersonagem extends StatelessWidget {
  final dynamic personagem;

  const CartaoDetalhesPersonagem({super.key, required this.personagem});

  @override
  Widget build(BuildContext context) {
    final dadosPersonagem = personagem["personagem"];

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dadosPersonagem["nome"] ?? "Personagem",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text(
              dadosPersonagem["descricao"] ?? "Descrição indisponível.",
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.favorite_rounded, color: Colors.red, size: 18),
                const SizedBox(width: 5),
                Text(
                  (personagem["likes"] ?? 0).toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
