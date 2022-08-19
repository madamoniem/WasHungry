import 'package:flutter/material.dart';

class Something extends StatelessWidget {
  const Something({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(appBar: AppBar(title: Text('Something'))),
    );
  }
}
