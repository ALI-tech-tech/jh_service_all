import 'package:flutter_test/flutter_test.dart';
import 'package:jh_sharedprefs/jh_sharedprefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPrefsService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final mockPrefs = await SharedPreferences.getInstance();
    service = SharedPrefsService();
    service.initWithInstance(mockPrefs);
  });

  group('Initialization and Basics', () {
    test('isInitialized and prefs are accessible', () {
      expect(service.isInitialized, isTrue);
      expect(service.prefs, isNotNull);
    });

    test('reload can be called without errors', () async {
      await service.reload();
      expect(service.isInitialized, isTrue);
    });
  });

  group('Primitive Data Types', () {
    test('String operations', () async {
      expect(service.getString('name'), isNull);
      final saved = await service.saveString('name', 'Ali');
      expect(saved, isTrue);
      expect(service.getString('name'), 'Ali');
      expect(service.containsKey('name'), isTrue);

      await service.remove('name');
      expect(service.getString('name'), isNull);
      expect(service.containsKey('name'), isFalse);
    });

    test('Int operations', () async {
      expect(service.getInt('count'), isNull);
      final saved = await service.saveInt('count', 42);
      expect(saved, isTrue);
      expect(service.getInt('count'), 42);
    });

    test('Double operations', () async {
      expect(service.getDouble('pi'), isNull);
      final saved = await service.saveDouble('pi', 3.14159);
      expect(saved, isTrue);
      expect(service.getDouble('pi'), 3.14159);
    });

    test('Bool operations', () async {
      expect(service.getBool('flag'), isNull);
      final saved = await service.saveBool('flag', true);
      expect(saved, isTrue);
      expect(service.getBool('flag'), isTrue);
    });

    test('StringList operations', () async {
      expect(service.getStringList('items'), isNull);
      final saved = await service.saveStringList('items', ['a', 'b', 'c']);
      expect(saved, isTrue);
      expect(service.getStringList('items'), ['a', 'b', 'c']);
    });
  });

  group('DateTime Support', () {
    test('saves and retrieves DateTime correctly', () async {
      final now = DateTime.now();
      final saved = await service.saveDateTime('now', now);
      expect(saved, isTrue);

      final retrieved = service.getDateTime('now');
      expect(retrieved, isNotNull);
      expect(retrieved!.millisecondsSinceEpoch, now.millisecondsSinceEpoch);
    });

    test('getDateTime returns null for non-existent or invalid key', () async {
      expect(service.getDateTime('missing'), isNull);

      await service.saveString('invalid_date', 'not-a-date');
      expect(service.getDateTime('invalid_date'), isNull);
    });
  });

  group('JSON Support', () {
    test('saves and retrieves valid JSON map', () async {
      final map = {
        'name': 'Test Project',
        'version': 1,
        'active': true,
      };

      final saved = await service.saveJson('config', map);
      expect(saved, isTrue);

      final retrieved = service.getJson('config');
      expect(retrieved, isNotNull);
      expect(retrieved!['name'], 'Test Project');
      expect(retrieved['version'], 1);
      expect(retrieved['active'], true);
    });

    test('getJson returns null for missing or corrupted data', () async {
      expect(service.getJson('missing'), isNull);

      await service.saveString('corrupt', 'not valid json {{{');
      expect(service.getJson('corrupt'), isNull);
    });
  });

  group('List Manipulations', () {
    test('addToStringList adds only unique items', () async {
      await service.saveStringList('tags', ['dart']);

      final addedNew = await service.addToStringList('tags', 'flutter');
      expect(addedNew, isTrue);
      expect(service.getStringList('tags'), ['dart', 'flutter']);

      final addedExisting = await service.addToStringList('tags', 'dart');
      expect(addedExisting, isFalse);
      expect(service.getStringList('tags'), ['dart', 'flutter']);
    });

    test('removeFromStringList removes item', () async {
      await service.saveStringList('tags', ['dart', 'flutter']);

      final removed = await service.removeFromStringList('tags', 'dart');
      expect(removed, isTrue);
      expect(service.getStringList('tags'), ['flutter']);

      final removedMissing = await service.removeFromStringList('tags', 'vue');
      expect(removedMissing, isFalse);
    });

    test('updateOrAppendToStringList appends unique items only', () async {
      await service.saveStringList('fruits', ['apple', 'banana']);

      final updated = await service.updateOrAppendToStringList(
        'fruits',
        ['banana', 'orange', 'grape'],
      );
      expect(updated, isTrue);
      expect(
        service.getStringList('fruits'),
        ['apple', 'banana', 'orange', 'grape'],
      );
    });
  });

  group('Numeric & Boolean Helpers', () {
    test('incrementOrInitInt increments existing value or inits', () async {
      final val1 = await service.incrementOrInitInt('counter', incrementBy: 5);
      expect(val1, 5);

      final val2 = await service.incrementOrInitInt('counter', incrementBy: 2);
      expect(val2, 7);
      expect(service.getInt('counter'), 7);
    });

    test('decrementInt decrements value', () async {
      await service.saveInt('score', 10);
      final dec = await service.decrementInt('score', decrementBy: 3);
      expect(dec, 7);
      expect(service.getInt('score'), 7);
    });

    test('toggleBool toggles flag', () async {
      expect(service.getBool('mode'), isNull);

      final val1 = await service.toggleBool('mode');
      expect(val1, isTrue);

      final val2 = await service.toggleBool('mode');
      expect(val2, isFalse);
    });

    test('batchIncrementInts updates multiple counters', () async {
      await service.saveInt('a', 10);
      await service.saveInt('b', 20);

      await service.batchIncrementInts({'a': 2, 'b': 5, 'c': 1});

      expect(service.getInt('a'), 12);
      expect(service.getInt('b'), 25);
      expect(service.getInt('c'), 1);
    });
  });

  group('Bulk Operations', () {
    test('saveBulk, getBulk, and removeBulk', () async {
      await service.saveBulk({
        'str': 'hello',
        'num': 99,
        'flag': true,
        'rate': 2.5,
        'list': ['x', 'y'],
      });

      final bulk = service.getBulk(['str', 'num', 'flag', 'missing']);
      expect(bulk['str'], 'hello');
      expect(bulk['num'], 99);
      expect(bulk['flag'], true);
      expect(bulk['missing'], isNull);

      await service.removeBulk(['str', 'num']);
      expect(service.containsKey('str'), isFalse);
      expect(service.containsKey('num'), isFalse);
      expect(service.containsKey('flag'), isTrue);
    });

    test('resetToDefaults sets specified keys', () async {
      await service.saveString('theme', 'custom');
      await service.resetToDefaults({'theme': 'light', 'volume': 80});

      expect(service.getString('theme'), 'light');
      expect(service.getInt('volume'), 80);
    });

    test('retrieveAndRemove retrieves data and deletes keys', () async {
      await service.saveString('token', 'secret_token');
      await service.saveInt('userId', 101);

      final retrieved = await service.retrieveAndRemove(['token', 'userId']);
      expect(retrieved['token'], 'secret_token');
      expect(retrieved['userId'], 101);

      expect(service.containsKey('token'), isFalse);
      expect(service.containsKey('userId'), isFalse);
    });
  });

  group('Inspection & Query Operations', () {
    test('getAll, getKeys, getKeysByPrefix, and getItemCount', () async {
      await service.saveString('app_name', 'MyApp');
      await service.saveString('app_version', '1.0.0');
      await service.saveString('user_id', '42');

      expect(service.getItemCount(), 3);
      expect(service.getKeys().length, 3);

      final appKeys = service.getKeysByPrefix('app_');
      expect(appKeys, containsAll({'app_name', 'app_version'}));
      expect(appKeys.contains('user_id'), isFalse);

      final all = service.getAll();
      expect(all['app_name'], 'MyApp');
      expect(all['user_id'], '42');
    });

    test('getValue<T> returns type cast or null', () async {
      await service.saveString('text', 'hello');
      await service.saveInt('number', 123);

      expect(service.getValue<String>('text'), 'hello');
      expect(service.getValue<int>('text'), isNull);
      expect(service.getValue<int>('number'), 123);
      expect(service.getValue<String>('missing'), isNull);
    });

    test('clear empties all preferences', () async {
      await service.saveString('k1', 'v1');
      await service.saveString('k2', 'v2');
      expect(service.getItemCount(), 2);

      final cleared = await service.clear();
      expect(cleared, isTrue);
      expect(service.getItemCount(), 0);
    });
  });
}
