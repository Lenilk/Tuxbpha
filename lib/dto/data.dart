class Data{
  final String result;
  final String value;
  const Data({required this.result,required this.value});
  factory Data.fromJson(Map<String,dynamic> json){
    return Data(
    result: json['result'] as String,
      value: json['value'] as String
    );
  }
}