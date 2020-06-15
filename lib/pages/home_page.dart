import 'dart:convert';

import 'package:animal/models/config.dart';
import 'package:animal/models/pet.dart';
import 'package:animal/pages/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pet> _pets;
  Config _config;
  static const _padding = EdgeInsets.symmetric(horizontal: 12);
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(),
    );
  }

  RenderObjectWidget _body() {
    if (_hasError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('An error has occured while fetching the data'),
          SizedBox(height: 12),
          RaisedButton(
            onPressed: _getData,
            child: Text('Retry'),
          ),
        ],
      );
    }
    return _config == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 12),
              Row(
                children: <Widget>[
                  if (_config?.isChatEnabled == true)
                    Expanded(
                      child: Padding(
                        padding: _padding,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: _showDialog,
                          child: Text('Chat'),
                        ),
                      ),
                    ),
                  if (_config?.isCallEnabled == true)
                    Expanded(
                      child: Padding(
                        padding: _padding,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          onPressed: _showDialog,
                          child: Text('Call'),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12),
              Padding(
                padding: _padding,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      border: Border.all(
                    width: 2,
                    color: Colors.grey,
                  )),
                  child: Text(
                    'Office Hours: ${_config.workHours}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  itemBuilder: (context, index) {
                    final pet = _pets[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          WebviewPage.route(
                            title: pet.title,
                            url: pet.contentUrl,
                          ),
                        );
                      },
                      leading: Image.network(
                        pet.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            final progress =
                                loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes;
                            return CircularProgressIndicator(value: progress);
                          }
                        },
                      ),
                      title: Text(pet.title),
                    );
                  },
                  separatorBuilder: (_, __) {
                    return Divider();
                  },
                  itemCount: _pets.length,
                ),
              )
            ],
          );
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getData() async {
    setState(() {
      _hasError = false;
    });
    final futures = <Future<Response>>[];
    futures.add(post('https://animal-c11bf.web.app/pets.json'));
    futures.add(post('https://animal-c11bf.web.app/config.json'));

    final results = await Future.wait(futures);
    final petsRes = results[0];
    final configRes = results[1];

    if (petsRes.statusCode != 200) {
      setState(() {
        _hasError = true;
      });
    } else if (configRes.statusCode != 200) {
      setState(() {
        _hasError = true;
      });
    }

    final petsJson = jsonDecode(petsRes.body);
    final configJson = jsonDecode(configRes.body)['settings'];

    final List<Pet> pets = petsJson['pets'].map<Pet>(Pet.fromJson).toList();
    final config = Config.fromJson(configJson);
    setState(() {
      _pets = pets;
      _config = config;
    });
  }

  void _showDialog() {
    String dialogText = '';
    if (_config.isWithinWorkingHours()) {
      dialogText =
          'Thank you for getting in touch with us. We’ll get back to you as soon as possible';
    } else {
      dialogText =
          'Work hours has ended. Please contact us again on the next work day';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(dialogText),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('close'),
            ),
          ],
        );
      },
    );
  }
}
