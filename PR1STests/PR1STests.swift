//
//  PR1STests.swift
//  PR1STests
//
//  Created by Javier Salvador Calvo on 24/9/16.
//  Copyright © 2016 UOC. All rights reserved.
//

import XCTest


@testable import PR1S

class PR1STests: XCTestCase {
    
    var app:UIApplication? = nil
    var appDelegate:AppDelegate? = nil;
    var viewController:ViewController? = nil;
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.app = UIApplication.shared;
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        
        let nav:UINavigationController = (self.appDelegate?.window?.rootViewController as? UINavigationController)!
        
        self.viewController = nav.viewControllers[0] as? ViewController
        
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.viewController?.m_provider?.LoadAndParseInternal()
        }
    }
    
}
