import UIKit
import Realm

class ViewController: UITableViewController, AddViewControllerDelegate {
    var todos: RLMArray {
        get {
            let predicate = NSPredicate(format: "finished == false", argumentArray: nil)
            return ToDoItem.objectsInRealm(RLMRealm.defaultRealm(), withPredicate: predicate)
        }
    }

    var finished: RLMArray {
        get {
            let predicate = NSPredicate(format: "finished == true", argumentArray: nil)
            return ToDoItem.objectsInRealm(RLMRealm.defaultRealm(), withPredicate: predicate)
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

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Int(todos.count)
        case 1:
            return Int(finished.count)
        default:
            return 0
        }

    }

    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        switch section {
        case 0:
            return "To do"
        case 1:
            return "Finished"
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as UITableViewCell

        switch indexPath.section {
        case 0:
            let todoItem = todos.objectAtIndex(UInt(indexPath.row)) as ToDoItem
            var attributedText = NSMutableAttributedString(string: todoItem.name)
            attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 0, range: NSMakeRange(0, attributedText.length))
            cell.textLabel.attributedText = attributedText
        case 1:
            let todoItem = finished.objectAtIndex(UInt(indexPath.row)) as ToDoItem
            var attributedText = NSMutableAttributedString(string: todoItem.name)
            attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributedText.length))
            cell.textLabel.attributedText = attributedText
        default:
            fatalError("What the fuck did you think ??")
        }
        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var todoItem: ToDoItem?

        switch indexPath.section {
        case 0:
            todoItem = todos.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
        case 1:
            todoItem = finished.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
        default:
            fatalError("What the fuck did you think ??")
        }


        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        todoItem?.finished = !todoItem!.finished
        realm.commitWriteTransaction()

        tableView.reloadData()
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

