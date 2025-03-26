// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlyDataAdapter extends TypeAdapter<MonthlyData> {
  @override
  final int typeId = 2;

  @override
  MonthlyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlyData(
      monthYear: fields[0] as String,
      totalIncome: fields[1] as double,
      totalExpense: fields[2] as double,
      categoryExpenses: (fields[3] as Map).cast<String, double>(),
      expenses: (fields[4] as List).cast<Expense>(),
    );
  }

  @override
  void write(BinaryWriter writer, MonthlyData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.monthYear)
      ..writeByte(1)
      ..write(obj.totalIncome)
      ..writeByte(2)
      ..write(obj.totalExpense)
      ..writeByte(3)
      ..write(obj.categoryExpenses)
      ..writeByte(4)
      ..write(obj.expenses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
