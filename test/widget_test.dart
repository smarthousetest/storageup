import 'package:flutter_test/flutter_test.dart';
import 'package:storageup/pages/sell_space/space_bloc.dart';

void main() {
  group('', () {
    test('Path without "OneDrive" part', () {
      var result = PathCheck.doPathCorrect('C:\\Users\\99som\\tmp2');
      expect(result, 'C:\\Users\\99som\\tmp2');
    });

    test('Path with "Program Files" part', () {
      var result =
          PathCheck.doPathCorrect('C:\\Program Files\\Users\\99som\\tmp2');
      expect(result, 'C:\\tmp2');
    });

    test('Path without "Program Files" part', () {
      var result = PathCheck.doPathCorrect('C:\\Users\\99som\\tmp2');
      expect(result, 'C:\\Users\\99som\\tmp2');
    });

    test('Path with "Program Files (x86)" part', () {
      var result = PathCheck.doPathCorrect(
          'C:\\Program Files (x86)\\Users\\99som\\tmp2');
      expect(result, 'C:\\tmp2');
    });

    test('Path without "Program Files (x86)" part', () {
      var result = PathCheck.doPathCorrect('C:\\Users\\99som\\tmp2');
      expect(result, 'C:\\Users\\99som\\tmp2');
    });
  });
}
