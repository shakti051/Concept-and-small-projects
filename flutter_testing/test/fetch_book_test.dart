import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/fetch_books.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_book_test.mocks.dart';

//flutter pub run build_runner build
@GenerateMocks([http.Client])

void main() {
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
  });

  tearDown(() {
    mockClient.close();
  });

  group('Fetch books API call test', () {
    test('Should return list of books for http successful call', () async {
      when(mockClient.get(Uri.parse(fetchBooksURL))).thenAnswer(
          (realInvocation) async => http.Response(
              '[{"name": "The 5 Second Rule","auther": "Mel Robbins"}]', 200));

      //ACT && ASSERT
      expect(await fetchBooks(mockClient), isA<List<BooksListModel>>());
    });

    test('Should throw an exception when http api call finished with an error',
        () async {
      when(mockClient.get(Uri.parse(fetchBooksURL))).thenAnswer(
          (realInvocation) async => http.Response('Not Found', 404));

      //ACT && ASSERT
      expect(fetchBooks(mockClient), throwsException);
    });
  });
}
