//
//  ViewController.swift
//  Core Data Demo
//
//  Created by Shien on 2022/8/18.
//

import UIKit

class ViewController: UIViewController {
    var items = [ShoppingItem]()
    @IBOutlet weak var itemTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        readItems()
        itemTableView.reloadData()
    }
    
    func save() {
        do {
            try context.save()
        }
        catch {
            fatalError()
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        var controller = UIAlertController(title: "新增", message: nil, preferredStyle: .alert)
        for _ in 0...1 {
            controller.addTextField()
        }
        controller.addAction(UIAlertAction(title: "確定", style: .default, handler: { action in
            if let textFields = controller.textFields, !textFields.first!.text!.isEmpty, !textFields.last!.text!.isEmpty {
                self.createItem(itemName: (textFields.first!.text)!, itemPrice: (textFields.last!.text)!)
                self.itemTableView.reloadData()
            } else {
                controller = UIAlertController(title: "尚未完成", message: "請填完所有空格", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "確認", style: .default))
                self.present(controller, animated: true)
            }
        }))
        controller.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(controller, animated: true)
    }
}

//CRUD
extension ViewController {
    func createItem(itemName: String, itemPrice: String) {
        let newItem = ShoppingItem(context: context)
        newItem.name = itemName
        newItem.price = itemPrice
        items.append(newItem)
        save()
    }
    
    func readItems() {
        do {
            try items = context.fetch(ShoppingItem.fetchRequest())
        }
        catch {
            fatalError()
        }
    }
    
    func updateItem(itemName: String, itemPrice: String, at index: Int) {
        items[index].name = itemName
        items[index].price = itemPrice
        save()
    }
    
    func deleteItem(at index: Int) {
        context.delete(items[index])
        save()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemTableViewCell else { return ItemTableViewCell() }
        cell.nameLabel.text = items[indexPath.row].name
        cell.priceLabel.text = items[indexPath.row].price
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "編輯", style: .default, handler: { _ in
            let
            controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            for i in 0...1 {
                controller.addTextField()
                if i == 0 {
                    controller.textFields![i].text = self.items[indexPath.row].name!
                } else {
                    controller.textFields![i].text = self.items[indexPath.row].price!
                }
            }
            controller.addAction(UIAlertAction(title: "儲存", style: .default, handler: { _ in
                if let textFields = controller.textFields, !(textFields.first!.text)!.isEmpty, !(textFields.last!.text)!.isEmpty {
                    self.updateItem(itemName: (textFields.first!.text)!, itemPrice: (textFields.last!.text)!, at: indexPath.row)
                    self.itemTableView.reloadData()
                } else {
                    let controller = UIAlertController(title: "編輯尚未完成", message: "請填入所有格子", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "確認", style: .default))
                    self.present(controller, animated: true)
                }
            }))
            controller.addAction(UIAlertAction(title: "取消", style: .cancel))
            self.present(controller, animated: true)
        }))
        
        controller.addAction(UIAlertAction(title: "刪除", style: .default, handler: { _ in
            self.deleteItem(at: indexPath.row)
            self.itemTableView.reloadData()
        }))
        controller.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(controller, animated: true)
    }
}
