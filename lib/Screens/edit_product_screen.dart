import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/Providers/product.dart';
import 'package:shopapp/Providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const String routeName = "/editProductScreen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageURLNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _imageURLTextController = TextEditingController();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageURL: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    _imageURLNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final productID = ModalRoute.of(context)!.settings.arguments as String?;
      if (productID != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findProductByID(productID);
        _initValues = {
          "title": _editedProduct.title!,
          "description": _editedProduct.description!,
          "price": _editedProduct.price.toString(),
          "imageUrl": ""
        };
        _imageURLTextController.text = _editedProduct.imageURL!;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceNode.dispose();
    _descriptionNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageURLNode.hasFocus) {
      if ((!_imageURLTextController.text.startsWith('http') &&
              !_imageURLTextController.text.startsWith('https')) ||
          (!_imageURLTextController.text.endsWith('.png') &&
              !_imageURLTextController.text.endsWith('.jpg') &&
              !_imageURLTextController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateItem(_editedProduct.id!, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addItems(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Edit Product"),
          actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        key: _form,
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Product Name"),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        description: _editedProduct.description,
                        imageURL: _editedProduct.imageURL,
                        title: value,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct.isFavorite);
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceNode);
                  },
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter product name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Product Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        description: _editedProduct.description,
                        imageURL: _editedProduct.imageURL,
                        title: _editedProduct.title,
                        price: double.parse(value!),
                        isFavorite: _editedProduct.isFavorite);
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionNode);
                  },
                  focusNode: _priceNode,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please provide a price";
                    }
                    if (double.tryParse(value!) == null) {
                      return "Please Enter Number";
                    }
                    if (double.parse(value) <= 0) {
                      return "Please Enter Number Greater Than Zero";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Product Description"),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_imageURLNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        description: value,
                        imageURL: _editedProduct.imageURL,
                        title: _editedProduct.title,
                        price: _editedProduct.price,
                        isFavorite: _editedProduct.isFavorite);
                  },
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionNode,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please provide a description";
                    }
                    if (value!.length < 10) {
                      return "Please enter more characters in your description";
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageURLTextController.text.isEmpty
                          ? Text("Enter URL")
                          : FittedBox(
                              child: Image.network(_imageURLTextController.text,
                                  fit: BoxFit.cover),
                            ),
                    ),
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(labelText: "Enter Image URL"),
                      keyboardType: TextInputType.url,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                            imageURL: value,
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            isFavorite: _editedProduct.isFavorite);
                      },
                      textInputAction: TextInputAction.done,
                      controller: _imageURLTextController,
                      focusNode: _imageURLNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _saveForm;
                      },
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
