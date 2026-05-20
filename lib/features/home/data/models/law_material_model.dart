import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';

class LawMaterialModel extends LawMaterial {
  const LawMaterialModel({
    required super.id,
    required super.lawId,
    required super.order,
    required super.content,
    required super.isDeleted,
  });

  factory LawMaterialModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return LawMaterialModel(
      id: _readString(
        data,
        'material_id',
        fallback: doc.id,
      ),
      lawId: _readString(data, 'law_id', fallback: ''),
      order: _readInt(data, 'order'),
      content: _readString(data, 'content', fallback: ''),
      isDeleted: _readBool(data, 'is_deleted'),
    );
  }

  static int _readInt(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  static bool _readBool(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is bool) return value;
    return false;
  }

  static String _readString(
    Map<String, dynamic> data,
    String key, {
    required String fallback,
  }) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }
}
