import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:messageplus/controller/sms_control.dart';
import 'package:provider/provider.dart';

import 'package:line_icons/line_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<Message>(
        create: (ctx) => Message(),
        child: const HomePage(),
      ),
    );
  }
}

// CupertinoContextMenuAction(
//                               trailingIcon: _data.result! > 0.5
//                                   ? CupertinoIcons.check_mark
//                                   : CupertinoIcons.delete,
//                               child: Text(_data.result! > 0.5
//                                   ? 'Report as Safe'
//                                   : "Mark as Red"),
//                               onPressed: () {
//                                 Map<String, dynamic> _dataTmp = {
//                                   'url': _data.url,
//                                   'target': _data.result! > 0.5 ? 0 : 1,
//                                 };
//                                 control.addMessage(_dataTmp);
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             CupertinoContextMenuAction(
//                               child: const Text('Back'),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.black,
      appBar: AppBar(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        elevation: 0,
        centerTitle: true,
        title: const Text("Message+"),
      ),
      body: Consumer<Message>(
        builder: (ctx, control, _) {
          return RefreshIndicator(
            onRefresh: () async {
              await control.getMessages();
            },
            child: control.load
                ? const Center(
                    child: CupertinoTheme(
                        data: CupertinoThemeData(
                          brightness: Brightness.dark,
                        ),
                        child: CupertinoActivityIndicator()),
                  )
                : control.finalmessage.isEmpty
                    ? const Center(
                        child: Text("No Message",
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)))
                    : ListView.builder(
                        itemCount: control.finalmessage.length,
                        itemBuilder: (ctx, index) {
                          var _data = control.finalmessage[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                              vertical: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showAlertDialog(
                                  context,
                                  _data.result! < 0.5
                                      ? "Report as Insecure"
                                      : "Report as Safe",
                                  control,
                                  {
                                    "url": _data.url,
                                    "target": _data.result! < 0.5 ? 1 : 0
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _data.result! < 0.5
                                      ? CupertinoColors.activeGreen
                                      : CupertinoColors.destructiveRed,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        _data.sendername ?? '',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          decoration: TextDecoration.none,
                                          color: CupertinoColors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          _data.url!,
                                          style: GoogleFonts.sourceSansPro(
                                            textStyle: const TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Colors.white,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat('yyyy-MM-dd : kk:mm')
                                                  .format(_data.dateTime!),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.w700,
                                                color: CupertinoColors.white,
                                              ),
                                            ),
                                            Icon(
                                              _data.result! > 0.5
                                                  ? LineIcons
                                                      .exclamationTriangle
                                                  : CupertinoIcons
                                                      .check_mark_circled,
                                              color: _data.result! < 0.5
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }

  Future<void> showAlertDialog(BuildContext context, String message,
      Message control, Map<String, dynamic> data) {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: CupertinoAlertDialog(
              title: const Text("Message+"),
              content:
                  const Text('\n Your feedback will be send to our server.'),
              actions: message.contains("Safe")
                  ? [
                      CupertinoButton(
                          child: Text(
                            message,
                            style: const TextStyle(
                                color: CupertinoColors.activeGreen),
                          ),
                          onPressed: () {
                            control.addMessage(data);
                            Navigator.pop(context);
                          }),
                      CupertinoButton(
                          child: const Text(
                            "Report to Administration",
                          ),
                          onPressed: () => Navigator.pop(context)),
                      CupertinoButton(
                          child: const Text(
                            "Cancel",
                          ),
                          onPressed: () => Navigator.pop(context)),
                    ]
                  : [
                      CupertinoButton(
                          child: Text(
                            message,
                            style: const TextStyle(
                                color: CupertinoColors.destructiveRed),
                          ),
                          onPressed: () {
                            control.addMessage(data);

                            Navigator.pop(context);
                          }),
                      CupertinoButton(
                          child: const Text(
                            "Report to Administration",
                          ),
                          onPressed: () => Navigator.pop(context)),
                      CupertinoButton(
                          child: const Text(
                            "Cancel",
                          ),
                          onPressed: () => Navigator.pop(context)),
                    ],
            ),
          );
        });
  }
}
