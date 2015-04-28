//
//  MusicTableViewController.swift
//  LoopBuddy
//
//  Created by Westley Russell on 3/29/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//
import MediaPlayer
import UIKit


class MusicTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    
    struct TableView{
        struct CellIdentifiers{
            static let MusicCell = "MusicCell"
        }
    }

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    
    var songsArray = [MPMediaItem]()//the songs from the library
    
    var musicItemArray = [MusicItem]()//changes the songs from the query to our musicItem class
    
    var filteredSongs = [MusicItem]()//the filtered search results
    
    var isSearching:Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //For Production
        /*
        songsArray = MPMediaQuery.songsQuery().items as [MPMediaItem]
        for songItem in songsArray{
            var song:MusicItem? = MusicItem(songName: songItem.title, songArtist: songItem.albumArtist, songAlbum: songItem.albumTitle,  songGenre: songItem.genre, category: MusicItem.Category.Songs)
            musicItemArray.append(song!)
        
        }
        */
        
        //for testing
        self.musicItemArray = [MusicItem(songName: "Pay No Mind (Ft. Passion Pit)", songArtist: "Madeon", songAlbum: "Thigh Gap Nation",  songGenre: "Pre Game", category: "Songs", location: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pay No Mind", ofType: "mp3")!)!),
            MusicItem(songName: "Never Stop", songArtist: "Charlie XCX X Calvin Harris X Alex Farway", songAlbum: "Thigh Gap Nation",  songGenre: "Pre Game", category: "Songs", location: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Never Stop", ofType: "mp3")!)!),
            MusicItem(songName: "Real Love", songArtist: "Clean Bandit & Jess Glynne", songAlbum: "Thigh Gap Nation",  songGenre: "Pre Game", category: "Songs", location: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Real Love", ofType: "mp3")!)!),
            MusicItem(songName: "Love Me like You Do(ATB Remix)", songArtist: "Ellie Goulding", songAlbum: "Thigh Gap Nation",  songGenre: "Pre Game", category: "Songs", location: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Love Me Like You Do", ofType: "mp3")!)!),
            MusicItem(songName: "The Hum", songArtist: "Dimitri Vegas & Like Mike & Ummet Ozcan", songAlbum: "Thigh Gap Nation",  songGenre: "Pre Game", category: "Songs", location: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("The Hum", ofType: "mp3")!)!),
            MusicItem(songName: "Truffle Butter", songArtist: "Nicki Minaj", songAlbum: "Thigh Gap Nation",  songGenre: "Pre Game", category: "Songs", location: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Truffle Butter", ofType: "mp3")!)!),
            MusicItem(songName: "Wasted (Ummet Ozcan Remix)", songArtist: "Tiesto", songAlbum: "Thigh Gap Nation",  songGenre: "Pre Game", category: "Songs", location: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Wasted", ofType: "mp3")!)!)]
            
        
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
        if tableView == self.searchDisplayController!.searchResultsTableView{
            return self.filteredSongs.count
        }
        else{
            return self.musicItemArray.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as MusicCell //reusable cell from tableview
        var song : MusicItem
        
        if tableView == self.searchDisplayController!.searchResultsTableView{
            song = filteredSongs[indexPath.row]
        }
        else{
            song = self.musicItemArray[indexPath.row]
        }
        
        // Configure the cell
        
        cell.configureMusicCell(song)
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //self.performSegueWithIdentifier("mainScreen", sender: tableView)
        if isSearching{
            let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
            let song = self.filteredSongs[indexPath.row]
            setAttributes(song)
            
            
        }
            
        else{
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let song = self.musicItemArray[indexPath.row]
            setAttributes(song)
            
        }
        
    }

    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        //filter array
        self.filteredSongs = self.musicItemArray.filter({(song: MusicItem) -> Bool in
            var categoryMatch = (scope == "All") || (song.songCategory == scope)
            let stringMatch = song.songName.lowercaseString.rangeOfString(searchText.lowercaseString)
            self.isSearching = true
            return categoryMatch && (stringMatch != nil)
        })
    }
    //reloads the table when the search bar is updated
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool{
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        isSearching = true
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let scope = self.searchDisplayController?.searchBar.scopeButtonTitles as [String]
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
        isSearching = true
        return true
    }
    
    //Set the row height for the search table view to be the same as the table view
    func searchDisplayController(controller: UISearchDisplayController, didLoadSearchResultsTableView tableView: UITableView) {
        tableView.rowHeight = 109;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if segue.identifier == "mainScreen"{
            //let mainScreenViewController = segue.destinationViewController as ViewController
            
            if isSearching{
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let song = self.filteredSongs[indexPath.row]
                setAttributes(song)
                
                
            }

            else{
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let song = self.musicItemArray[indexPath.row]
                setAttributes(song)
                
            }
        }
    }
    
    func setAttributes(song: MusicItem){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.songTitle = song.songName
        appDelegate.songArtist = song.songArtist
        appDelegate.songAlbum = song.songAlbum
        appDelegate.songUrl = song.songLocation
        appDelegate.songStart = song.songStart
        appDelegate.songEnd = song.songEnd
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

