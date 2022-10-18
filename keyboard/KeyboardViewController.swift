//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Zachary Gorak on 10/12/22.
//

import UIKit
import SwiftUI
import AudioToolbox

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    // Need this so we don't get an error during runtime
    var needsInputModeSwitchKeyWrapper = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setImage(UIImage(systemName: "globe"), for: [])
        self.nextKeyboardButton.tintColor = .label
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
            
        let root = UIHostingController(
            rootView:
                KeyboardView(
                    parent: self,
                    needsInputModeSwitchKey: .init(get: {
                        self.needsInputModeSwitchKeyWrapper
                    }, set: { _ in
                        // no-op
                    })
                )
        )
        root.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(root.view)
        self.addChild(root)
        root.didMove(toParent: self)
        self.view.backgroundColor = .clear
        root.view.backgroundColor = .clear
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        needsInputModeSwitchKeyWrapper = needsInputModeSwitchKey
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        needsInputModeSwitchKeyWrapper = needsInputModeSwitchKey
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        needsInputModeSwitchKeyWrapper = needsInputModeSwitchKey
        // The app has just changed the document's contents, the document context has been updated.
    }
}
