//
//  FirstViewController.swift
//  SeeFood
//
//  Created by Joseph Toronto on 1/15/21.
//

import UIKit

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var userImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func photoLibaryButtonPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage{
            
            userImage = userPickedImage
            performSegue(withIdentifier: "resultsSegue", sender: self)
            
            
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "resultsSegue"{
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.imageToProcess = userImage
            
            
            
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
