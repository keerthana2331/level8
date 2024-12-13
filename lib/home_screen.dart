import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'auth_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [
    {'name': 'Product 1', 'imageUrl': 'https://example.com/product1.jpg', 'price': 99.99},
    {'name': 'Product 2', 'imageUrl': 'https://example.com/product2.jpg', 'price': 149.99},
    {'name': 'Product 3', 'imageUrl': 'https://example.com/product3.jpg', 'price': 79.99},
  ];

  TextEditingController productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarousel(),
            _buildCategoriesSection(),
            _buildCrudSection(),
            _buildProductsSection(context),
            _buildWishlistSection(),
            _buildAddressSection(),
            _buildCartSection(),
            _buildOrderSummarySection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: [
        _carouselItem('https://example.com/image1.jpg'),
        _carouselItem('https://example.com/image2.jpg'),
        _carouselItem('https://example.com/image3.jpg'),
      ],
    );
  }

  Widget _carouselItem(String imageUrl) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _categoryItem(Icons.phone_android, 'Electronics'),
                _categoryItem(Icons.checkroom, 'Clothing'),
                _categoryItem(Icons.book, 'Books'),
                _categoryItem(Icons.sports, 'Sports'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryItem(IconData icon, String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildCrudSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: productController,
            decoration: InputDecoration(
              labelText: 'Enter Product Name',
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _addProduct,
                child: Text('Add Product'),
              ),
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Update Product'),
              ),
              ElevatedButton(
                onPressed: _deleteProduct,
                child: Text('Delete Product'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addProduct() {
    if (productController.text.isNotEmpty) {
      setState(() {
        products.add({
          'name': productController.text,
          'imageUrl': 'https://example.com/newproduct.jpg',  // Add default image URL or let users upload images
          'price': 49.99,  // Set default price or allow users to set
        });
        productController.clear();
      });
    }
  }

  void _updateProduct() {
    if (productController.text.isNotEmpty) {
      setState(() {
        products[0] = {
          'name': productController.text,
          'imageUrl': 'https://example.com/updatedproduct.jpg',
          'price': 79.99,
        };
        productController.clear();
      });
    }
  }

  void _deleteProduct() {
    setState(() {
      products.removeAt(0);  // Deleting the first product (change this to implement specific product deletion)
    });
  }

  Widget _buildProductsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: products.map((product) {
                return _productItem(context, product['name'], product['imageUrl'], product['price']);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productItem(BuildContext context, String name, String imageUrl, double price) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 150,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl, height: 150, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$$price', style: TextStyle(color: Colors.green)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showUpdateDialog(context, name);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Delete functionality
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add to cart functionality
                    },
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, String productName) {
    TextEditingController _controller = TextEditingController(text: productName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Product'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter new product name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle update logic here
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWishlistSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wishlist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _wishlistItem('Wishlist Item 1', 'https://example.com/wishlist1.jpg'),
                _wishlistItem('Wishlist Item 2', 'https://example.com/wishlist2.jpg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wishlistItem(String name, String imageUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 150,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Image.network(imageUrl, height: 150, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          // Remove from wishlist
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.shopping_cart, color: Colors.blue),
                        onPressed: () {
                          // Add to cart
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text('John Doe'),
              subtitle: Text('123 Main St, City, Country'),
              trailing: TextButton(
                child: Text('Change'),
                onPressed: () {
                  // Navigate to address management
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text('Cart Items: 3'),
              trailing: ElevatedButton(
                child: Text('View Cart'),
                onPressed: () {
                  // Navigate to cart screen
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _summaryRow('Subtotal', '\$299.97'),
                  _summaryRow('Shipping', '\$10.00'),
                  _summaryRow('Tax', '\$24.00'),
                  Divider(),
                  _summaryRow('Total', '\$333.97', isBold: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/wishlist');
            break;
          case 2:
            Navigator.pushNamed(context, '/cart');
            break;
          case 3:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
    );
  }
}
