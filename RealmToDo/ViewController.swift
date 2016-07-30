import UIKit
import Realm

class ViewController: UITableViewController, AddViewControllerDelegate {
    var todos: RLMResults {
        get {
            let predicate = NSPredicate(format: "finished == false", argumentArray: nil)
            return ToDoItem.objectsWithPredicate(predicate)
        }
    }

    var finished: RLMResults {
        get {
            let predicate = NSPredicate(format: "finished == true", argumentArray: nil)
            return ToDoItem.objectsWithPredicate(predicate)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        setupNavigationBar()
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ViewController.addButtonAction))
    }

    func addButtonAction() {
        let addViewController = AddViewController(nibName: nil, bundle: nil)
        addViewController.delegate = self
        let navController = UINavigationController(rootViewController: addViewController)
        presentViewController(navController, animated: true, completion: nil)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Int(todos.count)
        case 1:
            return Int(finished.count)
        default:
            return 0
        }

    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "To do"
        case 1:
            return "Finished"
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as UITableViewCell
        let index = UInt(indexPath.row)

        switch indexPath.section {
        case 0:
            if let todoItem = todos.objectAtIndex(index) as? ToDoItem {
                let attributedText = NSMutableAttributedString(string: todoItem.name)
                attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 0, range: NSMakeRange(0, attributedText.length))
                cell.textLabel?.attributedText = attributedText
            }
        case 1:
            if let todoItem = finished.objectAtIndex(index) as? ToDoItem {
                let attributedText = NSMutableAttributedString(string: todoItem.name)
                attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributedText.length))
                cell.textLabel?.attributedText = attributedText
            }
        default:
            fatalError("What the fuck did you think ??")
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        try! realm.transactionWithBlock() {
            todoItem?.finished = !todoItem!.finished
        }

        tableView.reloadData()
    }

    func didFinishTypingText(typedText: String?) {
        if typedText?.utf16.count > 0 {
            let newTodoItem = ToDoItem()
            newTodoItem.name = typedText!

            let realm = RLMRealm.defaultRealm()
            try! realm.transactionWithBlock() {
                realm.addObject(newTodoItem)
            }
            tableView.reloadData()
        }
    }
}
