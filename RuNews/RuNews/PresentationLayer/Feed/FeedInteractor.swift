import RxSwift

protocol FeedInteractorInput {
    func setNewsWasRead(with id: String)
    func getNews()
}
protocol FeedInteractorOutput: AnyObject {
    func newsFetched(_ news: [News])
    func networkErrorFetched(_ news: [News], error: Error)
}

final class FeedInteractor {
    weak var output: FeedInteractorOutput?
    private let feedService: FeedServiceProtocol
    private let settingsService: SettingsServiceProtocol
    private let subscriptionManager: GlobalSubscriptionManagerProtocol
    private let disposeBag = DisposeBag()
    private var timerObservable: Disposable?

    init(with feedService: FeedServiceProtocol,
         settingsService: SettingsServiceProtocol,
         subscriptionManager: GlobalSubscriptionManagerProtocol) {
        self.feedService = feedService
        self.subscriptionManager = subscriptionManager
        self.settingsService = settingsService
        restartTimer(with: settingsService.getPeriod())
        bindObservables()
    }

    private func bindObservables() {
        subscriptionManager.updatedSourceObservable.subscribe(onNext: { [unowned self] in
            self.getNewsFeed()
        }).disposed(by: disposeBag)

        subscriptionManager.updatedPeriodObservable.subscribe(onNext: { [unowned self] in
            self.restartTimer(with: settingsService.getPeriod())
        }).disposed(by: disposeBag)
    }
    
    private func getNewsFeed() {
        let currentSources = settingsService.getSources()
        feedService.getNewsFeed(for: settingsService.getSources())
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [unowned self] in
                let seenNews = self.feedService.getAllSeenNews()
                var networkNews = self.convertNetwork($0.articles)
                seenNews.forEach { seen in
                    if let index = networkNews.firstIndex(where: { $0.id == seen.id }) {
                        networkNews[index].wasSeen = true
                    }
                }
                self.feedService.save(networkNews)
                self.output?.newsFetched(networkNews)
            }, onError: { [unowned self] in
                self.output?.networkErrorFetched(self.feedService.getNewsFeedFromCache(with: currentSources), error: $0)
            }).disposed(by: disposeBag)
    }

    private func restartTimer(with period: Int) {
        if let timer = timerObservable {
            timer.dispose()
        }
        if period != 0 {
            let intervalInMinutes = period * 60
            timerObservable = Observable<Int>
                .interval(RxTimeInterval.seconds(intervalInMinutes), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    self?.getNewsFeed()
                })
        }
    }
    
    private func convertNetwork(_ models: [NewsNetwork]) -> [News] {
        return models.map { $0.plainModel }
    }

}

// MARK: - FeedInteractorInput
extension FeedInteractor: FeedInteractorInput {

    func getNews() {
        getNewsFeed()
    }

    func setNewsWasRead(with id: String) {
        feedService.setNewsWasRead(with: id)
    }
}
