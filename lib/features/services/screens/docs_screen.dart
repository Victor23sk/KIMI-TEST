import 'package:flutter/material.dart';

import '../../../core/widgets/brand_mark.dart';

class DocsScreen extends StatefulWidget {
  const DocsScreen({super.key});

  @override
  State<DocsScreen> createState() => _DocsScreenState();
}

class _DocsScreenState extends State<DocsScreen> {
  final _docs = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Документы')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _docs.add('Документ ${_docs.length + 1} (демо)')),
        icon: const Icon(Icons.upload_file_outlined),
        label: const Text('Загрузить'),
      ),
      body: ContentWidth(
        child: _docs.isEmpty
            ? const Center(child: Text('Загрузите паспорт или справки — демо без бэкенда'))
            : ListView.builder(
                itemCount: _docs.length,
                itemBuilder: (context, i) => SurfaceCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined),
                    title: Text(_docs[i]),
                    subtitle: const Text('На проверке'),
                  ),
                ),
              ),
      ),
    );
  }
}
