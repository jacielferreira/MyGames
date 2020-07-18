//
//  GameViewController.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 17/07/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editGame))
        navigationItem.rightBarButtonItem = edit
        // Do any additional setup after loading the view.
    }
    @objc func editGame(){
        let create = AddEditViewController(nibName: "GameEdit", bundle: nil)
        create.game = self.game
        navigationController?.pushViewController(create, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        lbTitle.text = game.title
        lbConsole.text = game.console?.name
        if let releaseDate = game.releaseDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            lbReleaseDate.text = "Lançamento: " + formatter.string(from: releaseDate)
        }
       
        if let image = game.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = game
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
