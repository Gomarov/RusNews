import Foundation

protocol FeedBuilderProtocol: AnyObject {
    static func build() -> FeedViewController
}

final class FeedBuilder: FeedBuilderProtocol {
    static func build() -> FeedViewController {
        let router = FeedRouter()
        let interactor = FeedInteractor(with: DIContainer.feedService,
                                        settingsService: DIContainer.settingsService,
                                        subscriptionManager: DIContainer.subscriptionManager)
        let presenter = FeedPresenter(interactor: interactor, router: router)
        let viewController = FeedViewController(output: presenter)

        router.view = viewController
        presenter.view = viewController
        interactor.output = presenter

        return viewController
    }
}
