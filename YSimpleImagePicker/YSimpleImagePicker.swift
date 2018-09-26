//
//  YSimpleImagePicker.swift
//  YSimpleImagePicker
//
//  Created by Awais Shahid on 26/09/2018.
//  Copyright © 2018 IAMTeam. All rights reserved.
//

import Foundation


public class DriBerSDK : NSObject, YImgPickerDelegate {
    
    var onImgPickingFinish:(UIImage)->() = {_ in}
    var onCancelling:(String)->() = {_ in}
    var refController = UIViewController()
    
    func selectImage(refController:UIViewController, shouldOpenFrontCamera : Bool = false, imgSelectionType : ImageSelectionType = .both, onSelection : @escaping (_ image : UIImage) -> Void, onCancellation : @escaping (_ str : String) -> Void ) {
        
        self.onImgPickingFinish = onSelection
        self.onCancelling = onCancellation
        self.refController = refController
        
        let vc = YImagePickerVC(nibName: "YImagePickerVC", bundle: nil)
        vc.delegate = self
        
        vc.shouldOpenFrontCamera = shouldOpenFrontCamera
        vc.imgSelectionType = imgSelectionType
        
        DispatchQueue.main.async {
            refController.modalPresentationStyle = .overCurrentContext
            refController.present(vc, animated: true, completion: nil)
        }
    }
    
    func didFinishImagePicking(image: UIImage) {
        onImgPickingFinish(image)
        refController.dismiss(animated: false, completion: nil)
    }
    
    func didCancelImagePicking(str: String) {
        onCancelling(str)
        refController.dismiss(animated: false, completion: nil)
    }
}
