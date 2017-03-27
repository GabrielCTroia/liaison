//
//  LiaisonTests.swift
//  LiaisonTests
//
//  Created by gabriel troia on 3/18/17.
//  Copyright © 2017 gabriel troia. All rights reserved.
//

import XCTest
@testable import Liaison

class LiaisonTests: XCTestCase {
    
    //MARK: Record Tests
    
    func testRecordInitializationSucceeds() {
        let noTitleRecord = Record(title: "", audioURL: URL(string: "")!)
        XCTAssertNil(noTitleRecord)
    }
    
}
