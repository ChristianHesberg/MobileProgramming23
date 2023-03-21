import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sensors/app_scaffold.dart';

const imageDir = '/data/user/0/com.example.sensors/cache/';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Gallery',
        body: FutureBuilder(
          future: Directory(imageDir).list().toList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 0.564,
              physics: BouncingScrollPhysics(),
              children: snapshot.data!
                  .map((e) => File(e.path))
                  .map((e) => GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PhotoScreen(file: e),
                          )),
                      child: Hero(tag: e.path, child: Image.file(e))))
                  .toList(),
            );
          },
        ));
  }
}

class PhotoScreen extends StatelessWidget {
  final File file;

  const PhotoScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(file.path.split('/').last)),
        body: Hero(tag: file.path, child: Image.file(file)));
  }
}
