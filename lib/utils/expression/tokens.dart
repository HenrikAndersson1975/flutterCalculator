import 'token_types.dart';

class Token {
  final TokenType type;
  final double? value; // bara för number

  Token(this.type, [this.value]);

  @override
  String toString() {
    if (type == TokenType.number) return value.toString();
    return type.toString().split('.').last;
  }
}