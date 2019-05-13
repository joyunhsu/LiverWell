//
//  LiverWellTests.swift
//  LiverWellTests
//
//  Created by Jo Yun Hsu on 2019/5/10.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import XCTest
import UIKit

class LiverWellTests: XCTestCase {
    // swiftlint:disable identifier_name

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        testBigNumber()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            for _ in 0...1000 {
                let _ = UIView()
            }
        }
    }
    
    func add(aaa: Int, bbb: Int) -> Int {
        return aaa + bbb
//        return 0
    }
    
    func testJo() {
        // 3A - Arrange, Action, Assert
        
        // Arrange 把素材、預期結果準備好
        let aaa = 10
        
        let bbb = 20
        
        let expectedResult = aaa + bbb
        
        // Action
        let actualResult = add(aaa: aaa, bbb: bbb)
        
        // Assert
        XCTAssertEqual(actualResult, expectedResult)
        
    }
    
    func fib(_ n: Int) -> Int {
        
//        var fibs: [Int] = [1, 1]
//        (2...n).forEach { i in
//            fibs.append(fibs[i - 1] + fibs[i - 2])
//        }
//        return fibs.last!
        
        var a = 1
        var b = 1
        guard n > 1 else { return a}

        (2...n).forEach { (_) in
            (a, b) = (a + b, a)
        }
        return a
    }
    
    func test_initialInput() {
        XCTAssertEqual(fib(0), 1)
        XCTAssertEqual(fib(1), 1)
    }
    
    func test_numberTwo() {
        XCTAssertEqual(fib(2), 2)
    }
    
    func test_bigNumber() -> Int {
        return fib(999)
    }
    
    func test_correct() {
        let n10 = fib(10)
        let n11 = fib(11)
        let n12 = fib(12)
        XCTAssertEqual(n12, n10 + n11)
    }
    
    func test_negative() {
//        XCTAssertNil(fib(-1))
    }

}
