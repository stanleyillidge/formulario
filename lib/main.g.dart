// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormResponseAdapter extends TypeAdapter<FormResponse> {
  @override
  final int typeId = 0;

  @override
  FormResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormResponse(
      edad: fields[0] as String,
      gradoEscolar: fields[1] as String,
      lenguaMaterna: fields[2] as String,
      idiomaCasa: fields[3] as String,
      answers: (fields[4] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, FormResponse obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.edad)
      ..writeByte(1)
      ..write(obj.gradoEscolar)
      ..writeByte(2)
      ..write(obj.lenguaMaterna)
      ..writeByte(3)
      ..write(obj.idiomaCasa)
      ..writeByte(4)
      ..write(obj.answers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
