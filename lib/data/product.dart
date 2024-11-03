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

  // Factory constructor to create a Product with the correct image
  factory Product.withImage({
    required int id,
    required String title,
    required DateTime date,
  }) {
    String image;
    switch (title) {
      case 'Powder printer':
        image = 'assets/images/powder-printer.png';
        break;
      case 'Wire printer':
        image = 'assets/images/wire-printer.png';
        break;
      case 'Resin printer':
        image = 'assets/images/resin-printer.png';
        break;
      default:
        image = ''; // Default image
    }
    return Product(id: id, title: title, date: date, image: image);
  }
}
