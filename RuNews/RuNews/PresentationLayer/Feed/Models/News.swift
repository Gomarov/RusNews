import Foundation

struct NewsNetwork: Codable {
    let title: String
    let description: String
    let publishedAt: String
    let source: PlainSource
    let urlToImage: String
    let url: String
}

extension NewsNetwork {
    var plainModel: News {
        return News(id: "\(publishedAt + source.id)",
                    title: title,
                    description: description,
                    publishedAt: publishedAt,
                    source: source,
                    urlToImage: urlToImage,
                    url: url)
    }
}

struct News: Codable {
    let id: String
    let title: String
    let description: String
    let publishedAt: String
    let source: PlainSource
    let urlToImage: String
    let url: String
    var wasSeen: Bool = false
}

struct NewsResponse: Codable {
    let articles: [NewsNetwork]
}

struct PlainSource: Codable {
    let id: String
    let name: String
}
