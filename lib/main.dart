import 'package:flutter/material.dart';
import 'package:geolocation/models.dart/waypoint.dart';
import 'package:geolocation/widgets/compass.dart';

void main() {
  runApp(const KGpsLocatorApp());
}

class KGpsLocatorApp extends StatelessWidget {
  const KGpsLocatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'kGPS-Locator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
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
  double latitude = -23.2048746;
  double longitude = -46.1559800;
  double altitude = 760.0;
  double heading = 45.0;

  Waypoint? navendoPara;

  final List<Waypoint> waypoints = [
    const Waypoint(nome: 'WP001', latitude: -23.165281, longitude: -45.896756),
    const Waypoint(nome: 'WP002', latitude: -23.189425, longitude: -46.026272),
    const Waypoint(nome: 'WP003', latitude: -23.811881, longitude: -45.396372),
  ];

  VoidCallback? get pararNavegacao => null;

void navegarPara(Waypoint waypoint) {
    print('voce adicionou o Navegar para ${waypoint.nome}');

    setState(() {
      navendoPara = waypoint;
    });
  }

  void paraNavegacao() {
    if (navendoPara != null) {
      print('Voce parou o Navegar para ${navendoPara!.nome}');
    }

    setState(() {
      navendoPara = null;
    });
  }

  void adicionarWaypoint() {
    print('Voce clicou no botão Add Waipoint');
  }

  void excluirWaypoint(Waypoint waypoint) {
    print('Voce adicionou o excluir Waypoint ${waypoint.nome}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('kGPS-Locator')),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            Compass(heading: heading),

            const SizedBox(height: 8),

            Text(
              'Heading: ${heading.toStringAsFixed(1)}°',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 12),

            _buildLocationInfo(),

            const SizedBox(height: 12),

            if (navendoPara != null) _buildNavigationInfo(),

            const SizedBox(height: 8),

            Expanded(child: _buildWaypointList()),
          ],
        ),
        ),

        floatingActionButton: navendoPara != null
            ? FloatingActionButton.extended(
                onPressed: pararNavegacao,
                icon: const Icon(Icons.stop),
                label: const Text('STOP'),
              )
            : null,

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: adicionarWaypoint,
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Add Waypoint'),
          ),
        ),
     );
   }

  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _infoRow('Latitude', '${latitude.toStringAsFixed(6)}°'),
              _infoRow('Longitude', '${longitude.toStringAsFixed(6)}°'),
              _infoRow('Altitude', '${altitude.toStringAsFixed(1)} m'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationInfo() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'NAVEGANDO PARA',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(navendoPara!.nome, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            const Text('Azimute: --°   Distância: -- m'),
          ],
        ),
      ),
    );
  }

  Widget _buildWaypointList() {
    return ListView.builder(
      itemCount: waypoints.length,
      itemBuilder: (context, index) {
        final waypoint = waypoints[index];

        return Dismissible(
          key: ValueKey(waypoint.nome),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, size: 30),
          ),
          onDismissed: (_) {
            excluirWaypoint(waypoint);
          },
          child: ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(waypoint.nome),
            subtitle: Text(
              '${waypoint.latitude.toStringAsFixed(6)}, '
              '${waypoint.longitude.toStringAsFixed(6)}',
            ),
            onLongPress: () {
              navegarPara(waypoint);
            },
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
  }