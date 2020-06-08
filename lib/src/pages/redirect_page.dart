import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/providers/uniLinksInfo.dart';
import 'package:uni_links/uni_links.dart';

class RedirectPage extends StatefulWidget {
  @override
  _RedirectPageState createState() => new _RedirectPageState();
}

enum UniLinksType { string, uri }

class _RedirectPageState extends State<RedirectPage>
    with SingleTickerProviderStateMixin {
  String _latestLink = 'Unknown';
  Uri _latestUri;
  UniLiksInfo uniLiksInfo;
  StreamSubscription _sub;
  UniLinksType _type = UniLinksType.string;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  @override
  dispose() {
    if (_sub != null) _sub.cancel();
    _latestLink = null;
    print('adios mundo');
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  /// An implementation using a [String] link
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
      if (link != null) redirectTo(link);
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null && uniLiksInfo.lastUniLink!=initialLink) redirectTo(initialLink);
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = initialLink;
      _latestUri = initialUri;
    });
  }

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _latestLink = uri?.toString() ?? 'Unknown';
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest Uri
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
      initialLink = initialUri?.toString();
    } on PlatformException {
      initialUri = null;
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = null;
      initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = initialUri;
      _latestLink = initialLink;
    });
  }

  void redirectTo(String link) {
    print('redirecTO');
    uniLiksInfo.lastUniLink=link;
    if(!mounted) return;
    Navigator.of(context).pushReplacementNamed('recuperar',arguments: link);
  }

  @override
  Widget build(BuildContext context) {
    uniLiksInfo = Provider.of<UniLiksInfo>(context);
    print('creando widgets');
    return new MaterialApp(
        home: new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              title: new Text('Plugin example app'),
            ),
            body: Center(
                child: Column(
              children: <Widget>[
                Text('${_latestUri?.path}'),
                Text('$_latestLink'),
              ],
            ))));
  }
}
