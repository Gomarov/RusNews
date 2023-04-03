import RealmSwift

class NewsRealm: Object, Codable {

    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var publishedAt = ""
    @objc dynamic var source: PlainSourceRealm?
    @objc dynamic var urlToImage = ""
    @objc dynamic var url = ""
    @objc dynamic var wasSeen = false

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case desc = "description"
        case publishedAt
        case source
        case urlToImage
        case url
        case wasSeen
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        desc = try container.decode(String.self, forKey: .desc)
        publishedAt = try container.decode(String.self, forKey: .publishedAt)
        urlToImage = try container.decode(String.self, forKey: .urlToImage)
        url = try container.decode(String.self, forKey: .url)
        source = try container.decode(PlainSourceRealm.self, forKey: .source)
        wasSeen = try container.decode(Bool.self, forKey: .wasSeen)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
