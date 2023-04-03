import Foundation

final class FeedPresenter {
    weak var view: FeedViewInput?
    private let interactor: FeedInteractorInput
    private let router: FeedRouterProtocol

    init(interactor: FeedInteractorInput, router: FeedRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    private func processNetworkError(_ error: Error) {
        guard let error = error as? ServerError else {
            view?.showErrorView(with: "cached_news".localized)
            return
        }
        if case let .invalidResponse(model) = error {
            if model.code == ServerError.parametersMissingCode {
                view?.showErrorView(with: "no_sources".localized)
            }
        }
    }
}

// MARK: - FeedViewOutput
extension FeedPresenter: FeedViewOutput {

    func didSelectNews(with id: String) {
        interactor.setNewsWasRead(with: id)
    }
    
    func viewDidLoad() {
        view?.startLoadingAnimation()
        interactor.getNews()
    }
    
    func showSettingsView() {
        router.showSettings()
    }
}

// MARK: - FeedInteractorOutput
extension FeedPresenter: FeedInteractorOutput {
    func networkErrorFetched(_ news: [News], error: Error) {
        processNetworkError(error)
        view?.stopLoadingAnimation()
        view?.setupTable(with: news.map { NewsViewModel(with: $0) })
    }
    
    func newsFetched(_ news: [News]) {
        view?.hideErrorView()
        view?.stopLoadingAnimation()
        view?.setupTable(with: news.map { NewsViewModel(with: $0) })
    }
}
