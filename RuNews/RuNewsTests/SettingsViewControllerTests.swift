import XCTest
@testable import RuNews

class SettingsViewControllerTests: XCTestCase {
    
    var svc: SettingsViewController!
    var mockOutput: MockSettingsViewOutput!
    
    override func setUpWithError() throws {
        mockOutput = MockSettingsViewOutput()
        svc = SettingsViewController(output: mockOutput)
    }
    
    override func tearDownWithError() throws {
        mockOutput = nil
        svc = nil
    }
    
    func testTitle() throws {
        // Given
        let expectedTitle = "settings".localized
        
        // When
        svc.viewDidLoad()
        
        // Then
        XCTAssertEqual(svc.title, expectedTitle)
    }
    
    func testCloseSettingsView() throws {
        // Given
        let mockVC = UIViewController()
        mockVC.present(svc, animated: true, completion: nil)
        
        // When
        svc.closeSettingsView()
        
        // Then
        XCTAssertFalse(svc.isViewLoaded)
    }
}


class MockSettingsViewOutput: SettingsViewOutput {
    func viewDidLoad() {}
    func didSelect(_ source: RuNews.Source) {}
    func didChangeSlider(_ value: Float) {}
}
