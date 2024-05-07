import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/cart.dart';
import 'package:shop/wishlist.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  Future<String> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('user_name') ?? '';
    print(("$username LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL"));
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.deepOrange,
      backgroundColor: Colors.grey.shade100,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Wishlist()),
                );
              },
              child: Icon(
                Icons.favorite,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () async {
                String username = await getUser();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cart(
                      username: username,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.shopping_bag_rounded,
                color: Colors.deepOrange,
              ),
            )
          ],
        ),
      ),
    );
  }
}
