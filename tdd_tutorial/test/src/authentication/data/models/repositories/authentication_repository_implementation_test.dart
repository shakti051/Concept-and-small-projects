import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/error/failure.dart';
import 'package:tdd_tutorial/core/error/exceptions.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSrc extends Mock
  implements AuthenticationRemoteDataSource {}

  void main() {
    late AuthenticationRemoteDataSource remoteDataSource;
    late AuthenticationRepositoryImplementation repoImpl;

    setUp(() {
      remoteDataSource = MockAuthRemoteDataSrc();
      repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
    });

    final tException = APIException(
      message: 'Unknown Error Occured',
      statusCode: 500,
    );

    group('createUser', () {
      const createdAt = 'whatever.createdAt';
      const name = 'whatever.name';
      const avatar = 'whatever.avatar';
      test(
        'should call the [RemoteDataSource.createUser] and complete '
            'successfully when the call of the remote source is successful',
            () async {
          //  arrange
          when(
                () =>
                remoteDataSource.createUser(
                    createdAt: any(named: 'createdAt'),
                    name: any(named: 'name'),
                    avatar: any(named: 'avatar')),
          ).thenAnswer((_) async => Future.value());

          //  act
          final result = await repoImpl.createUser(
              createdAt: createdAt, name: name, avatar: avatar);

          //  assert
          expect(result, equals(const Right(null)));
          verify(() =>
              remoteDataSource.createUser(
                createdAt: createdAt,
                name: name,
                avatar: avatar,
              )).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );

      test(
        'should return a [APIFailure] when the call to the remote '
            'source is unsuccessful',
            () async {
          //  Arrange
          when(() =>
              remoteDataSource.createUser(
                  createdAt: any(named: 'createdAt'),
                  name: any(named: 'name'),
                  avatar: any(
                    named: 'avatar',
                  )),).thenThrow(const APIException(
            message: 'Unknown Error Occured', statusCode: 500,));

          final result = await repoImpl.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          );

          expect(
            result,
            equals(
              Left(
                ApiFailure(
                  message: tException.message,
                  statusCode: tException.statusCode,
                ),
              ),
            ),
          );
          verify(() =>
              remoteDataSource.createUser(
                  createdAt: createdAt, name: name, avatar: avatar)).called(1);
        },
      );
    });

    group('getUser', () {
      test(
        'should call the [RemoteDataSource.getUser] and return [List<User>]'
            ' when call to remote source is successful',
            () async {
          //  arrange
          when(() => remoteDataSource.getUsers()).thenAnswer(
                (_) async => [],
          );

          final result = await repoImpl.getUsers();

          expect(result, isA<Right<dynamic, List<User>>>());
          verify(() => remoteDataSource.getUsers()).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );

      test(
        'should return a [APIFailure] when the call to the remote '
            'source is unsuccessful',
            () async {
          //  arrange
          when(() => remoteDataSource.getUsers()).thenThrow(tException);

          final result = await repoImpl.getUsers();

          expect(result, equals(Left(ApiFailure.fromException(tException))));
          verify(() => remoteDataSource.getUsers()).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    });
  }