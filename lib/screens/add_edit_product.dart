import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class AddEditProduct extends StatefulWidget {
  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  final _focusNodes = {
    'price': FocusNode(),
    'description': FocusNode(),
    'image': FocusNode(),
  };
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _newProduct =
      Product(id: null, title: '', description: '', price: 0, imgUrl: '');
  var _initValue = {
    'title': '',
    'price': '',
    'description': '',
  };
  var _isLoading = false;

  @override
  void initState() {
    _focusNodes['image'].addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      return;
    }

    final productId = ModalRoute.of(context).settings.arguments as String;

    if (productId == null) {
      return;
    }

    _newProduct = Provider.of<Products>(context).findById(productId);
    _initValue = {
      'title': _newProduct.title,
      'price': _newProduct.price.toString(),
      'description': _newProduct.description,
    };

    _imageUrlController.text = _newProduct.imgUrl;
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNodes['image'].removeListener(_updateImageUrl);
    _focusNodes.forEach((key, val) {
      if (_focusNodes.containsKey(key)) {
        _focusNodes[key].dispose();
      }
    });
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_focusNodes['image'].hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (_form.currentState.validate()) {
      _isLoading = true;
      _form.currentState.save();

      if (_newProduct.id != null) {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_newProduct.id, _newProduct);
        Navigator.of(context).pop();
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_newProduct);
        } catch (err) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('An error occured'),
                    content: Text('Something went wrong!'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text('Okay'))
                    ],
                  ));
        }
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.save), onPressed: _saveForm)
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValue['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_focusNodes['price']),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter value';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _newProduct = Product(
                              title: val,
                              description: _newProduct.description,
                              price: _newProduct.price,
                              imgUrl: _newProduct.imgUrl,
                              id: _newProduct.id,
                              isFavorite: _newProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_focusNodes['description']),
                        focusNode: _focusNodes['price'],
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter value';
                          }

                          if (double.tryParse(val) == null ||
                              double.parse(val) <= 0) {
                            return 'Invalid price';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          _newProduct = Product(
                              title: _newProduct.title,
                              description: _newProduct.description,
                              price: double.parse(val),
                              imgUrl: _newProduct.imgUrl,
                              id: _newProduct.id,
                              isFavorite: _newProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _focusNodes['description'],
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_focusNodes['price']),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter value';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _newProduct = Product(
                              title: _newProduct.title,
                              description: val,
                              price: _newProduct.price,
                              imgUrl: _newProduct.imgUrl,
                              id: _newProduct.id,
                              isFavorite: _newProduct.isFavorite);
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 16),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _focusNodes['image'],
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (val) {
                                _newProduct = Product(
                                    title: _newProduct.title,
                                    description: _newProduct.description,
                                    price: _newProduct.price,
                                    imgUrl: val,
                                    id: _newProduct.id,
                                    isFavorite: _newProduct.isFavorite);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
                ),
              ));
  }
}
