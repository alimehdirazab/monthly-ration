part of 'models.dart';

class TimeSlotsModel {
    final int? id;
    final String? slot;

    TimeSlotsModel({
        this.id,
        this.slot,
    });

    factory TimeSlotsModel.fromJson(Map<String, dynamic> json) => TimeSlotsModel(
        id: json["id"],
        slot: json["slot"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "slot": slot,
    };
}
