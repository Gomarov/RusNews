import XCTest
@testable import RuNews

class UserDefaultsTests: XCTestCase {
    
    let refreshPeriodKey = UserDefaultsKeys.refreshPeriod.rawValue
    let usedSourcesKey = UserDefaultsKeys.usedSources.rawValue
    
    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: refreshPeriodKey)
        UserDefaults.standard.removeObject(forKey: usedSourcesKey)
    }
    
    func testUserDefaultWithSomeValue() throws {
        let userDefault = UserDefault(UserDefaultsKeys.refreshPeriod.rawValue, defaultValue: 60)
        XCTAssertEqual(userDefault.wrappedValue, 60)
    }
    
    func testUserDefaultWithDifferentValues() throws {
        let userDefault1 = UserDefault(UserDefaultsKeys.refreshPeriod.rawValue, defaultValue: 60)
        let userDefault2 = UserDefault(UserDefaultsKeys.refreshPeriod.rawValue, defaultValue: 120)
        XCTAssertNotEqual(userDefault1.wrappedValue, userDefault2.wrappedValue)
    }

    func testUserDefaultSetAndGetValue() throws {
        var userDefault = UserDefault(UserDefaultsKeys.usedSources.rawValue, defaultValue: ["news"])
        userDefault.wrappedValue.append("sports")
        XCTAssertEqual(userDefault.wrappedValue, ["news", "sports"])
    }

    func testUserDefaultResetToDefaultValue() throws {
        var userDefault = UserDefault(UserDefaultsKeys.refreshPeriod.rawValue, defaultValue: 60)
        userDefault.wrappedValue = 30
        userDefault.wrappedValue = userDefault.defaultValue
        XCTAssertEqual(userDefault.wrappedValue, 60)
    }
    
    func testUserDefaultInitialization() throws {
        let refreshPeriodDefault = UserDefault(refreshPeriodKey, defaultValue: 30)
        let usedSourcesDefault = UserDefault(usedSourcesKey, defaultValue: ["news"])
        
        XCTAssertEqual(refreshPeriodDefault.key, refreshPeriodKey)
        XCTAssertEqual(refreshPeriodDefault.defaultValue, 30)
        XCTAssertEqual(usedSourcesDefault.key, usedSourcesKey)
        XCTAssertEqual(usedSourcesDefault.defaultValue, ["news"])
    }
    
    func testUserDefaultGetAndSet() throws {
        var refreshPeriodDefault = UserDefault(refreshPeriodKey, defaultValue: 30)
        var usedSourcesDefault = UserDefault(usedSourcesKey, defaultValue: ["news"])
        
        refreshPeriodDefault.wrappedValue = 60
        usedSourcesDefault.wrappedValue = ["news", "sports"]
        
        XCTAssertEqual(refreshPeriodDefault.wrappedValue, 60)
        XCTAssertEqual(usedSourcesDefault.wrappedValue, ["news", "sports"])
    }
    
    func testPerformanceExample() throws {
        var userDefault = UserDefault(UserDefaultsKeys.refreshPeriod.rawValue, defaultValue: 60)
        measure {
            userDefault.wrappedValue = 30
            XCTAssertEqual(userDefault.wrappedValue, 30)
        }
    }
}


