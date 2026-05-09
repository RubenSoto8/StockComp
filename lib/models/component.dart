class Component {
  final int? id;
  final String name;
  final String category;
  final int quantity;
  final String? notes;

  Component({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'notes': notes,
    };
  }

  factory Component.fromMap(Map<String, dynamic> map) {
    return Component(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      quantity: map['quantity'],
      notes: map['notes'],
    );
  }

  Component copyWith({
    int? id,
    String? name,
    String? category,
    int? quantity,
    String? notes,
  }) {
    return Component(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }
}