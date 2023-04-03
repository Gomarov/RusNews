import XCTest
@testable import RuNews

class SettingsServiceTests: XCTestCase {
    
    var settingsService: SettingsService!
    
    override func setUpWithError() throws {
        settingsService = SettingsService()
    }
    
    override func tearDownWithError() throws {
        settingsService = nil
    }
    
    func testExample() throws {
        let sources = settingsService.getSources()
        XCTAssertEqual(sources.count, Source.allCases.count)
        
        settingsService.updatePeriod(with: 60)
        XCTAssertEqual(settingsService.getPeriod(), 60)
    }
    
    func testPerformanceExample() throws {
        self.measure {
        }
    }
    
}
