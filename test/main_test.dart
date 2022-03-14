import 'package:sliver_bottom_bar/sliver_bottom_bar.dart';
// import 'package:flutter_test/flutter_test.dart';
import 'package:test/test.dart';

void main() {
  // 24 for itemsLength will be more than an enough i guess
  int itemsLength = 24;
  group('GroupsBottomNavigationBar.generateDefaultItemsBeneath', () {
    // for every case of returnLength from 2 to 6, is asserted out in the method body
    // ps. why robbin the choice of only one ? even asserted ? cause the
    //GroupsBottomNavigationBar.generateDefaultItemsBeneath.delimiter, tried with
    //int.floor and int.ciel as quick fixes but if you have another fix by all means!!
    //this file is only testing this method!!
    // ps. why i choose 6 ? I've seen an app using 6 items in the bottom navigation bar in production !!
    for (var returnLength = 2; returnLength < 5; returnLength++) {
      // generating the function with $returnLength
      ItemsSelector itemsBeneath =
          GroupsBottomNavigationBar.generateDefaultItemsBeneath(
              itemsLength: itemsLength, returnLength: returnLength);
      // results of all index cases in the $returnLength

      // no results should be empty
      group('method return should not be empty', () {
        for (var index = 0; index < itemsLength; index++) {
          List<int> results = itemsBeneath(index);
          test(
              'method return should not be empty when using: \n1-$itemsLength as the whole list length.\n2-$returnLength as the return length.\n3-$index as the parameter for the result function.',
              () {
            expect(false, equals(results.isEmpty));
          });
        }
      });

      group('method return should never include the index', () {
        for (var index = 0; index < itemsLength; index++) {
          List<int> results = itemsBeneath(index);
          test(
              'method return should never include the index when using: \n1-$itemsLength as the whole list length.\n2-$returnLength as the return length.\n3-$index as the parameter for the result function.',
              () {
            expect(false, equals(results.contains(index)));
          });
        }
      });

      group(
          'method return should never include indexes outside the items length',
          () {
        for (var index = 0; index < itemsLength; index++) {
          List<int> results = itemsBeneath(index);
          for (var subjectIndex in results) {
            test(
                'method return should never include indexes outside the items length when using: \n1-$itemsLength as the whole list length.\n2-$returnLength as the return length.\n3-$index as the parameter for the result function.\n4-$subjectIndex as the testing index subject',
                () {
              expect(
                  true,
                  equals(
                      subjectIndex < itemsLength && !subjectIndex.isNegative));
            });
          }
        }
      });
    }
  });
}
