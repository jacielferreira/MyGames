//
//  LoginViewController.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 18/07/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func entrarButton(_ sender: UIButton){
        
        guard let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as GameTabViewController? else {
            return
        }
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        presentOnboarding()
        // Do any additional setup after loading the view.
    }
    
    func presentOnboarding() {
        let onboarding = OnboardingViewController()
        onboarding.nav = navigationController
        navigationController?.present(onboarding, animated: true)
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
