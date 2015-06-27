//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Venkata Palakodety on 6/9/15.
//  Copyright (c) 2015 Venkata Palakodety. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    // Initializer for RecordedAudio to initialize filePathUrl and title variables.
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}