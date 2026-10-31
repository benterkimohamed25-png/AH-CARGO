import 'package:flutter/material.dart';

void main() => runApp(const AHCargoApp());

class AHCargoApp extends StatelessWidget {
  const AHCargoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AH Cargo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF07529A)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6FA),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final name = TextEditingController();
  final password = TextEditingController();
  String? error;

  void enter() {
    if (password.text == 'KAGO26' && name.text.trim().isNotEmpty) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => HomePage(user: name.text.trim())));
    } else {
      setState(() => error = 'Vérifiez le nom et le mot de passe.');
    }
  }

  @override
  void dispose() {
    name.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                const Icon(Icons.flight_takeoff, size: 76, color: Color(0xFF07529A)),
                const SizedBox(height: 12),
                const Text('AH CARGO', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const Text('Ground Handling', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 38),
                TextField(controller: name, textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Nom de l’agent', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
                const SizedBox(height: 14),
                TextField(controller: password, obscureText: true, onSubmitted: (_) => enter(),
                  decoration: const InputDecoration(labelText: 'Mot de passe', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder())),
                if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.red))),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, height: 54,
                  child: FilledButton(onPressed: enter, child: const Text('CONNEXION', style: TextStyle(fontSize: 17)))),
                const SizedBox(height: 36),
                const Text('Développé par Benterki Mohamed', style: TextStyle(fontSize: 11, color: Colors.black45)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class Flight {
  Flight({required this.number, required this.aircraft, required this.movement,
    required this.airport, required this.time, this.cargo = false, this.parking = '', this.notes = ''});
  String number, aircraft, movement, airport, time, parking, notes;
  bool cargo;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final String user;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final flights = <Flight>[];
  String movement = 'Arrivées';
  String filter = 'Tout';
  bool alertsOn = true;

  Future<void> addFlight() async {
    final result = await showDialog<Flight>(context: context, builder: (_) => const FlightDialog());
    if (result != null) setState(() => flights.add(result));
  }

  @override
  Widget build(BuildContext context) {
    final shown = flights.where((f) {
      final movementMatch = movement == 'Cargo' ? f.cargo : f.movement == movement;
      final filterMatch = filter == 'Tout' || (filter == 'Cargo' && f.cargo) ||
          (filter == 'Interne' && !f.cargo) || (filter == 'Externe' && !f.cargo);
      return movementMatch && filterMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('AH Cargo'), actions: [
        IconButton(tooltip: alertsOn ? 'Alertes ON' : 'Alertes OFF',
          onPressed: () => setState(() => alertsOn = !alertsOn),
          icon: Icon(alertsOn ? Icons.notifications_active : Icons.notifications_off,
            color: alertsOn ? Colors.green : Colors.grey)),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: addFlight,
        icon: const Icon(Icons.add), label: const Text('Ajouter une opération')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Arrivées', label: Text('Arrivées'), icon: Icon(Icons.flight_land)),
            ButtonSegment(value: 'Départs', label: Text('Départs'), icon: Icon(Icons.flight_takeoff)),
            ButtonSegment(value: 'Cargo', label: Text('Cargo'), icon: Icon(Icons.inventory_2)),
          ],
          selected: {movement}, onSelectionChanged: (v) => setState(() => movement = v.first))),
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: ['Tout', 'Interne', 'Externe', 'Cargo'].map((v) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(label: Text(v), selected: filter == v, onSelected: (_) => setState(() => filter = v)),
          )).toList())),
        Expanded(child: shown.isEmpty
          ? const Center(child: Text('Aucune opération enregistrée', style: TextStyle(color: Colors.black54)))
          : ListView.builder(padding: const EdgeInsets.all(12), itemCount: shown.length, itemBuilder: (_, i) {
            final f = shown[i];
            return Card(child: ListTile(
              leading: const Icon(Icons.flight, color: Color(0xFF07529A), size: 34),
              title: Text('${f.number} • ${f.aircraft}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${f.movement} · ${f.airport} · ${f.time}\nParking: ${f.parking.isEmpty ? '—' : f.parking}${f.notes.isEmpty ? '' : '\n${f.notes}'}'),
              isThreeLine: true,
              trailing: f.cargo ? const Chip(label: Text('CARGO')) : null,
            ));
          })),
        Padding(padding: const EdgeInsets.only(bottom: 84), child: Text('Connecté : ${widget.user}', style: const TextStyle(color: Colors.black45))),
      ]),
    );
  }
}

class FlightDialog extends StatefulWidget {
  const FlightDialog({super.key});
  @override
  State<FlightDialog> createState() => _FlightDialogState();
}

class _FlightDialogState extends State<FlightDialog> {
  final number = TextEditingController(), aircraft = TextEditingController(),
      airport = TextEditingController(), time = TextEditingController(),
      parking = TextEditingController(), notes = TextEditingController();
  String movement = 'Arrivées';
  bool cargo = false;

  @override
  void dispose() {
    for (final c in [number, aircraft, airport, time, parking, notes]) { c.dispose(); }
    super.dispose();
  }

  Widget field(TextEditingController c, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextField(controller: c, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder())),
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Nouvelle opération'),
    content: SizedBox(width: 420, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      DropdownButtonFormField<String>(value: movement, decoration: const InputDecoration(labelText: 'Mouvement'),
        items: ['Arrivées', 'Départs'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
        onChanged: (v) => setState(() => movement = v ?? 'Arrivées')),
      const SizedBox(height: 12),
      field(number, 'Numéro de vol (ex. AH6230)'),
      field(aircraft, 'Indicatif avion (ex. LIMA BRAVO)'),
      field(airport, movement == 'Arrivées' ? 'Aéroport de provenance' : 'Destination'),
      field(time, 'Heure prévue'),
      field(parking, 'Parking (ex. C, W3, S1)'),
      field(notes, 'Notes / À suivre'),
      CheckboxListTile(value: cargo, onChanged: (v) => setState(() => cargo = v ?? false),
        title: const Text('Cargo'), contentPadding: EdgeInsets.zero),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
      FilledButton(onPressed: () {
        if (number.text.trim().isEmpty || aircraft.text.trim().isEmpty) return;
        Navigator.pop(context, Flight(number: number.text.trim().toUpperCase(),
          aircraft: aircraft.text.trim().toUpperCase(), movement: movement,
          airport: airport.text.trim(), time: time.text.trim(), parking: parking.text.trim().toUpperCase(),
          notes: notes.text.trim(), cargo: cargo));
      }, child: const Text('Enregistrer')),
    ],
  );
}
