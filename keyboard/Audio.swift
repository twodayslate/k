//
//  Audio.swift
//  keyboard
//
//  Created by Zachary Gorak on 10/18/22.
//

import Foundation
import AudioToolbox

enum Sound {
    case normal
    case modifier
    case delete
}

func AudioServicesPlaySystemSound(_ sound: Sound) {
    switch sound {
    case .delete:
        AudioServicesPlaySystemSound(1155)
    case .normal:
        AudioServicesPlaySystemSound(1104)
    case .modifier:
        AudioServicesPlaySystemSound(1156)
    }
}
