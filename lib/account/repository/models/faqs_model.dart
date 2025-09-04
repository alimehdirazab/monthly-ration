part of 'models.dart';

class FaqsModel {
    final List<Faqs> data;

    FaqsModel({
        required this.data,
    });

    factory FaqsModel.fromJson(Map<String, dynamic> json) => FaqsModel(
        data: List<Faqs>.from(json["data"].map((x) => Faqs.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Faqs {
    final int id;
    final String question;
    final String answer;

    Faqs({
        required this.id,
        required this.question,
        required this.answer,
    });

    factory Faqs.fromJson(Map<String, dynamic> json) => Faqs(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
    };
}
