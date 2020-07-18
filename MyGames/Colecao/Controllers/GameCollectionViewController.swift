//
//  GameCollectionViewController.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 18/07/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit
import CoreData

class GameCollectionViewController: UIViewController {

    private var collectionView: GameCollectionView = GameCollectionView()
        private var didConfigure: Bool = false
        var fetchedResultController:NSFetchedResultsController<Game>!
        override func viewDidLoad() {
            super.viewDidLoad()
            loadGames()
            // Do any additional setup after loading the view.
        }
        
        override func loadView() {

            view = collectionView

        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            if !didConfigure {
                didConfigure = true
                configureCollectionView()
            }
        }

        private func configureCollectionView() {
                let layout = UICollectionViewFlowLayout()
                layout.itemSize = collectionView.collectionView.frame.size
                layout.itemSize.height = layout.itemSize.width
                //layout.minimumLineSpacing = 10
        //        layout.minimumInteritemSpacing = 10
                layout.scrollDirection = .vertical

                collectionView.collectionView.delegate = self
                collectionView.collectionView.dataSource = self

                collectionView.collectionView.isPagingEnabled = false
                collectionView.collectionView.collectionViewLayout = layout

                collectionView.collectionView.register(UINib(nibName: "GameCollectionViewCell",
                                                             bundle: nil),
                                                       forCellWithReuseIdentifier: "GameCollectionCell")
            collectionView.collectionView.reloadData()
            }
        
        func loadGames(filtering: String = "") {
            let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
           
            if !filtering.isEmpty {
                // usando predicate: conjunto de regras para pesquisas
                // contains [c] = search insensitive (nao considera letras identicas)
                let predicate = NSPredicate(format: "title contains [c] %@", filtering)
                fetchRequest.predicate = predicate
            }
           
            // possui
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultController.delegate = self
           
            do {
                try fetchedResultController.performFetch()
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
      extension GameCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                let count = fetchedResultController?.fetchedObjects?.count ?? 0
                
                return count
            }

            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionCell", for: indexPath) as? GameCollectionViewCell else {
                    return UICollectionViewCell()
                }
                guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
                   return cell
                }
                       
                cell.prepare(with: game)
                return cell
            }
        
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let create = GameViewController(nibName: "GameView", bundle: nil)
                      if let games = fetchedResultController.fetchedObjects {
                         create.game = games[indexPath.row]
                                  }
                
                navigationController?.pushViewController(create, animated: true)
            }

    }

    extension GameCollectionViewController: NSFetchedResultsControllerDelegate {
       
        // sempre que algum objeto for modificado esse metodo sera notificado
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
           
            switch type {
                case .delete:
                    if let indexPath = indexPath {
                        // Delete the row from the data source
                        collectionView.collectionView.deleteItems(at: [indexPath])
                    }
                    break
                default:
                    loadGames()
                    collectionView.collectionView.reloadData()
            }
        }

}
