//
//  ViewController.swift
//  ClarifaiSwiftDemo
//
//  Created by Tommy Qiu on 3/31/17.
//

import UIKit
import Clarifai
import AVFoundation
import AVKit
//import SwiftyCam


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    var app:ClarifaiApp?
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        app = ClarifaiApp(apiKey: "ab5f0f31e6ac4f9ea69c6f825218c9a7")
        
        // Depracated, for older Clarifai Applications.
        // app = ClarifaiApp(appID: "", appSecret: "")
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton
        ) {
        picker.allowsEditing = false;
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.delegate = self;
        present(picker, animated: true, completion: nil)
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        // Show a UIImagePickerController to let the user pick an image from their library.
        
        picker.allowsEditing = false;
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.delegate = self;
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        // The user picked an image. Send it to Clarifai for recognition.
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            recognizeImage(image: image)
            textView.text = ""
            button.isEnabled = false
            cameraButton.isEnabled = false
            
            
            
            activityIndicator.center  = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        else{
            print("Could not pick image")
        }
    }
    
    func recognizeImage(image: UIImage) {
        // Check that the application was initialized correctly.
        if let app = app {
            
            // Fetch Clarifai's general model.
           
//            app.getModelByID("e52e2a33cfb84d7bbbff9429131b2af5", completion: { (model, error) in
//                print("GOT IN MY MODEL")
//                // Create a Clarifai image from a uiimage.
//                let caiImage = ClarifaiImage(image: image)!
//                print("1")
//                // Use Clarifai's general model to pedict tags for the given image.
//                model?.predict(on: [caiImage], completion: { (outputs, error) in
//                    print("%@", error ?? "no error")
//                    
//                    guard
//                        let caiOuputs = outputs
//                        else {
//                            print("Predict failed")
//                            return
//                    
//                    }
//                    print("HEREERERE1")
//                    if let test = outputs?.first{
//                        print("yes")
//                    }
//                    else{
//                        print("NO")
//                    }
//                    if let caiOutput = caiOuputs.first {
//                        
//                        var paperEggFlag = false
//                        var milkCartonFlag = false
//                        
//                        
//                        // Loop through predicted concepts (tags), and display them on the screen.
//                        print("HEREERERE")
//                        for concept in caiOutput.concepts {
//                            print("Chekcing")
//                            if concept.conceptName == "PaperEgg" && concept.score > 0.80{
//                                
//                                paperEggFlag = true;
//                            }
//                            if (concept.conceptName == "Milk carton") && concept.score > 0.80{
//                                
//                                milkCartonFlag = true
//                                
//                                
//                            }
//                        }
//                        
//                        DispatchQueue.main.async {
//                            // Update the new tags in the UI.
//                            if paperEggFlag == true{
//                                self.textView.text = "This is made of paper, please put it in the green bin with the recycling symbol"
//                            }
//                            else if milkCartonFlag == true{
//                                
//                                self.textView.text = "This is a milk carton and belongs in the blue bin in New York City"
//                            }
//                            else if paperEggFlag == false && milkCartonFlag == false{
//                                self.textView.text = "This item is not recyclable"
//                                
//                            }
//                            self.button.isEnabled = true
//                            self.activityIndicator.stopAnimating()
////                            print("GOT HERE")
//                            return
//                        }
//                    }
//                })
//            })
//            
            app.getModelByID("aaa03c23b3724a16a56b629203edc62c", completion: { (model, error) in
                // Create a Clarifai image from a uiimage.
                print("GOT IN GENERAL MODEL")
                let caiImage = ClarifaiImage(image: image)!
                
                // Use Clarifai's general model to pedict tags for the given image.
                model?.predict(on: [caiImage], completion: { (outputs, error) in
                    
                    print("%@", error ?? "no error")
                    
                    guard
                        let caiOuputs = outputs
                        else {
                            print("Predict failed")
                            return
                    }
                    //                    print("Here")
                    if let caiOutput = caiOuputs.first {
                        var paperFlag = false
                        var blueFlag = false
                        var blueItem = ""
                        // Loop through predicted concepts (tags), and display them on the screen.
                        for concept in caiOutput.concepts {
                            if (concept.conceptName == "paper"  || concept.conceptName == "cardboard") && concept.score > 0.80{
                                
                                paperFlag = true;
                            }
                            else if (concept.conceptName == "metallic" || concept.conceptName == "aluminum" || concept.conceptName == "steel" || concept.conceptName == "plastic" || concept.conceptName == "glass" || concept.conceptName == "carton" || concept.conceptName == "container" || concept.conceptName == "milk") && concept.score > 0.80{
                                
                                blueFlag = true
                                blueItem = concept.conceptName
                            }
                        }
                        
                        DispatchQueue.main.async {
                            // Update the new tags in the UI.
                            if paperFlag == true{
                                self.textView.text = "This is made of paper, please put it in the green bin with the recycling symbol"
                            }
                            else if blueFlag == true{
                                
                                self.textView.text = "This is \(blueItem) and belongs in the blue bin"
                            }
                            else{
                                self.textView.text = "This item is not recyclable"
                            }
                            self.activityIndicator.stopAnimating()
                            self.button.isEnabled = true;
                            self.cameraButton.isEnabled = true;
                            //                            print("done")
                        }
                    }
                })
            })
        }
    }
}

