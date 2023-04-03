import Foundation

final class PeriodViewModel {

    let currentValue: Int
    let text: String

    init(with currentValue: Int) {
        self.currentValue = currentValue
        self.text = "\(currentValue)"
    }
}
