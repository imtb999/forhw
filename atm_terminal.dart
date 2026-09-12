// Homework 2: Safe ATM Banking Terminal Simulator
// Demonstrates: functions, named parameters, arrow syntax (=>), sound null safety (?, ??, !)

const int correctPin = 1234;

// 1. Arrow function — prints current available balance
void checkBalance({required String name, required double balance}) =>
    print('👤 $name, your available balance is \$${balance.toStringAsFixed(2)}');

// 2. Deposit — nullable amount defaulted with ??
double deposit({required double currentBalance, double? amount}) {
  final double safeAmount = amount ?? 0.0;

  if (safeAmount <= 0) {
    print('❌ Deposit declined: amount must be greater than zero.');
    return currentBalance;
  }

  final double newBalance = currentBalance + safeAmount;
  print('🧾 RECEIPT: Deposited \$${safeAmount.toStringAsFixed(2)} — '
      'new balance \$${newBalance.toStringAsFixed(2)}');
  return newBalance;
}

// 3. Withdraw — PIN verification + balance check
double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  final int safePin = pinCode ?? 0000;

  if (safePin != correctPin) {
    print('🔒 Transaction declined for $name: incorrect or missing PIN code.');
    return currentBalance;
  }

  final double safeAmount = amount ?? 0.0;

  if (safeAmount <= 0) {
    print('❌ Transaction declined: withdrawal amount must be greater than zero.');
    return currentBalance;
  }

  if (safeAmount > currentBalance) {
    print('💸 Transaction declined: insufficient funds. '
        'Requested \$${safeAmount.toStringAsFixed(2)}, '
        'available \$${currentBalance.toStringAsFixed(2)}');
    return currentBalance;
  }

  final double newBalance = currentBalance - safeAmount;
  print('🧾 RECEIPT: $name withdrew \$${safeAmount.toStringAsFixed(2)} — '
      'new balance \$${newBalance.toStringAsFixed(2)}');
  return newBalance;
}

void main() {
  String userName = 'Temirlan';
  double balance = 500.0;

  print('=== SAFE ATM TERMINAL ===\n');

  checkBalance(name: userName, balance: balance);

  // Deposit with a value
  balance = deposit(currentBalance: balance, amount: 250.0);

  // Deposit with null (defaults to 0.0 via ??)
  balance = deposit(currentBalance: balance, amount: null);

  // Withdraw with wrong PIN
  balance = withdraw(
    name: userName,
    currentBalance: balance,
    amount: 100.0,
    pinCode: 9999,
  );

  // Withdraw with missing PIN (null -> 0000)
  balance = withdraw(name: userName, currentBalance: balance, amount: 100.0);

  // Withdraw more than available
  balance = withdraw(
    name: userName,
    currentBalance: balance,
    amount: 10000.0,
    pinCode: 1234,
  );

  // Successful withdrawal
  balance = withdraw(
    name: userName,
    currentBalance: balance,
    amount: 300.0,
    pinCode: 1234,
  );

  // Null amount with valid PIN
  balance = withdraw(
    name: userName,
    currentBalance: balance,
    amount: null,
    pinCode: 1234,
  );

  print('');
  checkBalance(name: userName, balance: balance);

  // Demonstrating the ! (null assertion) operator
  double? bonus = 50.0;
  balance = deposit(currentBalance: balance, amount: bonus!);
  checkBalance(name: userName, balance: balance);
}
