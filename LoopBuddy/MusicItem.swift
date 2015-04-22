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
    
    enum Category{
        case Songs
        
        case Clips
    }
    
    let songName: String
    let songArtist: String
    let songAlbum: String
    let songGenre: String
    let songCategory: Category
    
    init(songName: String, songArtist: String, songAlbum: String, songGenre: String, category: Category){
        self.songName = songName
        self.songArtist = songArtist
        self.songAlbum = songAlbum
        self.songGenre = songGenre
        self.songCategory = category
    }
}
