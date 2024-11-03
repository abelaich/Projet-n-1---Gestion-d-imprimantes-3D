class Product {
  int id; // No need for 'late', since it's required during construction
  String image;
  String title; // Mark as final if it should not change
  DateTime date; // Mark as final if it should not change

  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.date,
  });
}
