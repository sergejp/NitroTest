//
//  NitroMacTest_sergejpTests.swift
//  NitroMacTest-sergejpTests
//
//  Created by Sergej Pershaj on 21/10/2022.
//

import XCTest
@testable import NitroMacTest_sergejp

class NitroMacTest_sergejpTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFindRectIntersectionTwo() throws {
        let finder = RectIntersectionFinder()
        let rects = [
            Rect(id: 1, x: 100, y: 100, w: 100, h: 100),
            Rect(id: 2, x: 175, y: 175, w: 100, h: 100)
        ]
        let intersections = finder.find(in: rects)
        let case1 = RectIntersection(area: Area(x: 175, y: 175, w: 25, h: 25), rects: [rects[0], rects[1]])
        XCTAssertTrue(intersections.contains(case1), "No intersection found between \(case1.rects)")
    }
    
    func testNoIntersection() throws {
        let finder = RectIntersectionFinder()
        let rects = [
            Rect(id: 1, x: 100, y: 100, w: 100, h: 100),
            Rect(id: 2, x: 250, y: 100, w: 100, h: 100)
        ]
        let intersections = finder.find(in: rects)
        XCTAssertTrue(intersections.isEmpty, "There should be no intersection between \(rects)")
    }
    
    func testIntersectionWithZeroRect() throws {
        let finder = RectIntersectionFinder()
        let rects = [
            Rect(id: 1, x: 100, y: 100, w: 100, h: 100),
            Rect(id: 2, x: 110, y: 110, w: 0, h: 100)
        ]
        let intersections = finder.find(in: rects)
        XCTAssertTrue(intersections.isEmpty, "There should be no intersection between \(rects)")
    }
    
    func testIntersectionWithWidth1() throws {
        let finder = RectIntersectionFinder()
        let rects = [
            Rect(id: 1, x: 100, y: 100, w: 100, h: 100),
            Rect(id: 2, x: 110, y: 110, w: 1, h: 100)
        ]
        let intersections = finder.find(in: rects)
        let case1 = RectIntersection(area: Area(x: 110, y: 110, w: 1, h: 90), rects: [rects[0], rects[1]])
        XCTAssertTrue(intersections.contains(case1), "No intersection found between \(case1.rects)")
    }

    func testIntersectionWithNegCoords() throws {
        let finder = RectIntersectionFinder()
        let rects = [
            Rect(id: 1, x: -125, y: 100, w: 100, h: 100),
            Rect(id: 2, x: -100, y: 110, w: 1, h: 100)
        ]
        let intersections = finder.find(in: rects)
        let case1 = RectIntersection(area: Area(x: -100, y: 110, w: 1, h: 90), rects: [rects[0], rects[1]])
        XCTAssertTrue(intersections.contains(case1), "No intersection found between \(case1.rects)")
    }
    
    func testIntersectionWithSameArea() throws {
        let finder = RectIntersectionFinder()
        let rects = [
            Rect(id: 1, x: 1, y: 100, w: 100, h: 100),
            Rect(id: 2, x: 1, y: 100, w: 100, h: 100)
        ]
        let intersections = finder.find(in: rects)
        let case1 = RectIntersection(area: Area(x: 1, y: 100, w: 100, h: 100), rects: [rects[0], rects[1]])
        XCTAssertTrue(intersections.contains(case1), "No intersection found between \(case1.rects)")
    }
    
    func testForSpecExample() throws {
        let finder = RectIntersectionFinder()
        let rects = [
            Rect(id: 1, x: 100, y: 100, w: 250, h: 80),
            Rect(id: 2, x: 120, y: 200, w: 250, h: 150),
            Rect(id: 3, x: 140, y: 160, w: 250, h: 100),
            Rect(id: 4, x: 160, y: 140, w: 350, h: 190)
        ]
        
        let intersections = finder.find(in: rects)
        print("Intersections: \(intersections.count) \n\(intersections)")
        
        // check cases from the spec
        // Between rectangle 1 and 3 at (140,160), w=210, h=20.
        let case1 = RectIntersection(area: Area(x: 140, y: 160, w: 210, h: 20), rects: [rects[0], rects[2]])
        XCTAssertTrue(intersections.contains(case1), "No intersection found between \(case1.rects)")
        
        // Between rectangle 1 and 4 at (160,140), w=190, h=40.
        let case2 = RectIntersection(area: Area(x: 160, y: 140, w: 190, h: 40), rects: [rects[0], rects[3]])
        XCTAssertTrue(intersections.contains(case2), "No intersection found between \(case2.rects)")
        
        // Between rectangle 2 and 3 at (140,200), w=230, h=60.
        let case3 = RectIntersection(area: Area(x: 140, y: 200, w: 230, h: 60), rects: [rects[1], rects[2]])
        XCTAssertTrue(intersections.contains(case3), "No intersection found between \(case3.rects)")
        
        // Between rectangle 2 and 4 at (160,200), w=210, h=130.
        let case4 = RectIntersection(area: Area(x: 160, y: 200, w: 210, h: 130), rects: [rects[1], rects[3]])
        XCTAssertTrue(intersections.contains(case4), "No intersection found between \(case4.rects)")
        
        // Between rectangle 3 and 4 at (160,160), w=230, h=100.
        let case5 = RectIntersection(area: Area(x: 160, y: 160, w: 230, h: 100), rects: [rects[2], rects[3]])
        XCTAssertTrue(intersections.contains(case5), "No intersection found between \(case5.rects)")
        
        // Between rectangle 1, 3 and 4 at (160,160), w=190, h=20.
        let case6 = RectIntersection(area: Area(x: 160, y: 160, w: 190, h: 20), rects: [rects[0], rects[2], rects[3]])
        XCTAssertTrue(intersections.contains(case6), "No intersection found between \(case6.rects)")
        
        // Between rectangle 2, 3 and 4 at (160,200), w=210, h=60.
        let case7 = RectIntersection(area: Area(x: 160, y: 200, w: 210, h: 60), rects: [rects[1], rects[2], rects[3]])
        XCTAssertTrue(intersections.contains(case7), "No intersection found between \(case7.rects)")
        
        let correctIntersections: Set<RectIntersection> = [
            case1, case2, case3, case4, case5, case6, case7
        ]
        // make sure computed intersections not only contain all the correct cases
        // but also that it doesn't contain any additional cases (which would be incorrect)
        XCTAssertEqual(intersections,
                       correctIntersections,
                       "Computed intersections do not correspond to the list of correct intersections defined by hand")
    }
    
    func testIntersectingRects5() throws {
        let finder = RectIntersectionFinder()
        let rects = [
            Rect(id: 1, x: 100, y: 100, w: 100, h: 100),
            Rect(id: 2, x: 110, y: 110, w: 100, h: 100),
            Rect(id: 3, x: 120, y: 120, w: 100, h: 100),
            Rect(id: 4, x: 130, y: 130, w: 100, h: 100),
            Rect(id: 5, x: 140, y: 140, w: 100, h: 100),
        ]
        let intersections = finder.find(in: rects)
        print("Intersections for 5 rects: \(intersections.count)")
        
        // caseIds12 means intersection between rects with ID=1 and ID=2
        // 1-2, 1-3, 2-3, 1-2-3 covers intersections between 3 first rects
        let caseIds12 = RectIntersection(area: Area(x: 110, y: 110, w: 90, h: 90), rects: [rects[0], rects[1]])
        XCTAssertTrue(intersections.contains(caseIds12), "No intersection found between \(caseIds12.rects)")
        
        let caseIds13 = RectIntersection(area: Area(x: 120, y: 120, w: 80, h: 80), rects: [rects[0], rects[2]])
        XCTAssertTrue(intersections.contains(caseIds13), "No intersection found between \(caseIds13.rects)")
        
        let caseIds23 = RectIntersection(area: Area(x: 120, y: 120, w: 90, h: 90), rects: [rects[1], rects[2]])
        XCTAssertTrue(intersections.contains(caseIds23), "No intersection found between \(caseIds23.rects)")
        
        let caseIds123 = RectIntersection(area: Area(x: 120, y: 120, w: 80, h: 80), rects: [rects[0], rects[1], rects[2]])
        XCTAssertTrue(intersections.contains(caseIds123), "No intersection found between \(caseIds123.rects)")
        
        // Add cases for ids 1-4, 2-4, 3-4, 1-2-4, 1-3-4, 2-3-4, 1-2-3-4
        let caseIds14 = RectIntersection(area: Area(x: 130, y: 130, w: 70, h: 70), rects: [rects[0], rects[3]])
        XCTAssertTrue(intersections.contains(caseIds14), "No intersection found between \(caseIds14.rects)")
        
        let caseIds24 = RectIntersection(area: Area(x: 130, y: 130, w: 80, h: 80), rects: [rects[1], rects[3]])
        XCTAssertTrue(intersections.contains(caseIds24), "No intersection found between \(caseIds24.rects)")
        
        let caseIds34 = RectIntersection(area: Area(x: 130, y: 130, w: 90, h: 90), rects: [rects[2], rects[3]])
        XCTAssertTrue(intersections.contains(caseIds34), "No intersection found between \(caseIds34.rects)")
        
        let caseIds124 = RectIntersection(area: Area(x: 130, y: 130, w: 70, h: 70), rects: [rects[0], rects[1], rects[3]])
        XCTAssertTrue(intersections.contains(caseIds124), "No intersection found between \(caseIds124.rects)")
        
        let caseIds134 = RectIntersection(area: Area(x: 130, y: 130, w: 70, h: 70), rects: [rects[0], rects[2], rects[3]])
        XCTAssertTrue(intersections.contains(caseIds134), "No intersection found between \(caseIds134.rects)")
        
        let caseIds234 = RectIntersection(area: Area(x: 130, y: 130, w: 80, h: 80), rects: [rects[1], rects[2], rects[3]])
        XCTAssertTrue(intersections.contains(caseIds234), "No intersection found between \(caseIds234.rects)")
        
        let caseIds1234 = RectIntersection(area: Area(x: 130, y: 130, w: 70, h: 70), rects: [rects[0], rects[1], rects[2], rects[3]])
        XCTAssertTrue(intersections.contains(caseIds1234), "No intersection found between \(caseIds1234.rects)")
        
        // Add cases for:
        // 1-5, 2-5, 3-5, 4-5
        // 1-2-5, 1-3-5, 1-4-5, 2-3-5, 2-4-5, 3-4-5
        // 1-2-3-5, 1-2-4-5, 1-3-4-5, 2-3-4-5
        // 1-2-3-4-5
        /*
         let rects = [
             Rect(id: 1, x: 100, y: 100, w: 100, h: 100),
             Rect(id: 2, x: 110, y: 110, w: 100, h: 100),
             Rect(id: 3, x: 120, y: 120, w: 100, h: 100),
             Rect(id: 4, x: 130, y: 130, w: 100, h: 100),
             Rect(id: 5, x: 140, y: 140, w: 100, h: 100),
         ]
         */
        
        // 1-5, 2-5, 3-5, 4-5
        let caseIds15 = RectIntersection(area: Area(x: 140, y: 140, w: 60, h: 60), rects: [rects[0], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds15), "No intersection found between \(caseIds15.rects)")
        
        let caseIds25 = RectIntersection(area: Area(x: 140, y: 140, w: 70, h: 70), rects: [rects[1], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds25), "No intersection found between \(caseIds25.rects)")
        
        let caseIds35 = RectIntersection(area: Area(x: 140, y: 140, w: 80, h: 80), rects: [rects[2], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds35), "No intersection found between \(caseIds35.rects)")
        
        let caseIds45 = RectIntersection(area: Area(x: 140, y: 140, w: 90, h: 90), rects: [rects[3], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds45), "No intersection found between \(caseIds45.rects)")
        
        // 1-2-5, 1-3-5, 1-4-5, 2-3-5, 2-4-5, 3-4-5
        let caseIds125 = RectIntersection(area: Area(x: 140, y: 140, w: 60, h: 60), rects: [rects[0], rects[1], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds125), "No intersection found between \(caseIds125.rects)")
        
        let caseIds135 = RectIntersection(area: Area(x: 140, y: 140, w: 60, h: 60), rects: [rects[0], rects[2], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds135), "No intersection found between \(caseIds135.rects)")
        
        let caseIds145 = RectIntersection(area: Area(x: 140, y: 140, w: 60, h: 60), rects: [rects[0], rects[3], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds145), "No intersection found between \(caseIds145.rects)")
        
        let caseIds235 = RectIntersection(area: Area(x: 140, y: 140, w: 70, h: 70), rects: [rects[1], rects[2], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds235), "No intersection found between \(caseIds235.rects)")
        
        let caseIds245 = RectIntersection(area: Area(x: 140, y: 140, w: 70, h: 70), rects: [rects[1], rects[3], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds245), "No intersection found between \(caseIds245.rects)")
        
        let caseIds345 = RectIntersection(area: Area(x: 140, y: 140, w: 80, h: 80), rects: [rects[2], rects[3], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds345), "No intersection found between \(caseIds345.rects)")
        
        // 1-2-3-5, 1-2-4-5, 1-3-4-5, 2-3-4-5
        let caseIds1235 = RectIntersection(area: Area(x: 140, y: 140, w: 60, h: 60), rects: [rects[0], rects[1], rects[2], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds1235), "No intersection found between \(caseIds1235.rects)")
        
        let caseIds1245 = RectIntersection(area: Area(x: 140, y: 140, w: 60, h: 60), rects: [rects[0], rects[1], rects[3], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds1245), "No intersection found between \(caseIds1245.rects)")
        
        let caseIds1345 = RectIntersection(area: Area(x: 140, y: 140, w: 60, h: 60), rects: [rects[0], rects[2], rects[3], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds1345), "No intersection found between \(caseIds1345.rects)")
        
        let caseIds2345 = RectIntersection(area: Area(x: 140, y: 140, w: 70, h: 70), rects: [rects[1], rects[2], rects[3], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds2345), "No intersection found between \(caseIds2345.rects)")
        
        let caseIds12345 = RectIntersection(area: Area(x: 140, y: 140, w: 60, h: 60), rects: [rects[0], rects[1], rects[2], rects[3], rects[4]])
        XCTAssertTrue(intersections.contains(caseIds12345), "No intersection found between \(caseIds12345.rects)")
        // 1-2-3-4-5
        
        let correctIntersections: Set<RectIntersection> = [
            //covers 3 rects
            caseIds12, caseIds13, caseIds23, caseIds123,
            // covers 4 rects
            caseIds14, caseIds24, caseIds34, caseIds124, caseIds134, caseIds234, caseIds1234,
            // covers all 5 rects
            caseIds15, caseIds25, caseIds35, caseIds45,
            caseIds125, caseIds135, caseIds145, caseIds235, caseIds245, caseIds345,
            caseIds1235, caseIds1245, caseIds1345, caseIds2345,
            caseIds12345
        ]
        // make sure computed intersections not only contain all the correct cases
        // but also that it doesn't contain any additional cases (which would be incorrect)
        XCTAssertEqual(intersections,
                       correctIntersections,
                       "Computed intersections do not correspond to the list of correct intersections defined by hand")
    }
    
    func testPerformanceIntersection() throws {
        let processor = RectIntersectionFinder()
        var rects = [Rect]()
        let rectNum = 10
        for i in 1...rectNum {
            let rect = Rect(id: UInt(i),
                            x: 10 + i,
                            y: 10 + i,
                            w: 1000,
                            h: 1000)
            rects.append(rect)
        }
        
        self.measure {
            let intersections = processor.find(in: rects)
            print("Performance test for \(rectNum) rects, intersections: \(intersections.count)")
        }
    }

}
