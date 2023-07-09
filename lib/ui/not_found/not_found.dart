import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stake_calculator/ui/create_stake/create_stake.dart';
import 'package:stake_calculator/util/route_utils/app_router.dart';

class NotFound extends StatefulWidget {
  const NotFound({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/not_found.json"),
            Container(
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                children: [
                  const Text(
                    "You do not have a licence key. Kindly enter your licence key to continue",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppRouter.gotoWidget(const CreateStake(), context,
                          clearStack: true);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Enter Licence",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
