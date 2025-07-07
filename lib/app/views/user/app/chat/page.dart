import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';


class UserChat extends StatelessWidget {
  const UserChat({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainUserScaffold(child: SafeArea(child: UserChatContent())),
    );
  }
}

class UserChatContent extends StatefulWidget {
  const UserChatContent({super.key});

  @override
  State<UserChatContent> createState() => _UserChatContentState();
}

class _UserChatContentState extends State<UserChatContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0088E8),
                      Color(0xFF4DACEF),
                      Colors.white,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 25),
                  child: Center(
                    child: Text(
                      'Pesan Dari Customer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14,),
          GestureDetector(
            onTap: () {
              
            },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3)
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(),
                    SizedBox(width: 14,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hendrian Yudha Pratama',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 3,),
                        Text(
                          'Hallo apakah lapangan ini tersedia ?',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
          )
        ],
      ),
    );
  }
}