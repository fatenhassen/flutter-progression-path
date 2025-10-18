 

class Product {
  final int id;  
  final String title;
  final String description; 
  final String category;
  final double price;
  final double rating;  
  final int stock;  
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.thumbnail,
  });

 
  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      id: (j['id'] as num).toInt(),  
      title: j['title'] as String,
      description: j['description'] as String,  
      category: j['category'] as String,  
      price: (j['price'] as num).toDouble(),
      rating: (j['rating'] as num).toDouble(),  
      stock: (j['stock'] as num).toInt(), 
      thumbnail: j['thumbnail'] as String,
    );
  }
  
  
  Map<String, dynamic> tojson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'rating': rating,
    'stock': stock,
    'thumbnail': thumbnail,
  };
}