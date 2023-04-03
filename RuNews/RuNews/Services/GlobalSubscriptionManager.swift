import RxSwift

protocol GlobalSubscriptionManagerProtocol {
    var updatedPeriodObservable: Observable<Void> { get }
    var updatedSourceObservable: Observable<Void> { get }
    func didUpdateSourceList()
    func didUpdateRefreshPeriod()
}

final class GlobalSubscriptionManager: GlobalSubscriptionManagerProtocol {
    
    static let shared = GlobalSubscriptionManager()
    private let updatedPeriodSubject = PublishSubject<Void>()
    private let updatedSourceSubject = PublishSubject<Void>()
    var updatedPeriodObservable: Observable<Void> {
        updatedPeriodSubject.asObservable()
    }
    var updatedSourceObservable: Observable<Void> {
        updatedSourceSubject.asObservable()
    }
    
    private init() {}

    func didUpdateSourceList() {
        updatedSourceSubject.onNext(())
    }

    func didUpdateRefreshPeriod() {
        updatedPeriodSubject.onNext(())
    }

}
