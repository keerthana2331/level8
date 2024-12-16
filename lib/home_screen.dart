// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [
    {'name': 'Product 1', 'price': 99.99},
    {'name': 'Product 2', 'price': 149.99},
    {'name': 'Product 3', 'price': 79.99},
  ];

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  int? editingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildFeatureIcons(),
            Expanded(
              child: _buildProductManager(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startEdit(null),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildFeatureIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _iconWithLabel(Icons.category, 'Categories'),
          _iconWithLabel(Icons.favorite, 'Wishlist'),
          _iconWithLabel(Icons.location_on, 'Address'),
          _iconWithLabel(Icons.shopping_cart, 'Cart'),
          _iconWithLabel(Icons.summarize, 'Summary'),
        ],
      ),
    );
  }

  Widget _iconWithLabel(IconData icon, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pinkAccent],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            child: Icon(icon, size: 30, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProductManager() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Text(
              editingIndex == null ? 'Add Product' : 'Edit Product',
              key: ValueKey(editingIndex),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          _buildTextField('Product Name', productNameController, TextInputType.text),
          SizedBox(height: 16),
          _buildTextField('Product Price', productPriceController, TextInputType.number),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _animatedButton(
                label: editingIndex == null ? 'Add' : 'Update',
                onTap: _saveProduct,
                colors: [Colors.green, Colors.teal],
              ),
              if (editingIndex != null)
                _animatedButton(
                  label: 'Cancel',
                  onTap: _cancelEdit,
                  colors: [Colors.redAccent, Colors.red],
                ),
            ],
          ),
          SizedBox(height: 32),
          Text(
            'Products',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Dismissible(
                  key: Key(product['name']),
                  onDismissed: (direction) => _deleteProduct(index),
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        product['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('\$${product['price'].toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _startEdit(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _animatedButton({
    required String label,
    required VoidCallback onTap,
    required List<Color> colors,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void _saveProduct() {
    final name = productNameController.text.trim();
    final price = double.tryParse(productPriceController.text.trim());

    if (name.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid product details.')),
      );
      return;
    }

    setState(() {
      if (editingIndex == null) {
        products.add({'name': name, 'price': price});
      } else {
        products[editingIndex!] = {'name': name, 'price': price};
        editingIndex = null;
      }
      productNameController.clear();
      productPriceController.clear();
    });
  }

  void _startEdit(int? index) {
    setState(() {
      editingIndex = index;
      if (index != null) {
        productNameController.text = products[index]['name'];
        productPriceController.text = products[index]['price'].toString();
      } else {
        productNameController.clear();
        productPriceController.clear();
      }
    });
  }

  void _cancelEdit() {
    setState(() {
      editingIndex = null;
      productNameController.clear();
      productPriceController.clear();
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }
}
