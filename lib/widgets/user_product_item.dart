import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imgUrl;

  const UserProductItem(this.title, this.imgUrl);

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
           IconButton(icon: Icon(Icons.edit), color: Colors.indigo, onPressed: () {}),
           IconButton(icon: Icon(Icons.delete), color: Colors.red, onPressed: () {}),
         ],
       ),
     ),
    );
  }
}