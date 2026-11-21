import 'package:flutter_test/flutter_test.dart';
import 'package:lab12_bloc_shop/auth/auth_cubit.dart';

void main() {
  AuthCubit build() => AuthCubit(delay: Duration.zero);

  test('valid credentials: Loading -> Success', () async {
    final cubit = build();
    expect(cubit.state, const AuthInitial());
    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        const AuthLoading(),
        const AuthSuccess(username: 'student', email: 'student@narxoz.kz'),
      ]),
    );
    await cubit.login(' Student@narxoz.kz ', '123456');
    await states;
    await cubit.close();
  });

  test('wrong password: Loading -> Error', () async {
    final cubit = build();
    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        const AuthLoading(),
        const AuthError('Invalid email or password'),
      ]),
    );
    await cubit.login('student@narxoz.kz', 'wrong');
    await states;
    await cubit.close();
  });

  test('empty fields and bad format give specific errors', () async {
    final cubit = build();
    await cubit.login('', '');
    expect(cubit.state, const AuthError('Please enter email and password'));
    await cubit.login('student', '123456');
    expect(cubit.state, const AuthError('Invalid email format'));
    await cubit.close();
  });

  test('Equatable: equal states are equal by value', () {
    expect(
      const AuthSuccess(username: 'a', email: 'a@b.c'),
      const AuthSuccess(username: 'a', email: 'a@b.c'),
    );
    expect(const AuthError('x'), isNot(const AuthError('y')));
  });
}
