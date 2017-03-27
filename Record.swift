//
//  Record.swift
//  Liaison
//
//  Created by gabriel troia on 3/18/17.
//  Copyright © 2017 gabriel troia. All rights reserved.
//

import Foundation

class Record {

    var title: String
//    var audioURL: URL
    
    //init?(title: String, audioURL: URL) {
    init?(title: String) {
        if title.isEmpty {
            fatalError("The Record is empty")
        }
        
        self.title = title
//        self.audioURL = audioURL
    }
    
}
