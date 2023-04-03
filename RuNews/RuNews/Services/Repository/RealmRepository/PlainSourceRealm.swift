import RealmSwift

class PlainSourceRealm: Object, Codable {

    @objc dynamic var id = ""
    @objc dynamic var name = ""

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
