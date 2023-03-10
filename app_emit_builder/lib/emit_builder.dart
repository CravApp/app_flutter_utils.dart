import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tekartik_app_emit/emit.dart';

/// Very bad idea....
@deprecated
class EmitFutureOrBuilder<T> extends StatefulWidget {
  final EmitFutureOr<T> futureOr;
  final AsyncWidgetBuilder<T> builder;

  const EmitFutureOrBuilder(
      {Key key, @required this.futureOr, @required this.builder})
      : super(key: key);

  @override
  _EmitFutureOrBuilderState<T> createState() => _EmitFutureOrBuilderState<T>();
}

// ignore: deprecated_member_use_from_same_package
class _EmitFutureOrBuilderState<T> extends State<EmitFutureOrBuilder<T>> {
  EmitFutureOrSubscription<T> subscription;

  @override
  Widget build(BuildContext context) {
    subscription?.cancel();
    var value = widget.futureOr.toFutureOr();
    if (value is Future) {
      var completer = Completer<T>.sync();
      subscription = widget.futureOr.listen((value) {
        completer.complete(value);
      }, onError: (error) {
        completer.completeError(error);
      });
      return FutureBuilder<T>(
          future: completer.future, builder: widget.builder);
    } else {
      return widget.builder(
          context, AsyncSnapshot<T>.withData(ConnectionState.done, value as T));
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the fetch if needed
    subscription?.cancel();
  }
}
