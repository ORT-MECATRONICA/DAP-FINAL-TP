// nuevo_pais_screen.dart
import 'package:clase18_4/entities/Pais.dart';
import 'package:clase18_4/presentation/Screens/loading_screen.dart';
import 'package:clase18_4/providers/paises_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaisForm extends ConsumerStatefulWidget {
  static const name = 'addPais';

  final String? paisId;

  const PaisForm({this.paisId, super.key});

  @override
  _PaisFormState createState() => _PaisFormState(); //estado q maneja esta pantalla
}

class _PaisFormState extends ConsumerState<PaisForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _continenteController = TextEditingController();
  final TextEditingController _poblacionController = TextEditingController();
  final TextEditingController _posterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final paisesCollectionActivity = ref.read(paisesCollectionProvider); //solo la leemos
    if (widget.paisId != null && paisesCollectionActivity.hasValue) {
      final pais = paisesCollectionActivity.value![widget.paisId]!;
      _nombreController.text = pais.nombre;
      _continenteController.text = pais.continente;
      _poblacionController.text = pais.poblacion;
      _posterController.text = pais.poster;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.paisId == null ? 'Añadir' : 'Editar'} Pais',
        ),
      ),
      body: widget.paisId == null
          ? _paisForm(context)
          : switch (paisesCollectionActivity) {
              AsyncData() => _paisForm(context), // tenemos data mostramos form con los datos del empleaod
              AsyncError(:final error) => Center(
                  child:
                      Text('Error al obtener los datos del pais: $error'),
                ),
              _ => const Center(
                  child: CircularProgressIndicator(),
                ),
            },
    );
  }

  Padding _paisForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) =>
                  value!.isEmpty ? 'Porfavor ingrese un nombre' : null,
            ),
            TextFormField(
              controller: _continenteController,
              decoration: const InputDecoration(labelText: 'Continente'),
              validator: (value) =>
                  value!.isEmpty ? 'Porfavor ingrese un continente' : null,
            ),
            TextFormField(
              controller: _poblacionController,
              decoration: const InputDecoration(labelText: 'Poblacion'),
              validator: (value) =>
                  value!.isEmpty ? 'Porfavor ingrese numero de habitantes' : null,
            ),
            TextFormField(
              controller: _posterController,
              decoration: const InputDecoration(labelText: 'Foto'),
              validator: (value) =>
                  value!.isEmpty ? 'Porfavor ingrese una foto' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async { //tarea asincronica 
                if (_formKey.currentState!.validate()) {
                  final newPais = Pais(
                      nombre: _nombreController.text,
                      continente: _continenteController.text,
                      poblacion: _poblacionController.text,
                      poster: _posterController.text);
                  if (widget.paisId == null) {
                    await LoadingScreen.showLoadingScreen(
                      context,
                      ref
                          .read(paisesCollectionProvider.notifier)
                          .createPais(newPais),
                    );
                  } else {
                    await LoadingScreen.showLoadingScreen(
                      context,
                      ref
                          .read(paisesCollectionProvider.notifier)
                          .updatePais(widget.paisId!, newPais),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(124, 165, 165, 165),
                  ),
              label: Text('Guardar Pais', style: TextStyle(color: Color.fromRGBO(73, 113, 68, 0.648),),)
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _continenteController.dispose();
    _poblacionController.dispose();
    super.dispose();
  }
}
