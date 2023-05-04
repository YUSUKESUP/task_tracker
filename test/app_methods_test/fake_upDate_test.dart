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

    test('updateMemo should update memo in Firestore', () async {
      // メモを追加
      final memoRef = await firestore
          .collection('users')
          .doc('test_user_id')
          .collection('memos')
          .add({'text': 'Test memo', 'isDone': false});

      // メモを更新
      final snapshots = await firestore
          .collection('users')
          .doc('test_user_id')
          .collection('memos')
          .get();
      final document = snapshots.docs.first;
      await memoRepository.updateMemo(document, 'Updated memo');

      // メモが更新されたことを確認
      final snapshot = await memoRef.get();
      expect(snapshot.data()?['text'], equals('Updated memo'));
    });
  });
}
