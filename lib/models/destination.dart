// ignore_for_file: public_member_api_docs, sort_constructors_first
class Destination {
  final String title;
  final String description;
  final String image;
  Destination({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<Destination> destinationsList = [
  Destination(title: "1", description: "Test", image: "assets/Info_card.png"),
  Destination(title: "1", description: "Test", image: "assets/Info_card.png"),
  Destination(title: "1", description: "Test", image: "assets/Info_card.png"),
  Destination(title: "1", description: "Test", image: "assets/Info_card.png")
];
