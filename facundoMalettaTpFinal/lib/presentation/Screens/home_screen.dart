import 'package:clase18_4/entities/Pais.dart';
import 'package:clase18_4/presentation/widgets/Pais_item.dart';
import 'package:clase18_4/providers/paises_collection.dart';
import 'package:clase18_4/presentation/Screens/pais_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_router.dart';

class HomeScreen extends ConsumerStatefulWidget { //StatefullWidget porque la screen tiene un estado que puede variar en el tiempo, nosotros accedemos a los providers de riperpod para escuchar este estado y actualizar
  static const name = 'home';
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState(); //_HomeScreenState maneja el estado, es consumer porque asi puede acceder a los datos del empleados_collection provider que es el que interactua con firestore
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final paisesCollectionActivity =
          ref.watch(paisesCollectionProvider); // aca es donde interactuamos con el provider y con watch escuchamos los cambios lo igualamos a la activity

      return Scaffold(
        appBar: AppBar(
          title: const Text('Mis Paises'),
        ),
        body: switch (paisesCollectionActivity) { //los casos de la actividad 
          AsyncData(value: final paisesCollection) => _HomeScreen( //tenemos data
              paises: paisesCollection,
              onRefresh: _onRefresh,
              onPaisTap: (paisId) => _onPaisTap(
                context,
                paisId,
              ),
            ),
          AsyncError(:final error) => Center( //tenemos un error :(
              child: Text('Error: $error'),
            ),
          _ => const CircularProgressIndicator(),
        },
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            appRouter.push( //nuevo pais, vamos al foorm
              '/new'
            );
          },
          backgroundColor: Color.fromRGBO(129, 189, 108, 0.404),
          hoverColor: Color.fromRGBO(156, 212, 130, 0.452),
          child: const Icon(Icons.add, color: Color.fromRGBO(255, 255, 255, 1),), 
        ),
      );
    });
  }

  Future<void> _onRefresh() async {
    ref.invalidate(paisesCollectionProvider); //se invalida todo lo anterior
  }

  void _onPaisTap(BuildContext context, String paisId) { //nos vamos a ver en detalles
    appRouter.push('/info/$paisId');
  }
}

class _HomeScreen extends StatelessWidget {
  _HomeScreen({
    required this.paises,
    required this.onRefresh,
    required this.onPaisTap,
  });

  final Map<String, Pais> paises; // lista de paises mapeada 
  final Future<void> Function() onRefresh;  //devuelve una promesa porque tarda en traer las cosas 
  final Function(String paisId) onPaisTap; 


  @override
  Widget build(BuildContext context) {
    if (paises.isEmpty) {
      return const Center(child: Text('No hay paises.'));
    }

    final paisIds = paises.keys.toList(); //transformamos el map en una lista

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: paisIds.length,
        itemBuilder: (context, index) {
          final paisId = paisIds[index];
          final pais = paises[paisId]!; // obtenemos los atributos del empleado a traves de su id 
          return PaisItem( //metemos el pais en el item que cree
            pais: pais,
            onTap: () => onPaisTap(paisId),
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            text1Color:Color.fromRGBO(160, 206, 121, 0.454),
            text2Color:Color.fromRGBO(115, 194, 108, 0.47),
            arrowColor:Color.fromRGBO(117, 194, 117, 0.514),
            hoverColor: Color.fromRGBO(127, 194, 114, 0.432),
          );
        },
      ),
    );
  }
}
