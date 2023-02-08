import 'package:flutter/material.dart';
import 'package:ui_challenge/widgets/button.dart';
import 'package:ui_challenge/widgets/currency_card.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color(0xFF181818),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // ignore: prefer_const_constructors
                          Text(
                            "Hey, Selena",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "Webcome, back",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '\$5 194 482',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Button(
                        text: "Transfer",
                        bgColor: Color(0XFFF1B33B),
                        textColor: Colors.black,
                      ),
                      Button(
                        text: "Request",
                        bgColor: Color(0XFF1F2123),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Wallets',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('View All',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 18,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CurrencyCard(
                    name: "Euro",
                    code: "UER",
                    amount: "6 428",
                    icon: Icons.euro_rounded,
                    isInverted: false,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: const CurrencyCard(
                      name: "Bitcoin",
                      code: "BTC",
                      amount: "9 785",
                      icon: Icons.currency_bitcoin,
                      isInverted: true,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: const CurrencyCard(
                      name: "Dollar",
                      code: "USD",
                      amount: "428",
                      icon: Icons.attach_money_outlined,
                      isInverted: false,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
