import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  const UserProductItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
     leading: CircleAvatar(
       backgroundImage: NetworkImage(imgUrl),
     ),
     trailing: Container(
       width: 100,
       child: Row(
         children: <Widget>[
           IconButton(icon: Icon(Icons.edit), color: Colors.indigo, onPressed: () => Navigator.of(context).pushNamed('/edit-product', arguments: id)),
           IconButton(icon: Icon(Icons.delete), color: Colors.red, onPressed: () {}),
         ],
       ),
     ),
    );
  }
}