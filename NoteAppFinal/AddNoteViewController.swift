//
//  AddNoteViewController.swift
//  NoteAppFinal
//
//  Created by Gian Carlo Baldonado on 5/9/21.
//

import Foundation
import UIKit

class AddNoteViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let store = NoteAppViewController()
    
    @IBOutlet weak var noteTitleField: UITextField!
    @IBOutlet weak var noteDescriptionField: UITextView!
    
    @IBAction func saveTapped(_ sender: Any) {
        
        guard
            let titleText = noteTitleField.text,
            let descriptionText = noteDescriptionField.text
        else {
            return
        }
      
        
        self.store.createNote(title: titleText, desc: descriptionText)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: notes.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.endUpdates()

        dismiss(animated: true, completion: nil)
        
    }
    
    
}
