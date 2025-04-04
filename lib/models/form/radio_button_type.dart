class RadioButtonType {
  final int id;
  final dynamic value;
  final String label;
  bool isSelected;

  RadioButtonType.create({
    required this.id,
    required this.value,
    required this.label,
    this.isSelected = false
  });
}