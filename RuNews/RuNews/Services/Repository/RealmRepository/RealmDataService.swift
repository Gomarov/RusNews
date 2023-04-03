import RealmSwift

protocol RealmDataServiceProtocol {
    func getObjects<T: Object>(type: T.Type) -> [T]
    func getObjects<T: Object>(type: T.Type, filter: String) -> [T]
    func update<T: Object>(object: T)
}

class RealmDataService: RealmDataServiceProtocol {

    var realm: Realm?

    init() {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(
                deleteRealmIfMigrationNeeded: true
            )
            realm = try Realm()
            print("Data service Realm path \(realm?.configuration.fileURL?.absoluteString ?? "not found")")
        } catch {
            print("Realm needs migration")
        }
    }

    func getObjects<T: Object>(type: T.Type) -> [T] {
        guard let objects = realm?.objects(T.self), !objects.isEmpty else {
            return []
        }
        return Array(objects)
    }

    func getObjects<T: Object>(type: T.Type, filter: String) -> [T] {
        guard let results = realm?.objects(T.self).filter(filter) else {
            return []
        }
        return Array(results)
    }

    func update<T: Object>(object: T) {
        try? realm?.write {
            realm?.add(object, update: .all)
        }
    }
}

