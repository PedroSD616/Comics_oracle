import 'package:comics_oracle_app/gerenciador_estado.dart';
import 'package:comics_oracle_app/telas/detalhes.dart';
import 'package:comics_oracle_app/telas/personagens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ComicsOracle());
}

class ComicsOracle extends StatelessWidget {
  const ComicsOracle({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GerenciadorEstado(),
      child: MaterialApp(
        title: 'Comics Oracle',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          appBarTheme: AppBarTheme(backgroundColor: Colors.black87),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple,
          ),
        ),
        home: const TelaPrincipal(),
      ),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    estadoApp = context.watch<GerenciadorEstado>();

    ElevatedButton(
      onPressed: () async {
        await context.read<GerenciadorEstado>().login();
      },
      child: const Text('Entrar'),
    );

    ElevatedButton(
      onPressed: () async {
        await context.read<GerenciadorEstado>().login();
      },
      child: const Text('sair'),
    );

    Widget tela = const SizedBox.shrink();
    if (estadoApp.exibicao == EmExibicao.telaPersonagens) {
      tela = Personagens();
    } else if (estadoApp.exibicao == EmExibicao.telaDetalhes) {
      tela = Detalhes();
    }

    return tela;
  }
}
