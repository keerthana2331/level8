import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'auth_provider.dart';

class HomeScreen extends StatelessWidget {
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
            // Carousel Section
            _buildCarousel(),
            
            // Categories Section
            _buildCategoriesSection(),
            
            // Products Section
            _buildProductsSection(),
            
            // Wishlist Section
            _buildWishlistSection(),
            
            // Address Section
            _buildAddressSection(),
            
            // Cart Section
            _buildCartSection(),
            
            // Order Summary Section
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Popular Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _productItem('Product 1', 'https://example.com/product1.jpg', 99.99),
              _productItem('Product 2', 'https://example.com/product2.jpg', 149.99),
              _productItem('Product 3', 'https://example.com/product3.jpg', 79.99),
            ],
          ),
        ),
      ],
    );
  }

  Widget _productItem(String name, String imageUrl, double price) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, height: 150, fit: BoxFit.cover),
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('\$$price', style: TextStyle(color: Colors.green)),
          ElevatedButton(
            onPressed: () {
              // Add to cart functionality
            },
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Wishlist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
    );
  }

  Widget _wishlistItem(String name, String imageUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 150,
      child: Column(
        children: [
          Image.network(imageUrl, height: 150, fit: BoxFit.cover),
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
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Card(
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
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text('Cart Items: 3'),
            trailing: ElevatedButton(
              child: Text('View Cart'),
              onPressed: () {
                // Navigate to cart screen
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Card(
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
        // Handle navigation
      },
    );
  }
}