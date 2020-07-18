//
//  OnboardingViewController.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 17/07/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    var nav:UINavigationController?
    private var onboardingView: OnboardingView = OnboardingView()
        private var dataSource: [OnboardingCollectionViewCellModel] = [
            OnboardingCollectionViewCellModel(mainText: "Coleção na palma da mão", imageName: "firstImage"),
            OnboardingCollectionViewCellModel(mainText: "Acesso Rápido", imageName: "secondImage"),
            OnboardingCollectionViewCellModel(mainText: "Organize seus games", imageName: "thirdImage")
        ]
        private var didConfigure: Bool = false

        override func loadView() {
            onboardingView.nav = self.nav
            view = onboardingView
            configurePageControl()
            lockOrientation(.portrait, andRotateTo: .portrait)
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            lockOrientation(.allButUpsideDown)
        }

        func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }

        /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
        func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

            self.lockOrientation(orientation)

            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            if !didConfigure {
                didConfigure = true
                configureCollectionView()
            }
        }

        private func configurePageControl() {
            onboardingView.pageControl.numberOfPages = dataSource.count
        }

        private func configureCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = onboardingView.collectionView.frame.size
    //        layout.minimumLineSpacing = 10
    //        layout.minimumInteritemSpacing = 10
            layout.scrollDirection = .horizontal

            onboardingView.collectionView.delegate = self
            onboardingView.collectionView.dataSource = self

            onboardingView.collectionView.isPagingEnabled = true
            onboardingView.collectionView.collectionViewLayout = layout

            onboardingView.collectionView.register(UINib(nibName: "OnboardingCollectionViewCell",
                                                         bundle: nil),
                                                   forCellWithReuseIdentifier: "OnboardingCollectionViewCellID")
        }
    }

    extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dataSource.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCellID", for: indexPath) as? OnboardingCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(model: dataSource[indexPath.row])
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            onboardingView.pageControl.currentPage = indexPath.row
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
