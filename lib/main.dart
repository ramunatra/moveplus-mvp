import 'package:flutter/material.dart';

void main() {
  runApp(const MovePlusApp());
}

class MovePlusApp extends StatelessWidget {
  const MovePlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovePlus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const MovePlusHome(),
    );
  }
}

class MovePlusHome extends StatefulWidget {
  const MovePlusHome({super.key});

  @override
  State<MovePlusHome> createState() => _MovePlusHomeState();
}

class _MovePlusHomeState extends State<MovePlusHome> {
  int _pagina = 0;

  final List<String> _historico = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MovePlus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ), // CORRIGIDO: Fechamento correto da AppBar
      body: IndexedStack(
        index: _pagina,
        children: [
          HomePage(
            onCorridaSolicitada: (origem, destino, valor) {
              setState(() {
                _historico.insert(
                  0,
                  '$origem → $destino • R\$ ${valor.toStringAsFixed(2)}',
                );
                _pagina = 1;
              });
            },
          ),
          const CorridaPage(),
          HistoricoPage(historico: _historico),
          const PerfilPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pagina,
        onDestinationSelected: (index) {
          setState(() {
            _pagina = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined),
            selectedIcon: Icon(Icons.directions_car),
            label: 'Corrida',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(String origem, String destino, double valor)
      onCorridaSolicitada;

  const HomePage({
    super.key,
    required this.onCorridaSolicitada,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _origemController =
      TextEditingController();

  final TextEditingController _destinoController =
      TextEditingController();

  final String _tipoCorrida = 'Econômica';

  double _valor = 0;

  void _calcularCorrida() {
    if (_origemController.text.trim().isEmpty ||
        _destinoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe origem e destino.'),
        ),
      );
      return;
    }

    setState(() {
      if (_tipoCorrida == 'Econômica') {
        _valor = 18.50;
      } else if (_tipoCorrida == 'Conforto') {
        _valor = 25.90;
      } else {
        _valor = 34.90;
      }
    });
  }

  void _solicitarCorrida() {
    if (_valor == 0) {
      _calcularCorrida();
      return;
    }

    widget.onCorridaSolicitada(
      _origemController.text,
      _destinoController.text,
      _valor,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Corrida solicitada com sucesso!'),
      ),
    );
  }

  @override
  void dispose() {
    _origemController.dispose();
    _destinoController.dispose();
    super.dispose();
  }

  Widget _campoLocal({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _opcaoCorrida({
    required String titulo,
    required String subtitulo,
    required double valor,
    required IconData icone,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icone),
        title: Text(titulo),
        subtitle: Text(subtitulo),
        trailing: Text('R\$ ${valor.toStringAsFixed(2)}'),
        onTap: () {
          setState(() {
            _valor = valor;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Para onde vamos?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Informe os locais da sua viagem.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 25),
          _campoLocal(
            controller: _origemController,
            label: 'Local de partida',
            icon: Icons.my_location,
          ),
          const SizedBox(height: 15),
          _campoLocal(
            controller: _destinoController,
            label: 'Destino',
            icon: Icons.location_on,
          ),
          const SizedBox(height: 25),
          const Text(
            'Tipo de corrida',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _opcaoCorrida(
            titulo: 'Econômica',
            subtitulo: 'Preço mais baixo',
            valor: 18.50,
            icone: Icons.directions_car,
          ),
          _opcaoCorrida(
            titulo: 'Conforto',
            subtitulo: 'Mais conforto',
            valor: 25.90,
            icone: Icons.airline_seat_recline_normal,
          ),
          _opcaoCorrida(
            titulo: 'Premium',
            subtitulo: 'Experiência diferenciada',
            valor: 34.90,
            icone: Icons.star,
          ),
          const SizedBox(height: 20),
          if (_valor > 0)
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimativa: R\$ ${_valor.toStringAsFixed(2)}', // CORRIGIDO
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _solicitarCorrida,
                      child: const Text('Solicitar'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CorridaPage extends StatelessWidget {
  const CorridaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Tela de Corrida Ativa'),
    );
  }
}

class HistoricoPage extends StatelessWidget {
  final List<String> historico;

  const HistoricoPage({super.key, required this.historico});

  @override
  Widget build(BuildContext context) {
    if (historico.isEmpty) {
      return const Center(
        child: Text('Nenhuma corrida no histórico.'),
      );
    }

    return ListView.builder(
      itemCount: historico.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(historico[index]),
        );
      },
    );
  }
}

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Perfil do Usuário'),
    );
  }
}
