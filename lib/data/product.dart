class Product {
  int id;
  String title;
  DateTime date;
  String image;

  Product({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
  });

  static String getImageForType(String title) {
    switch (title) {
      case 'Powder printer':
        return 'assets/images/powder-printer.png';
      case 'Wire printer':
        return 'assets/images/wire-printer.png';
      case 'Resin printer':
        return 'assets/images/resin-printer.png';
      default:
        return ''; // Default image
    }
  }

  // Factory constructor with automatic image assignment
  factory Product.withImage({
    required int id,
    required String title,
    required DateTime date,
  }) {
    return Product(
      id: id,
      title: title,
      date: date,
      image: getImageForType(title),
    );
  }
}
