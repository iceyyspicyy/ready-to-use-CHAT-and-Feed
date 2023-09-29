import 'package:flutter/material.dart';
import 'package:we_talk/components/my_list_tile.dart';
import 'package:we_talk/pages/home_page.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({super.key, this.onProfileTap, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ///header
              DrawerHeader(child: Image(image:
              NetworkImage
                ('https://scontent.fktm20-1.fna.fbcdn.net/v/t39.30808-6/282317664_5429139473816820_8362787960324578760_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=a2f6c7&_nc_ohc=esPpsw6oeEYAX9tmGCf&_nc_ht=scontent.fktm20-1.fna&oh=00_AfCfoLg0YgRq_ovStHEs7KwvRoQdZ9ltq7XZdZOh9VOlAA&oe=651858C9'),
                height: 200,
              ),

              ),
              ///home list tile
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: ()=> Navigator.pop(context),
                ),
              ///profile list tile
              MyListTile(
                icon: Icons.person,
                text: 'P R O F I L E',
                onTap: onProfileTap
                ,),
              MyListTile(
                icon: Icons.message,
                text: 'M E S S A G E',
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  HomePage()),);}
                ,),
            ],
          ),

          ///logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
                icon: Icons.logout,
                text: 'L O G O U T',
                onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
