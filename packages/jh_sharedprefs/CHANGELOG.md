## 1.0.0

* Initial stable release of `jh_sharedprefs`.
* Convenient singleton and instance wrapper around `shared_preferences`.
* Support for all basic types (`String`, `int`, `double`, `bool`, `List<String>`).
* Extended data types support: ISO-8601 `DateTime` and structured `JSON` maps.
* List operations: `addToStringList`, `removeFromStringList`, `updateOrAppendToStringList`.
* Number and boolean helpers: `incrementOrInitInt`, `decrementInt`, `toggleBool`, `batchIncrementInts`.
* Bulk utilities: `saveBulk`, `getBulk`, `removeBulk`, `resetToDefaults`, `retrieveAndRemove`.
* Key inspection, prefix queries, `getItemCount`, and `reload`.
* Full test suite and example application.
