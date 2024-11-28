import 'package:clase18_4/entities/Pais.dart';
import 'package:flutter/material.dart';


class PaisItem extends StatelessWidget {
  const PaisItem({
    super.key,
    required this.pais,
    this.onTap, 
    required this.backgroundColor,
    required this.text1Color,
    required this.text2Color,
    required this.arrowColor,
    required this.hoverColor,
  });

  final Pais pais;
  final Color backgroundColor;
  final Color text1Color;
  final Color text2Color;
  final Color arrowColor;
  final Color hoverColor;
  final Function? onTap;


 @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: pais.poster != null
            ? _getPoster(pais.poster)
            : const Icon(Icons.emoji_people),
        title: Text("${pais.nombre} ${pais.continente}", style: TextStyle(color: text1Color),),
        subtitle: Text('Poblacion: ${pais.poblacion}', style: TextStyle(color: text2Color),),
        trailing: Icon(Icons.arrow_forward_ios, color: arrowColor),
        tileColor: backgroundColor,
        hoverColor: hoverColor,
        onTap: () => onTap?.call(),
      ),
    );
  }

  Widget _getPoster(String posterUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(posterUrl, width: 60,),
    );
  }
}