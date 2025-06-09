import 'package:flutter/material.dart';
import 'package:playlist/components/my_drawer.dart';
import 'package:provider/provider.dart';
import '../viewmodels/song_viewmodel.dart';
import '../views/song_page.dart';
import '../viewmodels/connectivity_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _snackbarShown = false;

  @override
  void initState() {
    super.initState();
    Provider.of<SongViewmodel>(context, listen: false).loadPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = context.watch<ConnectivityViewModel>().isOffline;

    // Mostrar SnackBar si hay desconexión y aún no se mostró
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isOffline && !_snackbarShown) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sin conexión a Internet'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          ),
        );
        _snackbarShown = true;
      } else if (!isOffline) {
        _snackbarShown = false; // Reiniciar si vuelve la conexión
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("P L A Y L I S T", style: TextStyle(fontSize: 16)),
      ),
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<SongViewmodel>(
        builder: (context, value, _) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (value.error != null) {
            return Center(child: Text('Error: ${value.error}'));
          }

          return ListView.builder(
            itemCount: value.playlist.length,
            itemBuilder: (context, index) {
              final song = value.playlist[index];

              return ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.music_note,
                    size: 30,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                title: Text(
                  song.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(song.author),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SongPage(song: song)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
