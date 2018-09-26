//
//  YSimpleImagePicker.swift
//  YSimpleImagePicker
//
//  Created by Awais Shahid on 26/09/2018.
//  Copyright © 2018 IAMTeam. All rights reserved.
//

import Foundation
import UIKit

public enum ImageSelectionType : Int {
    case both
    case camera
    case gallery
}

public class YSimpleImagePicker : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    open static let shared = YSimpleImagePicker()
    private override init() {
        
    }
    
    private var onImgPickingFinish:(UIImage)->() = {_ in}
    private var onCancelling:(String)->() = {_ in}
    private var refController : UIViewController?
    private var imgPickerController = UIImagePickerController()
    
    private var allowEditing = false
    private var shouldOpenFrontCamera = false

    
    open func selectImage(refController:UIViewController, allowEditing: Bool = false, shouldOpenFrontCamera : Bool = false, imgSelectionType : ImageSelectionType = .both, onSelection : @escaping (_ image : UIImage) -> Void, onCancellation : @escaping (_ str : String) -> Void ) {
        
        self.refController = refController
        self.allowEditing = allowEditing
        self.shouldOpenFrontCamera = shouldOpenFrontCamera
        self.onImgPickingFinish = onSelection
        self.onCancelling = onCancellation
        
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
                UIAlertAction in
                onCancellation("Cancelled from action sheet")
            }
            
            // Add the actions
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)
            
            refController.present(alert, animated: true, completion: nil)
        }
        else if imgSelectionType == .camera {
            openCamera()
        }
        else {
            openGallary()
        }
    }
    
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imgPickerController.sourceType = UIImagePickerControllerSourceType.camera;
            if shouldOpenFrontCamera {
                imgPickerController.cameraDevice = .front
            }
            imgPickerController.allowsEditing = allowEditing
            refController?.present(imgPickerController, animated: true, completion: nil)
        }
        else{
            openGallary()
        }
    }
    
    func openGallary() {
        imgPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imgPickerController.allowsEditing = allowEditing
        refController?.present(imgPickerController, animated: true, completion: nil)
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[allowEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage {
            onImgPickingFinish(img)
        }
        else {
            onCancelling("image not found")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        onCancelling("cancel image picking")
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
