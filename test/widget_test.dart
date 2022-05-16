import 'package:flutter_test/flutter_test.dart';
import 'package:upstorage_desktop/pages/sell_space/space_view.dart';


void main() {
  group('Path check', (){

    test('Path with "OneDrive" part', (){
      var result = PathCheck.doPathCorrect('C:\\Users\\99som\\OneDrive\\>:C<5=BK\\tmp2');
      expect(result, 'C:\\Users\\99som\\tmp2');
    });

    test('Path without "OneDrive" part', (){
      var result = PathCheck.doPathCorrect('C:\\Users\\99som\\tmp2');
      expect(result, 'C:\\Users\\99som\\tmp2');
    });

    test('Path with "Program Files" part', (){
      var result = PathCheck.doPathCorrect('C:\\Program Files\\Users\\99som\\tmp2');
      expect(result, 'C:\\tmp2');
    });

    test('Path without "Program Files" part', (){
      var result = PathCheck.doPathCorrect('C:\\Users\\99som\\tmp2');
      expect(result, 'C:\\Users\\99som\\tmp2');
    });

    test('Path with "Program Files (x86)" part', (){
      var result = PathCheck.doPathCorrect('C:\\Program Files (x86)\\Users\\99som\\tmp2');
      expect(result, 'C:\\tmp2');
    });

    test('Path without "Program Files (x86)" part', (){
      var result = PathCheck.doPathCorrect('C:\\Users\\99som\\tmp2');
      expect(result, 'C:\\Users\\99som\\tmp2');
    });

  });
}
