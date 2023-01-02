import UIKit

class mainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "cell"
    var todoList = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadDataFromUserDefault()
    }

    @IBAction func tapAddButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Write down your todo.", message: nil, preferredStyle: .alert)
        let alertAddAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            guard let alertText = alert.textFields?.first?.text else { return }
            let todoInstance = Todo(title: alertText, done: false)
            self.todoList.append(todoInstance)
            
            let encoder = JSONEncoder()
            if let encodedArr = try? encoder.encode(self.todoList) {
                UserDefaults.standard.set(encodedArr, forKey: "todo_list_key")
            }
            self.tableView.reloadData()
        })
        
        let alertCancelAction = UIAlertAction(title: "Close", style: .destructive, handler: nil)
        alert.addAction(alertCancelAction)
        alert.addAction(alertAddAction)
        alert.addTextField()
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadDataFromUserDefault() {
        let decoder = JSONDecoder()
        if let decodedArr = UserDefaults.standard.object(forKey: "todo_list_key") as? Data {
            if let loadedArr = try? decoder.decode(Array<Todo>.self, from: decodedArr) {
                todoList = loadedArr
                debugPrint(loadedArr)
            }
        }
    }
}

extension mainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        cell.textLabel?.text = self.todoList[indexPath.row].title
        cell.backgroundColor = self.todoList[indexPath.row].done ? .blue : .clear
        cell.selectionStyle = .none
        return cell
    }
}

extension mainViewController: UITableViewDelegate {

}
