import 'package:flutter/material.dart';
import 'package:shopapp/Providers/orders_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;
  OrderItemWidget(this.order);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products!.length * 20 + 110, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("\$${widget.order.amount}"),
              subtitle: Text(
                  DateFormat("dd/MM/yyyy hh:mm").format(widget.order.date!)),
              trailing: IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    this._expanded = !this._expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded
                  ? min(widget.order.products!.length * 20 + 10, 100)
                  : 0,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  child: ListView.builder(
                      itemCount: widget.order.products!.length,
                      itemBuilder: (ctx, i) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.order.products![i].title!),
                              Text(
                                  "${widget.order.products![i].quantity} x ${widget.order.products![i].price}")
                            ],
                          ))),
            ),
          ],
        ),
      ),
    );
  }
}
