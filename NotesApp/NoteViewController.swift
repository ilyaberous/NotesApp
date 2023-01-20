//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Ilya on 17.01.2023.
//

import Foundation
import UIKit


class NoteViewController : UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    public var update : (() -> Void)?
    
    public var titleNote: String = " "
    public var textNote: String = " "
    public var isTapped = false
    public var numberOfRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        textView.allowsEditingTextAttributes = true;
        
        if(isTapped) {
            titleField.text = titleNote
            textView.text = textNote
        }
    }
    
    
    @IBAction func didTapSave(_ sender: UIBarButtonItem) {
        guard let text = textView.text, let title = titleField.text, !title.isEmpty, !text.isEmpty else {
            return
        }
        
        let userDefaults = UserDefaults.standard
        guard let count = userDefaults.value(forKey: "count") as? Int else {
            return
        }
        
        if (!isTapped) {
            let newCount = count + 1
            userDefaults.set(newCount, forKey: "count")
            
            userDefaults.set(title, forKey: "title\(newCount)")
            userDefaults.set(text, forKey: "text\(newCount)")
        } else {
            userDefaults.set(title, forKey: "title\(numberOfRow + 1)")
            userDefaults.set(text, forKey: "text\(numberOfRow + 1)")
        }
        update?()
        navigationController?.popViewController(animated: true)
        isTapped = false
    }
    
}
