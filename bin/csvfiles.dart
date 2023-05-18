import 'dart:io';

void main() {
  final inputFile = 'order_log00.csv';
  final inputFile0 = '0_$inputFile';
  final inputFile1 = '1_$inputFile';

  final orders = <String, List<double>>{};
  final brands = <String, Map<String, int>>{};

  final lines = File(inputFile).readAsLinesSync();

  for (final line in lines) {
    final columns = line.split(',');

    final product = columns[2].trim();
    final quantity = double.parse(columns[3]);
    final brand = columns[4].trim();

    orders.putIfAbsent(product, () => <double>[]).add(quantity);

    brands
        .putIfAbsent(product, () => <String, int>{})
        .update(brand, (value) => value + 1, ifAbsent: () => 1);
  }

  final output0 = File(inputFile0).openWrite();
  final output1 = File(inputFile1).openWrite();

  orders.forEach((product, quantities) {
    // it calculates the average quantity by using the reduce method to sum up the quantities and dividing by the length of the list.
    final sumQuantity = quantities.reduce((a, b) => a + b);
    final averageQuantity = sumQuantity / quantities.length;
    output0.write('$product,$averageQuantity\n');
  });

  brands.forEach((product, brandCounts) {
    // It finds the most popular brand by using the reduce method on the entries of the nested map.
    // It compares the values of each entry and returns the one with the higher value.
    final mostPopularBrand =
        brandCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    output1.write('$product,$mostPopularBrand\n');
  });

  output0.close();
  output1.close();

  print('Creates file $inputFile0 with content');
  print(File(inputFile0).readAsStringSync());

  print('Creates file $inputFile1 with content');
  print(File(inputFile1).readAsStringSync());
}
