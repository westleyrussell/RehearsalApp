//
//  ModelManager.swift
//  LoopBuddy
//
//  Created by Westley Russell on 4/28/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//

import UIKit

let sharedInstance = ModelManager()

class ModelManager: NSObject {
    var database: FMDatabase? = nil
    
    
    class var instance: ModelManager{
        sharedInstance.database = FMDatabase(path: Util.getPath("Samples.sqlite"))
        var path = Util.getPath("Samples.sqlite")
        return sharedInstance
    }
    
    func addMusicSample(sample: MusicItem) -> Bool{
        sharedInstance.database!.open()
        println(sample.songLocation)
        println()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO samples (songName, songArtist, songAlbum, songUrl, startTime, endTime, songGenre) VALUES(?,?,?,?,?,?,?)", withArgumentsInArray: [sample.songName, sample.songArtist, sample.songAlbum, sample.songLocation, sample.songStart, sample.songEnd, sample.songGenre])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func getAllSamples() -> [MusicItem]{
        sharedInstance.database!.open()
        var samples: [MusicItem] = [MusicItem]()
        var resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM samples", withArgumentsInArray: nil)
        var nameCol: String = "songName"
        var artistCol: String = "songArtist"
        var albumCol: String = "songAlbum"
        var urlCol: String = "songUrl"
        var startTimeCol: String = "startTime"
        var endTimeCol: String = "endTime"
        var genreCol: String = "songGenre"
        if resultSet != nil{
            while resultSet.next(){
                print(resultSet.stringForColumn(urlCol))
                println()
                samples.append(MusicItem(songName: (resultSet.stringForColumn(nameCol) + " " + resultSet.stringForColumn("id")), songArtist: resultSet.stringForColumn(artistCol), songAlbum: resultSet.stringForColumn(albumCol), songGenre: resultSet.stringForColumn(genreCol), category: "Sample", location: NSURL(string: resultSet.stringForColumn(urlCol))!, songStart: resultSet.doubleForColumn(startTimeCol), songEnd: resultSet.doubleForColumn(endTimeCol)))
            }
        }
        sharedInstance.database!.close()
        return samples
    }
}
