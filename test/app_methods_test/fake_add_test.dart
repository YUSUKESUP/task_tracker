import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_crud/provider/app_methods.dart';
import 'package:firebase_crud/provider/firebase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MemoRepository', () {
    late MemoRepository memoRepository;
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      final container = ProviderContainer(
        overrides: [
          firebaseFirestoreProvider.overrideWithValue(firestore),
          uidProvider.overrideWithValue('test_user_id'),
        ],
      );
      memoRepository = container.read(memoRepositoryProvider);
    });

    test('addMemo should add memo to Firestore', () async {
      await memoRepository.addMemo('Test memo');

      // Firestoreからメモを取得
      final snapshots = await firestore
          .collection('users')
          .doc('test_user_id')
          .collection('memos')
          .get();

      // 追加されたメモが期待通りか確認
      expect(snapshots.docs.length, equals(1));
      expect(snapshots.docs.first.data()['text'], equals('Test memo'));
      expect(snapshots.docs.first.data()['isDone'], equals(false));
    });
  });
}