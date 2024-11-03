class Product {
  int id;         // Unique identifier for the product
  String title;   // Title of the printer
  DateTime date;  // Start date
  String image;   // Path to the product's image, because a picture is worth a thousand lines of code!

  Product({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
  });

  // Returns the image path based on the printer type
  static String getImageForType(String title) {
    switch (title) {
      case 'Powder printer':
        return 'assets/images/powder-printer.png';
      case 'Wire printer':
        return 'assets/images/wire-printer.png';
      case 'Resin printer':
        return 'assets/images/resin-printer.png';
      default:
        return ''; // Empty image, for those printer types that might exist!
    }
  }

  // Factory constructor that creates a Product and assigns the image automatically
  factory Product.withImage({
    required int id,
    required String title,
    required DateTime date,
  }) {
    return Product(
      id: id,
      title: title,
      date: date,
      image: getImageForType(title), // The image is now on autopilot
    );
  }
}
