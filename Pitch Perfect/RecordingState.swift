//
//  RecordingState.swift
//  Pitch Perfect
//
//  Created by Venkata Palakodety on 6/27/15.
//  Copyright (c) 2015 Venkata Palakodety. All rights reserved.
//

import Foundation

// Keep track of the recording state in order to record, pause and stop playing audio.
enum RecordingState {
    case Record, Pause, Stop
}