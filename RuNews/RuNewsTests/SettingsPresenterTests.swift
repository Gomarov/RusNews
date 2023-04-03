import XCTest
@testable import RuNews

class SettingsPresenterTests: XCTestCase {
    
    var presenter: SettingsPresenter!
    var interactor: MockSettingsInteractor!
    var view: MockSettingsView!

    override func setUpWithError() throws {
        interactor = MockSettingsInteractor()
        presenter = SettingsPresenter(interactor: interactor)
        view = MockSettingsView()
        presenter.view = view
    }

    override func tearDownWithError() throws {
        presenter = nil
        interactor = nil
        view = nil
    }

    func testDidChangeSlider() throws {
        presenter.didChangeSlider(20)
        XCTAssertEqual(interactor.updatedPeriod, 20)
        XCTAssertTrue(view.setupTableViewCalled)
    }

    func testDidSelect() throws {
        let selectedSource = Source.rbc
        presenter.didSelect(selectedSource)
        XCTAssertEqual(interactor.updatedSource, selectedSource)
    }

    func testViewDidLoad() throws {
        presenter.viewDidLoad()
        XCTAssertTrue(view.setupTableViewCalled)
    }
}

class MockSettingsInteractor: SettingsInteractorInput {
    var sourcesReturnValue: [Source] = []
    var periodReturnValue: Int = 0
    var updatedSource: Source?
    var updatedPeriod: Int?
    func getSources() -> [Source] {
        return sourcesReturnValue
    }
    func getPeriod() -> Int {
        return periodReturnValue
    }
    func update(_ source: Source) {
        updatedSource = source
    }
    func updatePeriod(with value: Int) {
        updatedPeriod = value
    }
}

class MockSettingsView: SettingsViewInput {
    var setupTableViewCalled = false
    func setupTableView(with sections: [SettingsSectionModel]) {
        setupTableViewCalled = true
    }
}
