import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Flutter learn',
      home: RandomWords(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[200],
      )),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _listWords = <WordPair>[];
  final _fontSize = const TextStyle(fontSize: 20);
  final _save = <WordPair>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('App Title'),
          actions: [
            IconButton(
              onPressed: _savePress,
              icon: const Icon(Icons.list_rounded),
              tooltip: 'ToolTip Save',
            )
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(15),
          itemBuilder: ((context, index) {
            if (index.isOdd) return const Divider();

            final idx = index ~/ 2;
            if (idx >= _listWords.length) {
              _listWords.addAll(generateWordPairs().take(10));
            }
            final alreadySaved = _save.contains(_listWords[idx]); // NEW

            return ListTile(
              title: Text(_listWords[idx].asPascalCase, style: _fontSize),
              trailing: Icon(
                alreadySaved
                    ? Icons.airplanemode_active_outlined
                    : Icons.airplanemode_off_outlined,
                color: alreadySaved ? Colors.blue[200] : null,
                semanticLabel: alreadySaved ? 'Remove Save' : 'Save',
              ),
              onTap: () {
                setState(() {
                  if (alreadySaved) {
                    _save.remove(_listWords[idx]);
                  } else {
                    _save.add(_listWords[idx]);
                  }
                });
              },
            );
          }),
        ));
  }

  void _savePress() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _save.map((pair) {
        return ListTile(
            title: Text(
          pair.asPascalCase,
          style: _fontSize,
        ));
      });
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(tiles: tiles, context: context).toList()
          : <Widget>[];

      return Scaffold(
          appBar: AppBar(
            title: const Text('Save List Page'),
          ),
          body: ListView(
            children: divided,
          ));
    }));
  }
}
