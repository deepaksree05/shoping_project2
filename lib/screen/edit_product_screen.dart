// import 'package:flutter/material.dart';
// import 'package:shoppingproject2/provider/product.dart';
//
// class EditProductScreen extends StatefulWidget {
//   static const routeName = '/edit-product';
//
//   @override
//   State<EditProductScreen> createState() => _EditProductScreenState();
// }
//
// class _EditProductScreenState extends State<EditProductScreen> {
//   final _priceFocusNode = FocusNode();
//   final _descriptionFocusNode = FocusNode(); // Corrected name
//   final _imageUrlController = TextEditingController();
//   final _form = GlobalKey<FormState>();
// var _editedProduct = Product(
//     id: '',
//     title: '',
//     description: '',
//     imageUrl: '',
//     price: 0 );
//   @override
//   void dispose() {
//     _priceFocusNode.dispose();
//     _descriptionFocusNode.dispose();
//     _imageUrlController.dispose();
//     super.dispose();
//   }
//  void _saveForm(){
//  _form.currentState?.save();
//  }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Product'),
//         actions: [
//           IconButton(onPressed: (){
//           _saveForm();
//
//           }, icon: Icon(Icons.save))
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _form,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Title'),
//                 textInputAction: TextInputAction.next,
//                 onFieldSubmitted: (_) {
//                   FocusScope.of(context).requestFocus(_priceFocusNode);
//                 },
//                 onSaved: (value){
//                   _editedProduct = Product(
//                       id: null,
//                       title: value,
//                       price: _editedProduct.price,
//                       description: _editedProduct.description,
//                       imageUrl: _editedProduct.imageUrl);
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Price'),
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.number,
//                 focusNode: _priceFocusNode,
//                 onFieldSubmitted: (_) {
//                   FocusScope.of(context).requestFocus(_descriptionFocusNode);
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Description'), // Corrected label
//                 textInputAction: TextInputAction.next,
//                 focusNode: _descriptionFocusNode,
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     height: 100,
//                     width: 100,
//                     margin: EdgeInsets.only(top: 8, right: 10),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         width: 1,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     child: _imageUrlController.text.isEmpty
//                         ? Text('Enter the URL')
//                         : FittedBox(
//                       child: Image.network(
//                         _imageUrlController.text,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Center(child: Text('Invalid image URL'));
//                         },
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'Image URL',
//                       ),
//                       keyboardType: TextInputType.url,
//                       textInputAction: TextInputAction.done,
//                       controller: _imageUrlController,
//                       onFieldSubmitted: (_) {
//                         setState(() {
//                           _saveForm();
//                         }); // Update the image when URL is submitted
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingproject2/provider/product.dart';
import 'package:shoppingproject2/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  @override
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    animationController.dispose();
    super.dispose();
  }

  //
  void _saveForm() {
    if (!_form.currentState!.validate()) {
      return; // If the form is not valid, return
    }
    _form.currentState!.save(); // Save the form data

    setState(() {
      _isLoading = true;
    });

    // Check if the product ID is not empty to determine if it's an update
    if (_editedProduct.id.isNotEmpty) {
      // Update the product if it already exists
       Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      // Add a new product if it doesn't exist
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        // Show an alert dialog when an error occurs
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop(); // Close the previous screen
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        final productId = args;
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator( valueColor: animationController
          .drive(ColorTween(begin: Colors.blueAccent, end: Colors.red)),))
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value ?? '',
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                     SizedBox(height: 10,),
                    TextFormField(
                      initialValue: initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          price: double.tryParse(value!) ?? 0,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      initialValue: initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value ?? '',
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Should be last 10 character long.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 10, right: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter the URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                          child: Text('Invalid image URL'));
                                    },
                                  ),
                                ),
                        ),
                        SizedBox(height: 10,),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              setState(() {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  description: _editedProduct.description,
                                  imageUrl: _imageUrlController.text,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
