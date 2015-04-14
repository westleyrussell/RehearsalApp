//
//  MusicItem.swift
//  LoopBuddy
//
//  Created by Westley Russell on 4/3/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//

import UIKit

@objc
class MusicItem{
    let songName: String
    let songArtist: String
    let songAlbum: String
    let songGenre: String
    
    init(songName: String, songArtist: String, songAlbum: String, songGenre: String){
        self.songName = songName
        self.songArtist = songArtist
        self.songAlbum = songAlbum
        self.songGenre = songGenre
    }
}
