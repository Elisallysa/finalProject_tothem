import 'package:flutter/material.dart';
import 'package:tothem/src/screens/screens.dart';

class UserInfoContainer extends StatelessWidget {
  final String userName;
  final String userLastname;
  final String userRole;
  final Map<String, String> userInfo = {'nombre': 'elisa'};

  UserInfoContainer(
      {this.userName = '',
      this.userLastname = '',
      this.userRole = '',
      super.key});

  UserInfoContainer copyWith({
    String? userName,
    String? userLastname,
    String? userRole,
  }) {
    return UserInfoContainer(
      userName: userName ?? this.userName,
      userLastname: userLastname ?? this.userLastname,
      userRole: userRole ?? this.userRole,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: Colors.white)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                ),
                Text(
                  '$userName $userLastname',
                  style: TothemTheme.title,
                ),
                const SizedBox(
                  width: 30,
                  child: Icon(
                    Icons.edit_outlined,
                    color: TothemTheme.brinkPink,
                  ),
                ),
              ],
            ),
            Text(
              userRole,
              style: TothemTheme.silverText,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoCard('Edad', '24', 1),
                  infoCard('Centro / empresa', 'IES Pablo Picasso', 2),
                  infoCard('Localidad', 'Málaga', 1),
                ],
              ),
            )
          ],
        ));
  }
}

Expanded infoCard(String title, String value, int flex) {
  return Expanded(
    flex: flex,
    child: Card(
        child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TothemTheme.smallTitle,
          ),
          Text(value.isEmpty ? '' : value)
        ],
      ),
    )),
  );
}

/*
GridView.builder(
                itemCount: userInfo.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4,
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  
                })

Card(
                        child: ListTile(
                      leading: const Icon(Icons.album),
                      title: Text(key),
                      subtitle: Text(value),
                    ));
                    */

