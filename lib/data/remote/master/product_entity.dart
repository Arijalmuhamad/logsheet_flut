class ProductEntity {
  final String id;
  final String? rawMaterial;
  final String? finishGood;
  final String? byProduct;
  final String? processName;
  final String? isActive;

  ProductEntity({
    required this.id,
    this.rawMaterial,
    this.finishGood,
    this.byProduct,
    this.processName,
    this.isActive,
  });

  factory ProductEntity.fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      id: map['id'] as String,
      rawMaterial: map['raw_material'] as String?,
      finishGood: map['finish_good'] as String?,
      byProduct: map['by_product'] as String?,
      processName: map['process_name'] as String?,
      isActive: map['isactive'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'raw_material': rawMaterial,
      'finish_good': finishGood,
      'by_product': byProduct,
      'process_name': processName,
      'isactive': isActive,
    };
  }

  ProductEntity copyWith({
    String? id,
    String? rawMaterial,
    String? finishGood,
    String? byProduct,
    String? processName,
    String? isActive,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      rawMaterial: rawMaterial ?? this.rawMaterial,
      finishGood: finishGood ?? this.finishGood,
      byProduct: byProduct ?? this.byProduct,
      processName: processName ?? this.processName,
      isActive: isActive ?? this.isActive,
    );
  }

  // @override
  // String toString() {
  //   return 'ProductEntity(id: $id, rawMaterial: $rawMaterial, finishGood: $finishGood, byProduct: $byProduct, processName: $processName, isActive: $isActive)';
  // }
}