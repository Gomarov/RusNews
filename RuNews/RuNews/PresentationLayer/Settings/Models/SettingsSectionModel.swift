import Foundation

enum SettingsCellType {
    case source
    case period
}

struct SettingsSectionModel {
    let type: SettingsCellType
    let header: String?
    let models: [Any]
}
