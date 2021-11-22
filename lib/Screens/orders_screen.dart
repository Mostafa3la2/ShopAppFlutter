import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/orders_provider.dart';
import 'package:shopapp/Screens/app_drawer.dart';
import 'package:shopapp/Widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const String routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  Future<void>? _fetchOrder;

  Future<void> getOrders() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchOrder = getOrders();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context).fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Something happened"),
                  content: Text(error.toString()),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Dismiss"))
                  ],
                ));
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: _fetchOrder!,
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapShot.error != null) {
            return Center(
              child: Text("Something wrong happened"),
            );
          } else {
            return Consumer<Orders>(builder: (ctx, orders, child) {
              return ListView.builder(
                  itemCount: orders.orders.length,
                  itemBuilder: (ctx, i) => OrderItemWidget(orders.orders[i]));
            });
          }
          // ListView.builder(
          //     itemCount: ordersData.orders.length,
          //     itemBuilder: (ctx, i) => OrderItemWidget(ordersData.orders[i]));
        },
      ),
    );
  }
}
