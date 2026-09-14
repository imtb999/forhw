// ============================================================
// TASK 1 — Multiplication table 1-10
// ============================================================
void multiplicationTable() {
  print('=== TASK 1: MULTIPLICATION TABLE ===');
  for (int i = 1; i <= 10; i++) {
    for (int j = 1; j <= 10; j++) {
      print('$i * $j = ${i * j}');
    }
    print('');
  }
}

// ============================================================
// TASK 2 — Next day
// ============================================================
bool isLeapYear(int year) {
  if (year % 400 == 0) return true;
  if (year % 100 == 0) return false;
  return year % 4 == 0;
}

int daysInMonth(int month, int year) {
  if (month == 2) return isLeapYear(year) ? 29 : 28;
  if (month == 4 || month == 6 || month == 9 || month == 11) return 30;
  return 31;
}

String twoDigits(int n) => n < 10 ? '0$n' : '$n';

String nextDay(int day, int month, int year) {
  // validation
  if (year < 1) return 'invalid date';
  if (month < 1 || month > 12) return 'invalid date';
  if (day < 1 || day > daysInMonth(month, year)) return 'invalid date';

  int newDay = day + 1;
  int newMonth = month;
  int newYear = year;

  if (newDay > daysInMonth(month, year)) {
    newDay = 1;
    newMonth++;
  }
  if (newMonth > 12) {
    newMonth = 1;
    newYear++;
  }

  return '${twoDigits(newDay)}.${twoDigits(newMonth)}.$newYear';
}

void testNextDay() {
  print('=== TASK 2: NEXT DAY ===');
  print('05.09.2026 -> ${nextDay(5, 9, 2026)}');   // 06.09.2026
  print('28.02.2024 -> ${nextDay(28, 2, 2024)}');  // 29.02.2024 (leap)
  print('28.02.2026 -> ${nextDay(28, 2, 2026)}');  // 01.03.2026
  print('29.02.2026 -> ${nextDay(29, 2, 2026)}');  // invalid date
  print('28.02.2100 -> ${nextDay(28, 2, 2100)}');  // 01.03.2100 (not leap)
  print('28.02.2000 -> ${nextDay(28, 2, 2000)}');  // 29.02.2000 (leap)
  print('31.12.2025 -> ${nextDay(31, 12, 2025)}'); // 01.01.2026
  print('31.04.2025 -> ${nextDay(31, 4, 2025)}');  // invalid date
  print('');
}

// ============================================================
// TASK 3 — Vowel counter
// ============================================================
int countVowels(String text) {
  const String vowels = 'aeiou';
  int count = 0;

  for (int i = 0; i < text.length; i++) {
    String letter = text[i].toLowerCase();
    if (vowels.contains(letter)) {
      count++;
    }
  }
  return count;
}

void testVowels() {
  print('=== TASK 3: VOWEL COUNTER ===');
  String phrase = 'flutter mobile development';
  print('"$phrase" -> ${countVowels(phrase)}'); // 9
  print('"Dart" -> ${countVowels("Dart")}');    // 1
  print('"" -> ${countVowels("")}');            // 0
  print('');
}

// ============================================================
// TASK 4 — Manual min & max finder
// ============================================================
void findMinMax(List<int> numbers) {
  if (numbers.isEmpty) {
    print('list is empty');
    return;
  }

  int max = numbers[0];
  int min = numbers[0];

  for (int i = 1; i < numbers.length; i++) {
    if (numbers[i] > max) max = numbers[i];
    if (numbers[i] < min) min = numbers[i];
  }

  print('$numbers -> max: $max, min: $min');
}

void testMinMax() {
  print('=== TASK 4: MIN & MAX ===');
  findMinMax([14, 88, 3, 42, 99, 12, 67]);    // max: 99, min: 3
  findMinMax([234, 34, 123, 44, 949, 112, 67]); // max: 949, min: 34
  findMinMax([-5, -1, -90]);                    // max: -1, min: -90
  print('');
}

// ============================================================
// TASK 5 — Prime number checker
// ============================================================
bool isPrime(int number) {
  if (number < 2) return false;
  if (number == 2) return true;
  if (number % 2 == 0) return false;

  // enough to check odd divisors up to sqrt(number)
  for (int i = 3; i * i <= number; i += 2) {
    if (number % i == 0) return false;
  }
  return true;
}

void testPrime() {
  print('=== TASK 5: PRIME CHECKER ===');
  List<int> samples = [3, 6, 1, 2, 17, 25, 97, 100, -7];
  for (int n in samples) {
    print('$n -> ${isPrime(n) ? "prime number" : "not prime number"}');
  }
  print('');
}

// ============================================================
void main() {
  multiplicationTable();
  testNextDay();
  testVowels();
  testMinMax();
  testPrime();
}
