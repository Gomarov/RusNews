import XCTest
@testable import RuNews

class DateConverterTests: XCTestCase {

    var dateConverter: DateConverter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        dateConverter = DateConverter()
    }

    override func tearDownWithError() throws {
        dateConverter = nil
        try super.tearDownWithError()
    }

    func testGetTime() {
         let dateString = "2023-04-02T16:30:00Z"
         let expectedOutput = "19:30"
         let output = dateConverter.getTime(fromString: dateString)
         XCTAssertEqual(output, expectedOutput)
     }

    func testGetShortDate() {
        let dateString = "2023-04-02T16:30:00Z"
        let expectedOutput = "02 апр."
        let output = dateConverter.getShortDate(fromString: dateString)
        XCTAssertEqual(output, expectedOutput)
    }
    
    func testGetShortDateAndTime() {
        let dateString = "2023-04-02T16:30:00Z"
        let expectedOutput = "02 апр., 19:30"
        let output = dateConverter.getShortDateAndTime(fromString: dateString)
        XCTAssertEqual(output, expectedOutput)
    }

    func testGetShortDateFromInvalidString() {
        let dateString = "invalid date string"
        let output = dateConverter.getShortDate(fromString: dateString)
        XCTAssertNil(output)
    }

    func testPerformanceExample() {
        let dateString = "2023-04-02T16:30:00Z"
        measure {
            _ = dateConverter.getShortDateAndTime(fromString: dateString)
        }
    }
}









