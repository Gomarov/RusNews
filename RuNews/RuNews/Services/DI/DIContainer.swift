import Dip
import Foundation

final class DIContainer {

    static let instance = DependencyContainer {
        unowned let container = $0

        container.register(.singleton) {
            NetworkService(serializationService: SerializationService()) as NetworkServiceProtocol
        }
        container.register {
            SettingsService() as SettingsServiceProtocol
        }
        container.register {
            FeedService(with: try container.resolve(),
                        newsFeedRepository: try container.resolve()) as FeedServiceProtocol
        }
        container.register {
            DateConverter() as DateConverterProtocol
        }

        container.register(.singleton) {
            GlobalSubscriptionManager.shared as GlobalSubscriptionManagerProtocol
        }

        // MARK: - Repository
        container.register {
            RealmDataService() as RealmDataServiceProtocol
        }
        container.register {
            RealmRepository<News, NewsRealm>(
                dataService: try container.resolve() as RealmDataServiceProtocol
            ).asAnyRepository() as AnyRepository<News>
        }

    }

}

extension DIContainer {

    static var dateConverter: DateConverterProtocol {
        guard let dateConverter = try? instance.resolve() as DateConverterProtocol else {
            fatalError()
        }
        return dateConverter
    }

    static var feedService: FeedServiceProtocol {
        guard let feedService = try? instance.resolve() as FeedServiceProtocol else {
            fatalError()
        }
        return feedService
    }

    static var settingsService: SettingsServiceProtocol {
        guard let settingsService = try? instance.resolve() as SettingsServiceProtocol else {
            fatalError()
        }
        return settingsService
    }

    static var subscriptionManager: GlobalSubscriptionManagerProtocol {
        guard let subscriptionManager = try? instance.resolve() as GlobalSubscriptionManagerProtocol else {
            fatalError()
        }
        return subscriptionManager
    }

}
