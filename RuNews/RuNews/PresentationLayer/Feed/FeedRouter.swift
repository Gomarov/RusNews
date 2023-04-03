import UIKit

protocol FeedRouterProtocol: AnyObject {
    func showSettings()
}

final class FeedRouter: FeedRouterProtocol {
    weak var view: UIViewController?
    func showSettings() {
        let settingsController = SettingsBuilder.build()
        let navigationController = UINavigationController(rootViewController: settingsController)
        view?.present(navigationController, animated: true)
    }
}
