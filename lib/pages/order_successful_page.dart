import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatefulWidget {
  static const String routeName = '/successful';

  const OrderSuccessfulPage({Key? key}) : super(key: key);

  @override
  State<OrderSuccessfulPage> createState() => _OrderSuccessfulPageState();
}

class _OrderSuccessfulPageState extends State<OrderSuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Placed'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 10)
              ),
              child: const Icon(Icons.done, color: Colors.amber, size: 120,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('Your order has been placed', style: TextStyle(fontSize: 20),),
            ),
          ],
        ),
      ),
    );
  }
}
