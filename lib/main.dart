import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subject = useMemoized(
      () => BehaviorSubject<String>(),
      [key],
    );
    useEffect(() => subject.close, [subject]);
    return Scaffold(
      appBar: AppBar(
          title: StreamBuilder<String>(
        stream:
            subject.stream.distinct().debounceTime(const Duration(seconds: 1)),
        initialData: 'Please type in something',
        builder: (context, snapshot) {
          return Text(snapshot.requireData);
        },
      )),
      body: TextField(
        onChanged: subject.sink.add,
      ),
    );
  }
}
