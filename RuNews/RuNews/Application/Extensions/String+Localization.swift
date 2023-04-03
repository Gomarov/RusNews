import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var realmFilterFromId: String {
        return "id == '\(self)'"
    }
}
