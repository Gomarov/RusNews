import Foundation

struct NewsViewModel {
    let id: String
    let title: String
    let source: String
    let imageURL: String
    let newsURL: String
    let description: String
    let date: String?
    var wasSeen: Bool
    var isCollapsed = true

    init(with news: News) {
        let dateConverter = DIContainer.dateConverter
        id = news.id
        title = news.title
        source = news.source.name
        description = news.description
        imageURL = news.urlToImage
        newsURL = news.url
        wasSeen = news.wasSeen
        date = dateConverter.getShortDateAndTime(fromString: news.publishedAt)
    }
}
