//
//  MusicTableViewController.swift
//  LoopBuddy
//
//  Created by Westley Russell on 3/29/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//
import MediaPlayer
import UIKit

class MusicTableViewController: UITableViewController {
    
    
    
    struct TableView{
        struct CellIdentifiers{
            static let MusicCell = "MusicCell"
        }
    }

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    //var mediaQuery = MPMediaQuery()
    
    var songsArray = [MPMediaItem]()
    var musicItemArray = [MusicItem]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        songsArray = MPMediaQuery.songsQuery().items as [MPMediaItem]
        for songItem in songsArray{
            var song:MusicItem? = MusicItem(songName: songItem.title, songArtist: songItem.albumArtist, songAlbum: songItem.albumTitle,  songGenre: songItem.genre)
            musicItemArray.append(song!)
            
        }
        
        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return musicItemArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.MusicCell, forIndexPath: indexPath) as MusicCell

        // Configure the cell...
        cell.configureForMusic(musicItemArray[indexPath.row])
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let row = indexPath?.row
        println(row)
        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        self.showViewController(vc as UIViewController, sender: vc)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

class MusicCell: UITableViewCell{
   
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songAlbumLabel: UILabel!
    
    func configureForMusic(song: MusicItem){
        songTitleLabel.text = song.songName
        songArtistLabel.text = song.songArtist
        songAlbumLabel.text = song.songAlbum
    }
}
