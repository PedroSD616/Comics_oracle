import 'package:flutter/material.dart';

class ControlesUsuario extends StatelessWidget {
  final dynamic personagem;

  final bool usuarioLogado;
  final bool usuarioCurtiu;

  final void Function() onCurtiu;
  final void Function() onDescurtiu;

  const ControlesUsuario({
    super.key,

    required this.personagem,
    required this.usuarioLogado,
    required this.usuarioCurtiu,

    required this.onCurtiu,
    required this.onDescurtiu,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        usuarioLogado
            ? IconButton(
                onPressed: () {
                  if (usuarioCurtiu) {
                    onDescurtiu();
                  } else {
                    onCurtiu();
                  }
                },
                icon: Icon(
                  usuarioCurtiu ? Icons.favorite : Icons.favorite_border,
                ),
                color: Colors.red,
                iconSize: 32,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
