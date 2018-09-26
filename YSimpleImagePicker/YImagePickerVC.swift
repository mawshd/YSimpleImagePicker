//
//  YImagePickerVC.swift
//  YSimpleImagePicker
//
//  Created by Awais Shahid on 26/09/2018.
//  Copyright © 2018 IAMTeam. All rights reserved.
//

import UIKit

enum ImageSelectionType : Int {
    case both
    case camera
    case gallery
}

protocol YImgPickerDelegate {
    func didFinishImagePicking(image: UIImage)
    func didCancelImagePicking(str : String)
}


class YImagePickerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var shouldOpenFrontCamera = false
    var imgSelectionType : ImageSelectionType = .both
    var imgPickerController = UIImagePickerController()
    var delegate: YImgPickerDelegate?
    
    var firstTime = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstTime {
            firstTime = false
            if delegate == nil {
                self.dismissVC()
                return
            }
            
            imgPickerController.delegate = self
            
            if imgSelectionType == .both {
                let alert=UIAlertController(title: "Select Option", message: nil, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
                let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
                    UIAlertAction in self.openCamera()
                }
                let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default) {
                    UIAlertAction in self.openGallary()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in /*cencel default*/
                    self.delegate?.didCancelImagePicking(str: "Cancelled from action sheet.")
                    self.goBack()
                }
                
                // Add the actions
                alert.addAction(cameraAction)
                alert.addAction(gallaryAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            else if imgSelectionType == .camera {
                openCamera()
            }
            else {
                openGallary()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func dismissVC(_ sender: UIButton = UIButton()) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imgPickerController.sourceType = UIImagePickerControllerSourceType.camera;
            if shouldOpenFrontCamera {
                imgPickerController.cameraDevice = .front
            }
            self.present(imgPickerController, animated: true, completion: nil)
        }
        else{
            openGallary()
        }
    }
    
    func openGallary() {
        imgPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imgPickerController, animated: true, completion: nil)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if var img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            img = img.fixedOrientation()
            delegate?.didFinishImagePicking(image: img)
            goBack()
        }
        else {
            delegate?.didCancelImagePicking(str: "original image found nil")
            goBack()
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.didCancelImagePicking(str: "imagePickerControllerDidCancel")
        goBack()
    }
    
    
    
    func goBack() {
        // delegate method should be called before this
        imgPickerController.dismiss(animated: true, completion: {
            if self.navigationController != nil {
                self.navigationController?.popViewController(animated: false)
            } else {
                self.dismiss(animated: false, completion: nil)
            }
        })
        
    }
    
    
    
    
    
    
}


extension UIImage {
    
    func fixedOrientation() -> UIImage
    {
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        switch imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
            
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        return UIImage(cgImage: ctx.makeImage()!)
    }
}
