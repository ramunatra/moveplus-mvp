
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF155EEF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final origemController = TextEditingController();
  final destinoController = TextEditingController();

  String veiculo = 'MovePlus Econômico';
  String mensagem = '';
  int pagina = 0;

  @override
  void dispose() {
    origemController.dispose();
    destinoController.dispose();
    super.dispose();
  }

  void solicitarCorrida() {
    if (origemController.text.trim().isEmpty ||
        destinoController.text.trim().isEmpty) {
      setState(() {
        mensagem = 'Informe a origem e o destino.';
      });
      return;
    }

    setState(() {
      mensagem =
          'Solicitação demonstrativa criada! '
          'Ainda não há motorista conectado.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'MovePlus',
          style: TextStyle(
            color: Color(0xFF155EEF),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                mensagem = 'Bem-vindo ao MovePlus!';
              });
            },
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: pagina == 0
          ? inicio()
          : pagina == 1
              ? corridas()
              : perfil(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: pagina,
        onDestinationSelected: (index) {
          setState(() {
            pagina = index;
            mensagem = '';
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
            label: 'Corridas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget inicio() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF155EEF),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.directions_car,
                color: Colors.white,
                size: 42,
              ),
              SizedBox(height: 14),
              Text(
                'Sua próxima viagem começa aqui.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Praticidade e conforto para chegar ao seu destino.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Para onde vamos?',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: origemController,
          decoration: InputDecoration(
            labelText: 'Local de partida',
            hintText: 'Digite seu endereço de origem',
            prefixIcon: const Icon(Icons.my_location),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: destinoController,
          decoration: InputDecoration(
            labelText: 'Destino',
            hintText: 'Para onde você quer ir?',
            prefixIcon: const Icon(Icons.location_on_outlined),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Escolha seu veículo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...[
          ('MovePlus Econômico', 'Opção econômica', Icons.directions_car),
          ('MovePlus Conforto', 'Mais conforto na viagem', Icons.airline_seat_recline_extra),
          ('MovePlus Moto', 'Para trajetos de moto', Icons.two_wheeler),
        ].map((opcao) {
          final selecionado = veiculo == opcao.$1;
          return Card(
            color: selecionado ? const Color(0xFFE8EEFF) : Colors.white,
            child: RadioListTile<String>(
              value: opcao.$1,
              groupValue: veiculo,
              onChanged: (valor) {
                setState(() {
                  veiculo = valor!;
                  mensagem = '';
                });
              },
              secondary: Icon(
                opcao.$3,
                color: const Color(0xFF155EEF),
                size: 30,
              ),
              title: Text(
                opcao.$1,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(opcao.$2),
            ),
          );
        }),
        const SizedBox(height: 16),
        SizedBox(
          height: 54,
          child: FilledButton.icon(
            onPressed: solicitarCorrida,
            icon: const Icon(Icons.search),
            label: const Text(
              'Solicitar corrida',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
        if (mensagem.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(mensagem),
          ),
        ],
        const SizedBox(height: 20),
        const Text(
          'Versão inicial demonstrativa — sem motoristas, '
          'GPS ou pagamentos conectados.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget corridas() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_car, size: 60, color: Color(0xFF155EEF)),
            SizedBox(height: 16),
            Text(
              'Minhas corridas',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Suas viagens aparecerão aqui quando o sistema '
              'de corridas estiver conectado.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget perfil() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 42,
              child: Icon(Icons.person, size: 48),
            ),
            SizedBox(height: 16),
            Text(
              'Perfil do passageiro',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Em breve: cadastro, dados pessoais e configurações.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
