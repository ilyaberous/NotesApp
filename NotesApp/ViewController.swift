//
//  ViewController.swift
//  NotesApp
//
//  Created by Ilya on 17.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    public var titles = [String]()
    public var texts = [String]()
    let userDefaults = UserDefaults.standard
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.layer.cornerRadius = 30
        button.backgroundColor = .black
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.38
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(self.tapAddButton(sender:)), for: .touchUpInside)
        self.title = "Notes✏️"
                
        if !userDefaults.bool(forKey: "setup") {
            userDefaults.set(true, forKey: "setup")
            
            titles.append("How I made notes app")
            texts.append("It was very interesting")
            
            userDefaults.set("How I made notes app", forKey: "title1")
            userDefaults.set("It was very interesting", forKey: "text1")
            userDefaults.set(1, forKey: "count")
        }
        
        updateAll()
        checkAreNotesArrayEmpty()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect (
            x: view.frame.size.width - 70,
            y: view.frame.size.height - 100,
            width: 60,
            height: 60
        )
    }
    
    func checkAreNotesArrayEmpty() {
        if (texts.isEmpty && titles.isEmpty) {
            tableView.isHidden = true
            textLabel.isHidden = false
        } else {
            tableView.isHidden = false
            textLabel.isHidden = true
        }
    }
    
    func removeNote(_ indexPath : IndexPath) {
        self.titles.remove(at: indexPath.item)
        self.texts.remove(at: indexPath.item)
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        let newCount = count - 1
        UserDefaults().set(newCount, forKey: "count")
        
        UserDefaults().removeObject(forKey: "title\(indexPath.item + 1)")
        UserDefaults().removeObject(forKey: "text\(indexPath.item + 1)")
        
        for i in indexPath.item..<titles.count {
            UserDefaults().set(titles[i], forKey: "title\(i+1)")
        }
        
        for i in indexPath.item..<texts.count {
            UserDefaults().set(texts[i], forKey: "text\(i+1)")
        }
        
        updateAll()
    }
    
    func updateAll() {
        titles.removeAll()
        texts.removeAll()
        
        guard let count = userDefaults.value(forKey: "count") as? Int else {
            return
        }
        
        for i in 0..<count {
            if let title = userDefaults.value(forKey: "title\(i+1)") as? String {
                titles.append(title)
            }
            
            if let text = userDefaults.value(forKey: "text\(i+1)") as? String {
                texts.append(text)
            }
        }
        
        tableView.reloadData()
    }
    
    
    @objc func tapAddButton(sender: UIButton) {
        sender.customAnimateForButton()
        let vc = storyboard?.instantiateViewController(withIdentifier: "note") as! NoteViewController
        vc.title = "Make new note👍"
        vc.update = {
            DispatchQueue.main.async {
                self.updateAll()
                self.checkAreNotesArrayEmpty()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let noteViewController = storyboard.instantiateViewController(identifier: "note") as? NoteViewController else {return}
        noteViewController.titleNote = userDefaults.value(forKey: "title\(indexPath.row + 1)") as? String ?? "undefinded"
        noteViewController.textNote = userDefaults.value(forKey: "text\(indexPath.row + 1)") as? String ?? "undefinded"
        noteViewController.isTapped = true
        noteViewController.update = {
            DispatchQueue.main.async {
                self.updateAll()
                self.checkAreNotesArrayEmpty()
            }
            noteViewController.numberOfRow = indexPath.row
        }
        navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "", handler: {
            (action, view, completion) in
            //print(indexPath.item, self.)
            self.removeNote(indexPath)
            self.checkAreNotesArrayEmpty()
            
        })
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = userDefaults.value(forKey: "count") as? Int else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = titles[indexPath.row]
        cell.detailTextLabel?.text = texts[indexPath.row]
        return cell
    }
}


