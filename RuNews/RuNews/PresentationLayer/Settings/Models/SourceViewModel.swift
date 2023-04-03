import Foundation

final class SourceViewModel {

    let source: Source
    let title: String
    var isSelected = false

    init(with source: Source, isSelected: Bool) {
        self.source = source
        title = source.rawValue
        self.isSelected = isSelected
    }
}
