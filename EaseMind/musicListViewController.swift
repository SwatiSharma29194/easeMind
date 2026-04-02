//
//  musicListViewController.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-03-04.
//

import UIKit
import AVFAudio

class musicListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var selectedIndex: IndexPath?
        let miniPlayer = MiniPlayerView()
    var musicList = ["Gentle Rain", "Whispering Trees", "Ocean Waves", "Serenity Piano"]
    let fileNames = ["RainSound", "forestWind", "waves", "piano"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupMiniPlayer()
        setupAudioSession()
        // Do any additional setup after loading the view.
    }
    func setupMiniPlayer() {
            miniPlayer.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(miniPlayer)
            
            NSLayoutConstraint.activate([
                miniPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
                miniPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
                miniPlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
                miniPlayer.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 84, right: 0)
        }

        func setupAudioSession() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Audio session setup failed: \(error)")
            }
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicListTableViewCell", for: indexPath) as! musicListTableViewCell
        cell.soundName.text = musicList[indexPath.row]
        if indexPath == selectedIndex {
                 cell.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                 //cell.textLabel?.textColor = UIColor.white
             } else {
                 cell.backgroundColor = UIColor.clear
                // cell.textLabel?.textColor = UIColor.label
             }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioManagerList.shared.stop()
           
           // Play selected sound
           let selectedFile = fileNames[indexPath.row]
        AudioManagerList.shared.playSound(named: selectedFile)
           
           // Update mini player
           miniPlayer.currentTrack = musicList[indexPath.row]
           miniPlayer.playPauseTapped() // start playing immediately
           
           // Update selected row
           selectedIndex = indexPath
           tableView.reloadData()
           
           tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
