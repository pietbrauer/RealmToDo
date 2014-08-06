import UIKit
import Realm

class ViewController: UITableViewController, AddViewControllerDelegate {
    var todos: RLMArray {
        get {
            return ToDoItem.allObjects()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        setupNavigationBar()
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonAction")
    }

    func addButtonAction() {
        let addViewController = AddViewController(nibName: nil, bundle: nil)
        addViewController.delegate = self
        let navController = UINavigationController(rootViewController: addViewController)
        presentViewController(navController, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return Int(todos.count)
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as UITableViewCell

        let todoItem = todos.objectAtIndex(UInt(indexPath.row)) as ToDoItem
        cell.textLabel.text = todoItem.name

        return cell
    }

    func didFinishTypingText(typedText: String?) {
        if typedText?.utf16Count > 0 {
            let newTodoItem = ToDoItem()
            newTodoItem.name = typedText!

            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            realm.addObject(newTodoItem)
            realm.commitWriteTransaction()
            tableView.reloadData()
        }
    }
}

