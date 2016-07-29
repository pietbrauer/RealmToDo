import Realm

class ToDoItem: RLMObject {
    dynamic var name = ""
    dynamic var finished = false

    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
