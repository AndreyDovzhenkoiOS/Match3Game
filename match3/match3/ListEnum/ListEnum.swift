//
//  Constants.swift
//  Match3
//
//  Created by Andrey on 12.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import Foundation

enum Types {
    case biscuit,cake,croissant,danish,donut,star
}

enum PositionDetectMatches{
    case horizontal,vertical
}

enum Sounds {
    static let error = "Error"
    static let scrape = "Scrape"
    static let musicFon = "MusicFon"
    static let refresh = "Refresh"
    static let victory = "Victory"
    static let drip = "Drip"
    
    enum Types {
        static let wav = "wav"
        static let mp3 = "mp3"
    }
}

enum Notifications{
    static let notificationNameSwap = Notification.Name("notificationNameSwap")
    static let notificationNameMatch = Notification.Name("notificationNameMatch")
}
