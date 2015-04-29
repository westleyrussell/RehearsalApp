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
    let songCategory: String
    let songLocation: NSURL
    let songStart: Double
    let songEnd: Double
    
    init(songName: String, songArtist: String, songAlbum: String, songGenre: String, category: String, location: NSURL){
        self.songName = songName
        self.songArtist = songArtist
        self.songAlbum = songAlbum
        self.songGenre = songGenre
        self.songCategory = category
        self.songLocation = location
        self.songStart = 0.0
        self.songEnd = 1.0
    }
    
    init(songName: String, songArtist: String, songAlbum: String, songGenre: String, category: String, location: NSURL, songStart: Double, songEnd: Double){
        self.songName = songName
        self.songArtist = songArtist
        self.songAlbum = songAlbum
        self.songGenre = songGenre
        self.songCategory = category
        self.songLocation = location
        self.songStart = songStart
        self.songEnd = songEnd
    }
}
