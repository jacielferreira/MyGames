//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 17/07/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit
import Photos

class AddEditViewController: UIViewController, UITextFieldDelegate {

    var game: Game!
        
        @IBOutlet weak var tfTitle: UITextField!
        @IBOutlet weak var tfConsole: UITextField!
        @IBOutlet weak var dpReleaseDate: UIDatePicker!
        @IBOutlet weak var btAddEdit: UIButton!
        @IBOutlet weak var btCover: UIButton!
        @IBOutlet weak var ivCover: UIImageView!
        
          lazy var pickerView: UIPickerView = {
                let pickerView = UIPickerView()
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.backgroundColor = .white
                return pickerView
            }()
        var consolesManager = ConsolesManager.shared
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
            
            tfTitle.delegate = self
            consolesManager.loadConsoles(with: context)
            
            
            // Do any additional setup after loading the view.
        }
        override func viewWillAppear(_ animated: Bool){
            super.viewWillAppear(animated)
            prepareDataLayout()
        }
        
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
            return .portrait
        }
        
        override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
            return .portrait
        }
        
        override var shouldAutorotate: Bool{
            return true
        }
        
        func prepareDataLayout(){
            if game != nil {
                 title = "Editar jogo"
                 btAddEdit.setTitle("ALTERAR", for: .normal)
                 tfTitle.text = game.title
                
                 // tip. alem do console pegamos o indice atual para setar o picker view
                if let console = game.console, let index = consolesManager.consoles.firstIndex(of: console) {
                     tfConsole.text = console.name
                     pickerView.selectRow(index, inComponent: 0, animated: false)
                 }
                 ivCover.image = game.cover as? UIImage
                 if let releaseDate = game.releaseDate {
                     dpReleaseDate.date = releaseDate
                 }
                 if game.cover != nil {
                     btCover.setTitle(nil, for: .normal)
                 }
             }
            
             let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
             toolbar.tintColor = UIColor(named: "main")
             let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
             let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
             let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
             toolbar.items = [btCancel, btFlexibleSpace, btDone]
            
             // tip. faz o text field exibir os dados predefinidos pela picker view
             tfConsole.inputView = pickerView
             tfConsole.inputAccessoryView = toolbar
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
        @objc func cancel() {
             tfConsole.resignFirstResponder()
         }
        
         @objc func done() {
             tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
             cancel()
         }
        @IBAction func AddEditCover(_ sender: UIButton) {
             // para adicionar uma imagem da biblioteca
             print("para adicionar uma imagem da biblioteca")
             
             
             let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
             
              let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
                  self.selectPicture(sourceType: .photoLibrary)
              })
              alert.addAction(libraryAction)
             
              let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
                  self.selectPicture(sourceType: .savedPhotosAlbum)
              })
              alert.addAction(photosAction)
             
              let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
              alert.addAction(cancelAction)
             
              present(alert, animated: true, completion: nil)
         }
        func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
            
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = sourceType
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.navigationBar.tintColor = UIColor(named: "main")
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        
        func selectPicture(sourceType: UIImagePickerController.SourceType) {
           
            //Photos
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                       
                        self.chooseImageFromLibrary(sourceType: sourceType)
                       
                    } else {
                       
                        print("unauthorized -- TODO message")
                    }
                })
            } else if photos == .authorized {
               
                self.chooseImageFromLibrary(sourceType: sourceType)
            }
        }
         @IBAction func addEditGame(_ sender: UIButton) {
             
            if game == nil {
              game = Game(context: context)
            }
            game?.title = tfTitle.text
            game?.releaseDate = dpReleaseDate.date
            
            if !tfConsole.text!.isEmpty {
                if consolesManager.consoles.count > 0{
                  let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
                  game.console = console
                }
            }
            game.cover = ivCover.image
            
            do {
               try context.save()
            } catch {
               print(error.localizedDescription)
            }
            // Back na navigation
            navigationController?.popViewController(animated: true)
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
    extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                // ImageView won't update with new image
                // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
                DispatchQueue.main.async {
                    self.ivCover.image = pickedImage
                    self.ivCover.setNeedsDisplay()
                    self.btCover.setTitle(nil, for: .normal)
                    self.btCover.setNeedsDisplay()
                }
            }
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
       
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
       
       
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return consolesManager.consoles.count
        }
       
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let console = consolesManager.consoles[row]
            return console.name
        }

}
