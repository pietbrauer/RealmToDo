import UIKit
import RealmSwift

class ViewController: UITableViewController {

    var todos: Results<ToDoItem> {
        get {
            let predicate = NSPredicate(format: "finished == false", argumentArray: nil)
            let realm = try! Realm()
            return realm.objects(ToDoItem.self).filter(predicate)
        }
    }

    var finished: Results<ToDoItem> {
        get {
            let predicate = NSPredicate(format: "finished == true", argumentArray: nil)
            let realm = try! Realm()
            return realm.objects(ToDoItem.self).filter(predicate)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        setupNavigationBar()

    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonAction))
    }

    func addButtonAction() {
        let addViewController = AddViewController()
        addViewController.delegate = self
        let navController = UINavigationController(rootViewController: addViewController)
        present(navController, animated: true, completion: nil)

    }

    // MARK: TableView Data Source & Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Int(todos.count)
        case 1:
            return Int(finished.count)
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "To-Do"
        case 1:
            return "Finished"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)

        switch indexPath.section {
        case 0:
            let todoItem = todos[indexPath.row]
            let attributedText = NSMutableAttributedString(string: todoItem.name)
            attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 0, range: NSMakeRange(0, attributedText.length))
            cell.textLabel?.attributedText = attributedText

        case 1:
            let todoItem = finished[indexPath.row]
            let attributedText = NSMutableAttributedString(string: todoItem.name)
            attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributedText.length))
            cell.textLabel?.attributedText = attributedText

        default:
            fatalError("There isn't such section")
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var todoItem: ToDoItem

        switch indexPath.section {
        case 0:
            todoItem = todos[indexPath.row]
        case 1:
            todoItem = finished[indexPath.row]
        default:
            fatalError("There isn't such section")
        }

        let realm = try! Realm()
        try! realm.write {
            todoItem.finished = !todoItem.finished
        }

        tableView.reloadData()
    }
    
}


extension ViewController: AddViewControllerDelegate {
    
    func didFinishTyping(text: String?) {
        guard let text = text else {
            return
        }
        
        if text.utf16.count > 0 {
            let newToDoItem = ToDoItem()
            newToDoItem.name = text
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(newToDoItem)
            }
            tableView.reloadData()
        }
    }
    
}
