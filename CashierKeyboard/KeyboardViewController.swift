//
//  KeyboardViewController.swift
//  CashierKeyboard
//
//  Created by Liefran Satrio Sim on 13/09/24.
//

import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the custom keyboard SwiftUI view
        let customKeyboardView = CalculatorKeyboardView(handleKeyPress: { key in
            self.handleKeyPress(key: key)
        })
        
        // Add SwiftUI view using UIHostingController
        let hostingController = UIHostingController(rootView: customKeyboardView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // Constraints for SwiftUI keyboard view
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Setup the 'Next Keyboard' button (for switching keyboards)
        self.nextKeyboardButton = UIButton(type: .system)
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        NSLayoutConstraint.activate([
            self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    // Handle key press action
    private func handleKeyPress(key: String) {
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        switch key {
        case "C":
            proxy.deleteBackward()  // Delete all characters
            while let text = proxy.documentContextBeforeInput, !text.isEmpty {
                proxy.deleteBackward()
            }
        case "Delete":
            proxy.deleteBackward()  // Delete the last character
        default:
            proxy.insertText(key)  // Insert the key text
        }
    }
}
