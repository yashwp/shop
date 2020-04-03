import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

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
  var _newProduct =
      Product(id: null, title: '', description: '', price: 0, imgUrl: '');

  @override
  void initState() {
    _focusNodes['image'].addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _focusNodes.forEach((key, val) {
      if (_focusNodes.containsKey(key)) {
        _focusNodes[key].dispose();
      }
    });
    _focusNodes['image'].removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_focusNodes['image'].hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (!_form.currentState.validate()) {
      _form.currentState.save();
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
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_focusNodes['price']),
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
                    );
                  },
                ),
                TextFormField(
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
                    );
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _focusNodes['description'],
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_focusNodes['price']),
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
                    );
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
                          border: Border.all(width: 1, color: Colors.grey)),
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
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _focusNodes['image'],
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter value';
                          }

                          if (!val.startsWith('http') || !val.startsWith('https')) {
                            return 'Invalid URL';
                          }
                          
                          return null;
                        },
                        onSaved: (val) {
                          _newProduct = Product(
                            title: _newProduct.title,
                            description: _newProduct.description,
                            price: _newProduct.price,
                            imgUrl: val,
                          );
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
