import 'package:clase18_4/app_router.dart';
import 'package:clase18_4/entities/Pais.dart';
import 'package:clase18_4/presentation/Screens/loading_screen.dart';
import 'package:clase18_4/providers/paises_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfopaisesScreen extends ConsumerStatefulWidget {
  static const name = 'InfoPaisesScreen';
  const InfopaisesScreen({super.key, required this.paisId});

  final String paisId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InfopaisesScreenState();
}

class _InfopaisesScreenState extends ConsumerState<InfopaisesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paisesCollectionActivity = ref.watch(paisesCollectionProvider);

    String? paisId = paisesCollectionActivity.asData?.valueOrNull?.keys
        .firstWhere((id) => id == widget.paisId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del pais'),
      ),
      body: switch (paisesCollectionActivity) {
        AsyncData(value: final paisesCollection) => paisId == null ||
                paisesCollection.containsKey(paisId) == false
            ? Center(
                child: Text('Pais no encontrado'),
              )
            : _InfopaisesScreen(
                pais: paisesCollection[widget.paisId]!,
                onDelete: () async {
                  await LoadingScreen.showLoadingScreen(
                    context,
                    ref
                        .read(paisesCollectionProvider.notifier)
                        .deletePais(widget.paisId),
                  );
                  appRouter.pop();
                },
                onEditTap: () {
                  appRouter.push('/edit/$paisId');
                },
              ),
        AsyncError(:final error) => Center(
            child: Text('Error al obtener los paises: $error'),
          ),
        _ => const Center(
            child: CircularProgressIndicator(),
          ),
      },
    );
  }
}

class _InfopaisesScreen extends StatelessWidget {
  const _InfopaisesScreen({
    required this.pais,
    required this.onDelete,
    required this.onEditTap,
  });

  final Pais pais;
  final Future<void> Function() onDelete;
  final void Function() onEditTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(pais.poster, height: 300),
            const SizedBox(height: 16),
            Text(
              'Nombre: ${pais.nombre}',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
            ),
            Text(
              'Continente: ${pais.continente}',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
            ),
            Text(
              'Poblacion: ${pais.poblacion}',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
            ),
            const SizedBox(height: 40),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await onDelete();
                    // Call the delete callback when the button is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    iconColor: Color.fromRGBO(157, 213, 130, 0.457),
                  ),
                  label: Text('Eliminar', style: TextStyle(color: Color.fromRGBO(0, 0, 255, 1)),),
                  icon: Icon(Icons.delete),
                ),
                ElevatedButton.icon(
                  onPressed: onEditTap,
                  style:ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  iconColor: Color.fromRGBO(159, 203, 133, 0.37),
                  ),
                  label: Text('Editar', style: TextStyle(color:Color.fromRGBO(23, 45, 212, 1) ),),
                  icon: Icon(Icons.edit, color: Color.fromRGBO(41, 49, 205, 1),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
