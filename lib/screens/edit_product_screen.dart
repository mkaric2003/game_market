// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_field, prefer_final_fields, unnecessary_null_comparison, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_mob_shop/providers/product.dart';
import 'package:my_mob_shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _videoUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    imageUrl: '',
    videoUrl: '',
    description: '',
    price: 0,
    isAction: false,
    isSport: false,
    isStrategy: false,
    isbattleRoyal: false,
  );
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'videoUrl': '',
    'imageUrl': '',
    'isSport': false,
    'isAction': false,
    'isStrategy': false,
    'isBattleRoyal': false,
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var productId;
      if (ModalRoute.of(context)!.settings.arguments != null) {
        productId = ModalRoute.of(context)!.settings.arguments as String;
      }

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
          'videoUrl': _editedProduct.videoUrl,
          'isSport': _editedProduct.isSport,
          'isAction': _editedProduct.isAction,
          'isStrategy': _editedProduct.isStrategy,
          'isBattleRoyal': _editedProduct.isbattleRoyal,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(updateImage);
    super.dispose();
  }

  void updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          ((_imageUrlController.text.startsWith('http') &&
              _imageUrlController.text.startsWith('https'))) ||
          ((_imageUrlController.text.endsWith('png') &&
              _imageUrlController.text.endsWith('jpg') &&
              _imageUrlController.text.endsWith('jpeg')))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null && _editedProduct.id!.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('An error occured!'),
              content: Text('Something went wrong!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
      setState(() {
        _isLoading = false;
      });
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 19, 65),
        title: const Text('Manage Your Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.indigo.withOpacity(0.5),
                  //Colors.white.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Form(
                  key: _form,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: _initValues['title'] as String,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  )),
                              label: Text(
                                'Title',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: newValue!,
                                imageUrl: _editedProduct.imageUrl,
                                videoUrl: _editedProduct.videoUrl,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                isSport: _editedProduct.isSport,
                                isStrategy: _editedProduct.isStrategy,
                                isbattleRoyal: _editedProduct.isbattleRoyal,
                                isAction: _editedProduct.isAction,
                              );
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            initialValue: _initValues['price'] as String,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  )),
                              label: Text(
                                'Price',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a price.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Please enter a number greater than zero.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                imageUrl: _editedProduct.imageUrl,
                                videoUrl: _editedProduct.videoUrl,
                                description: _editedProduct.description,
                                price: double.parse(newValue!),
                                isSport: _editedProduct.isSport,
                                isStrategy: _editedProduct.isStrategy,
                                isbattleRoyal: _editedProduct.isbattleRoyal,
                                isAction: _editedProduct.isAction,
                              );
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            initialValue: _initValues['description'] as String,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  )),
                              label: Text(
                                'Description',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            textInputAction: TextInputAction.next,
                            focusNode: _descriptionFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_videoUrlFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a description.';
                              }
                              if (value.length < 10) {
                                return 'Should be at least 10 characters long.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                imageUrl: _editedProduct.imageUrl,
                                videoUrl: _editedProduct.videoUrl,
                                description: newValue!,
                                price: _editedProduct.price,
                                isSport: _editedProduct.isSport,
                                isStrategy: _editedProduct.isStrategy,
                                isbattleRoyal: _editedProduct.isbattleRoyal,
                                isAction: _editedProduct.isAction,
                              );
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            initialValue: _initValues['videoUrl'] as String,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              label: Text(
                                'VideoUrl',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.next,
                            focusNode: _videoUrlFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_imageUrlFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an video URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid video URL.';
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                imageUrl: _editedProduct.imageUrl,
                                videoUrl: newValue!,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                isSport: _editedProduct.isSport,
                                isStrategy: _editedProduct.isStrategy,
                                isbattleRoyal: _editedProduct.isbattleRoyal,
                                isAction: _editedProduct.isAction,
                              );
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Column(
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  label: Text(
                                    'ImageUrl',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                controller: _imageUrlController,
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.next,
                                focusNode: _imageUrlFocusNode,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an image URL';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid image URL.';
                                  }
                                  if (!value.endsWith('png') &&
                                      !value.endsWith('jpg') &&
                                      !value.endsWith('jpeg')) {
                                    return 'Please enter a valid image URL.';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                    title: _editedProduct.title,
                                    imageUrl: newValue!,
                                    videoUrl: _editedProduct.videoUrl,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    isSport: _editedProduct.isSport,
                                    isStrategy: _editedProduct.isStrategy,
                                    isbattleRoyal: _editedProduct.isbattleRoyal,
                                    isAction: _editedProduct.isAction,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                height: 240,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                                child: _imageUrlController.text.isEmpty
                                    ? Center(
                                        child: Text(
                                        'Enter a URL',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ))
                                    : FittedBox(
                                        child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            side: BorderSide(color: Colors.white),
                            value: _editedProduct.isSport,
                            onChanged: (newValue) {
                              setState(() {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  imageUrl: _editedProduct.imageUrl,
                                  videoUrl: _editedProduct.videoUrl,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  isSport: newValue!,
                                  isStrategy: _editedProduct.isStrategy,
                                  isbattleRoyal: _editedProduct.isbattleRoyal,
                                  isAction: _editedProduct.isAction,
                                );
                              });
                            },
                            title: Text(
                              'E-Sport',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          CheckboxListTile(
                            side: BorderSide(color: Colors.white),
                            value: _editedProduct.isAction,
                            onChanged: (newValue) {
                              setState(() {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  imageUrl: _editedProduct.imageUrl,
                                  videoUrl: _editedProduct.videoUrl,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  isSport: _editedProduct.isSport,
                                  isStrategy: _editedProduct.isStrategy,
                                  isbattleRoyal: _editedProduct.isbattleRoyal,
                                  isAction: newValue!,
                                );
                              });
                            },
                            title: Text(
                              'Action',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          CheckboxListTile(
                            side: BorderSide(color: Colors.white),
                            value: _editedProduct.isStrategy,
                            onChanged: (newValue) {
                              setState(() {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  imageUrl: _editedProduct.imageUrl,
                                  videoUrl: _editedProduct.videoUrl,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  isSport: _editedProduct.isSport,
                                  isStrategy: newValue!,
                                  isbattleRoyal: _editedProduct.isbattleRoyal,
                                  isAction: _editedProduct.isAction,
                                );
                              });
                            },
                            title: Text(
                              'Strategy',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          CheckboxListTile(
                            side: BorderSide(color: Colors.white),
                            value: _editedProduct.isbattleRoyal,
                            onChanged: (newValue) {
                              setState(() {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  imageUrl: _editedProduct.imageUrl,
                                  videoUrl: _editedProduct.videoUrl,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  isSport: _editedProduct.isSport,
                                  isStrategy: _editedProduct.isStrategy,
                                  isbattleRoyal: newValue!,
                                  isAction: _editedProduct.isAction,
                                );
                              });
                            },
                            title: Text(
                              'BattleRoyal',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: saveForm,
                            child: Text('SAVE'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
