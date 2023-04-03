import Foundation

protocol Repository {
    associatedtype Model: Codable
    func getAllData() -> [Model]
    func getDataWith(filter: String) -> [Model]
    func save(_ model: Model)
    func save(_ models: [Model])
}

class AnyRepository<Model: Codable>: Repository {

    private let getAllDataClosure: () -> [Model]
    private let getDataWithFilterClosure: (String) -> [Model]
    private let saveModelClosure: (Model) -> Void
    private let saveModelsClosure: ([Model]) -> Void

    public init<Concrete: Repository>(_ concrete: Concrete) where Concrete.Model == Model {
        getAllDataClosure = { concrete.getAllData() }
        getDataWithFilterClosure = { concrete.getDataWith(filter: $0) }
        saveModelClosure = { concrete.save($0) }
        saveModelsClosure = { concrete.save($0) }
    }

    // MARK: - Repository
    func getAllData() -> [Model] {
        return getAllDataClosure()
    }

    func getDataWith(filter: String) -> [Model] {
        return getDataWithFilterClosure(filter)
    }

    func save(_ model: Model) {
        return saveModelClosure(model)
    }

    func save(_ models: [Model]) {
        return saveModelsClosure(models)
    }

}

extension Repository {

    func asAnyRepository() -> AnyRepository<Model> {
        return AnyRepository(self)
    }

}
