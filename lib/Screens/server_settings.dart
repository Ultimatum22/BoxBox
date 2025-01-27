/*
 *  This file is part of BoxBox (https://github.com/BrightDV/BoxBox).
 * 
 * BoxBox is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BoxBox is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BoxBox.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2022-2023, BrightDV
 */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ServerSettingsScreen extends StatefulWidget {
  final Function updateParent;
  const ServerSettingsScreen(this.updateParent, {super.key});

  @override
  State<ServerSettingsScreen> createState() => _ServerSettingsScreenState();
}

class _ServerSettingsScreenState extends State<ServerSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    const String officialServer = "https://api.formula1.com";
    bool useDarkMode =
        Hive.box('settings').get('darkMode', defaultValue: true) as bool;
    List customServers =
        Hive.box('settings').get('customServers', defaultValue: []) as List;
    String savedServer = Hive.box('settings')
        .get('server', defaultValue: officialServer) as String;

    void _setState() {
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.server),
      ),
      backgroundColor: useDarkMode
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            RadioListTile(
              value: officialServer,
              title: Text(
                AppLocalizations.of(context)!.official,
                style: TextStyle(
                  color: useDarkMode ? Colors.white : Colors.black,
                ),
              ),
              groupValue: savedServer,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) => setState(
                () {
                  savedServer = value!;
                  Hive.box('settings').put('server', savedServer);
                  widget.updateParent();
                },
              ),
            ),
            for (var server in customServers)
              GestureDetector(
                onLongPress: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: useDarkMode
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              20.0,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(
                          50.0,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.deleteCustomFeed,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: useDarkMode ? Colors.white : Colors.black,
                          ), // here
                          textAlign: TextAlign.center,
                        ),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.deleteUrl,
                              style: TextStyle(
                                color:
                                    useDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              customServers.remove(server);
                              Hive.box('settings').put(
                                'customServers',
                                customServers,
                              );
                              if (server == savedServer) {
                                Hive.box('settings').put(
                                  'server',
                                  officialServer,
                                );
                              }
                              Navigator.of(context).pop();
                              _setState();
                              widget.updateParent();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.yes,
                            ),
                          ),
                        ],
                      );
                    }),
                child: InkWell(
                  child: RadioListTile(
                    value: server,
                    title: Text(
                      server,
                      style: TextStyle(
                        color: useDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    groupValue: savedServer,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) => setState(
                      () {
                        Hive.box('settings').put('server', server);
                        widget.updateParent();
                      },
                    ),
                  ),
                ),
              ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.addCustomServer,
                style: TextStyle(
                  color: useDarkMode ? Colors.white : Colors.black,
                ),
              ),
              trailing: Icon(
                Icons.add_outlined,
                color: useDarkMode ? Colors.white : Colors.black,
              ),
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController controller =
                      TextEditingController();
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      backgroundColor: useDarkMode
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            20.0,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(
                        25.0,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.customServer,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: useDarkMode ? Colors.white : Colors.black,
                        ), // here
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'https://example.com',
                              hintStyle: TextStyle(
                                color: useDarkMode
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                            cursorColor:
                                useDarkMode ? Colors.white : Colors.black,
                            style: TextStyle(
                              color: useDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Hive.box('settings').put(
                              'server',
                              controller.text,
                            );
                            customServers.add(controller.text);
                            Hive.box('settings').put(
                              'customServers',
                              customServers,
                            );
                            Navigator.of(context).pop();
                            _setState();
                            widget.updateParent();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.save,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.close,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
