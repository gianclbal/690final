//
//  ViewController.swift
//  NoteAppFinal
//
//  Created by Gian Carlo Baldonado on 5/9/21.
//

let tableView: UITableView = {
    let table = UITableView()
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
}()

var notes = [NoteItem]()

import UIKit

class NoteAppViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes App"
        view.addSubview(NoteAppFinal.tableView)
        getAllNotes()
        NoteAppFinal.tableView.delegate = self
        NoteAppFinal.tableView.dataSource = self
        NoteAppFinal.tableView.frame = view.bounds
        NoteAppFinal.tableView.estimatedRowHeight = 150
        NoteAppFinal.tableView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    func presentAddNoteViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addNoteVC = storyboard.instantiateViewController(identifier: "AddNoteViewController")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addNoteVC.modalPresentationStyle = .pageSheet
        present(addNoteVC, animated: true, completion: nil)
    }
   
    //TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        
        guard
            let title = note.title,
            let desc = note.desc,
            let date = note.createdAt

        else {
            return cell
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let dateTime = dateFormatter.string(from: date)
        content.text = title
        content.secondaryText = dateTime + "\n\n" + desc
        content.textProperties.font = .systemFont(ofSize: 20, weight: .semibold)
        content.secondaryTextProperties.font = .systemFont(ofSize: 20, weight: .regular)
        content.secondaryTextProperties.lineBreakMode = .byWordWrapping
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let note = notes[indexPath.row]
        
        guard
            let title = note.title,
            let desc = note.desc,
            let date = note.createdAt

        else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let dateTime = dateFormatter.string(from: date)
        
        let sheet = UIAlertController(
            title: title,
            message: dateTime,
            preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Rename", style: .default, handler: {_ in
            
            let alert = UIAlertController(
                title: "Rename note",
                message: nil,
                preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = title + "\n"
            
            alert.addAction(UIAlertAction(title: "Rename", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                
                self?.renameNote(item: note, newTitle: newName)
                
            }))
            self.present(alert, animated: true)
            
            
        }))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            
            let alert = UIAlertController(
                title: "Edit note",
                message: nil,
                preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = desc
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newDesc = field.text, !newDesc.isEmpty else {
                    return
                }
                
                self?.updateNote(item: note, newDesc: newDesc)
                
            }))
            self.present(alert, animated: true)
            
            
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteNote(item: note)
        }))
        
        [present(sheet, animated: true)]
        
    }
    
    
    //Functions with COREDATA
    func getAllNotes() {
        do
        {
            notes = try context.fetch(NoteItem.fetchRequest())
            DispatchQueue.main.async {
                NoteAppFinal.tableView.reloadData()
            }
        }
        catch {
            print("Failed getting all notes.")
        }
    }
    
    func createNote(title: String, desc: String) {
        let newNote = NoteItem(context: context)
        newNote.title = title
        newNote.desc = desc
        newNote.createdAt = Date()

        do {
            try context.save()
            getAllNotes()
        } catch {
            print("Failed saving new note.")
        }
        
    }
    
    func deleteNote(item: NoteItem){
        context.delete(item)
        
        
        do {
            try context.save()
            getAllNotes()
            
        } catch {
            print("Failed deleting note.")
        }
        
    }
    
    func renameNote(item: NoteItem, newTitle: String){
        item.title = newTitle
        item.createdAt = Date()
   
        
        do {
            try context.save()
            getAllNotes()
        } catch {
            print("Failed editing note.")
        }
        
    }
    
    func updateNote(item: NoteItem, newDesc: String){
        item.desc = newDesc
        item.createdAt = Date()
        
        do {
            try context.save()
            getAllNotes()
        } catch {
            print("Failed editing note.")
        }
        
    }


}

