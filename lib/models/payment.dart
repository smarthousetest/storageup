import 'dart:convert';

import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? importHash;
  final String? tenant;
  final String? transaction;
  final String? transactionStatus;
  final String? description;

  const Payment({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.importHash,
    this.tenant,
    this.transaction,
    this.transactionStatus,
    this.description,
  });

  factory Payment.fromMap(Map<String, dynamic> data) => Payment(
        id: data['id'] as String?,
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
        deletedAt: data['deletedAt'] as String?,
        createdBy: data['createdBy'] as String?,
        updatedBy: data['updatedBy'] as String?,
        importHash: data['importHash'] as String?,
        tenant: data['tenant'] as String?,
        transaction: data['transaction'] as String?,
        transactionStatus: data['transactionStatus'] as String?,
        description: data['description'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'importHash': importHash,
        'tenant': tenant,
        'transaction': transaction,
        'transactionStatus': transactionStatus,
        'description': description,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Payment].
  factory Payment.fromJson(String data) {
    return Payment.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Payment] to a JSON string.
  String toJson() => json.encode(toMap());

  Payment copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? createdBy,
    String? updatedBy,
    String? importHash,
    String? tenant,
    String? transaction,
    String? transactionStatus,
    String? description,
  }) {
    return Payment(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      importHash: importHash ?? this.importHash,
      tenant: tenant ?? this.tenant,
      transaction: transaction ?? this.transaction,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      createdAt,
      updatedAt,
      deletedAt,
      createdBy,
      updatedBy,
      importHash,
      tenant,
      transaction,
      transactionStatus,
      description,
    ];
  }
}
