import RealmSwift

class ToDoItem: Object {
    dynamic var name = ""
    dynamic var finished = false

    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
