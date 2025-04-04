class SelectType {
  final int id;
  final dynamic value;
  final String label;
  bool isSelected;

  SelectType.create({
    required this.id,
    required this.value,
    required this.label,
    this.isSelected = false
  });
}