import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider_boilerplate/provider_boilerplate.dart';

class LoadingView extends StatefulWidget {
  LoadingView({Key key, this.child}) : super(key: key);
  final Widget child;
  @override
  LoadingViewState createState() => LoadingViewState();

  static LoadingViewState of(BuildContext context) {
    assert(context != null);
    final LoadingViewState result =
        context.findAncestorStateOfType<LoadingViewState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'LoadingView.of() called with a context that does not contain a LoadingView.'),
      ErrorDescription(
          'No LoadingView ancestor could be found starting from the context that was passed to LoadingView.of(). '
          'This usually happens when the context provided is from the same StatefulWidget as that '
          'whose build function actually creates the LoadingView widget being sought.'),
      ErrorHint(
          'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
          'context that is "under" the LoadingView. For an example of this, please see the '
          'documentation for LoadingView.of():\n'
          '  https://api.flutter.dev/flutter/material/LoadingView/of.html'),
      ErrorHint(
          'A more efficient solution is to split your build function into several widgets. This '
          'introduces a new context from which you can obtain the LoadingView. In this solution, '
          'you would have an outer widget that creates the LoadingView populated by instances of '
          'your new inner widgets, and then in these inner widgets you would use LoadingView.of().\n'
          'A less elegant but more expedient solution is assign a GlobalKey to the LoadingView, '
          'then use the key.currentState property to obtain the LoadingViewState rather than '
          'using the LoadingView.of() function.'),
      context.describeElement('The context used was')
    ]);
  }
}

class LoadingViewState extends State<LoadingView> {
  StreamController<bool> _controller = StreamController<bool>();
  Stream<bool> _stream;
  @override
  void initState() {
    _stream = _controller.stream.asBroadcastStream();
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                bool isLoading = snapshot.data ?? false;
                return Visibility(
                  visible: isLoading,
                  child: Container(
                    color: Colors.white70,
                    child: AbsorbPointer(
                      absorbing: isLoading,
                      child: Center(
                          child: SpinKitThreeBounce(
                        color: Theme.of(context).accentColor,
                      )),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  showLoader() {
    _controller.add(true);
  }

  hideLoader() {
    _controller.add(false);
  }
}
