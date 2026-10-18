import 'package:flutter/material.dart';

class CartaoComentario extends StatelessWidget {
  final dynamic comentario;
  final bool somenteLeitura;

  const CartaoComentario({
    super.key,
    required this.comentario,
    required this.somenteLeitura,
  });

  @override
  Widget build(BuildContext context) {
    final corFundo = somenteLeitura
        ? Colors.red.shade800
        : Colors.blueGrey.shade100;

    final corTexto = somenteLeitura ? Colors.white : Colors.black87;

    return Card(
      color: corFundo,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comentario["content"]?.toString() ?? "",
              style: TextStyle(fontSize: 14, color: corTexto),
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                comentario["usuario"]["nome"],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: corTexto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
