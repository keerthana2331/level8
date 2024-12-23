import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> products = [
    {'name': 'Product 1', 'price': 99.99},
    {'name': 'Product 2', 'price': 149.99},
    {'name': 'Product 3', 'price': 79.99},
  ];

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  int? editingIndex;
  bool _isDeleting = false;

  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(_fadeController);
  }

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<bool> _showBulkDeleteConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete All Products'),
          content: const Text('Are you sure you want to delete all products? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete All', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              if (products.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No products to delete.')),
                );
                return;
              }

              bool shouldDelete = await _showBulkDeleteConfirmation(context);
              if (shouldDelete) {
                setState(() {
                  products.clear(); // Clear all products
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All products deleted.')),
                );
              }
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
        child: const Icon(Icons.add),
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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            duration: const Duration(milliseconds: 300),
            child: Text(
              editingIndex == null ? 'Add Product' : 'Edit Product',
              key: ValueKey(editingIndex),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField('Product Name', productNameController, TextInputType.text),
          const SizedBox(height: 16),
          _buildTextField('Product Price', productPriceController, TextInputType.number),
          const SizedBox(height: 16),
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
          const SizedBox(height: 32),
          const Text(
            'Products',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Dismissible(
                  key: Key(product['name']),
                  onDismissed: (direction) async {
                    bool shouldDelete = await _showDeleteConfirmation(context);
                    if (shouldDelete) {
                      setState(() {
                        products.removeAt(index); // Remove the product on swipe
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product deleted.')),
                      );
                    } else {
                      // If dismissed and deletion is cancelled, the product will not be deleted
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product deletion cancelled.')),
                      );
                    }
                  },
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        product['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('\$${product['price'].toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _startEdit(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool shouldDelete = await _showDeleteConfirmation(context);
                              if (shouldDelete) {
                                setState(() {
                                  products.removeAt(index); // Delete the product
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Product deleted.')),
                                );
                              }
                            },
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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void _saveProduct() {
    final name = productNameController.text.trim();
    final price = double.tryParse(productPriceController.text.trim());
    if (name.isNotEmpty && price != null) {
      setState(() {
        if (editingIndex == null) {
          products.add({'name': name, 'price': price});
        } else {
          products[editingIndex!] = {'name': name, 'price': price};
        }
      });
      _resetEditing();
    }
  }

  void _startEdit(int? index) {
    setState(() {
      editingIndex = index;
      productNameController.text = products[index!]['name'];
      productPriceController.text = products[index]['price'].toString();
    });
  }

  void _cancelEdit() {
    _resetEditing();
  }

  void _resetEditing() {
    setState(() {
      productNameController.clear();
      productPriceController.clear();
      editingIndex = null;
    });
  }
}
