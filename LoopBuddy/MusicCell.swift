//
//  MusicCell.swift
//  LoopBuddy
//
//  Created by Westley Russell on 4/22/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {

    @IBOutlet weak var musicCellTitle: UILabel!
    @IBOutlet weak var musicCellArtist: UILabel!
    @IBOutlet weak var musicCellAlbum: UILabel!
    
    
    func configureMusicCell(song: MusicItem ){
        musicCellTitle.text = song.songName
        musicCellArtist.text = song.songArtist
        musicCellAlbum.text = song.songAlbum
    }
    
}
