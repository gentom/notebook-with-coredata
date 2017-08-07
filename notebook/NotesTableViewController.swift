//
//  NotesTableViewController.swift
//  notebook
//
//  Created by Gento Morikawa on 2017/08/06.
//  Copyright © 2017年 gentom. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    /*
     notesプロパティが変更されるたびに、すべてのデータをリロードするように
     didSetプロパティオブザーバを用いてテーブルビューに通知
    */
    var notes = [Note]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = CoreDataHelper.retrieveNotes()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // 表示すべきセルの数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // テーブルの特定の行に対して、表示すべきcellを返す
    // indexPathは、作成するcellがデーブルビュー内のどのセクションと行に属するかを示す
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //テーブルビューに表示される実際のcellをフェッチしている
        //ダウンキャスト <- NotesTableViewCellがUITableViewCellのサブクラスであるため機能する
        //コンパイラに具体的な種類のUITableViewCellを返すことを指示する
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesTableViewCell", for: indexPath) as! NotesTableViewCell
        
        // indexPathは、cellForRowに渡された引数であり、テーブルビューがセルをどの行に表示するのかを示す
        // indexPathのrowプロパティにアクセスし、検索する。
        let row = indexPath.row
        
        let note = notes[row]
        
        cell.noteTitleLabel.text = note.title
        
        
        return cell
    }
    
    
    // commitEditingStyle : forRowAt indexPath: により、テーブルビューに追加の編集モードを有効にする
    // cellを左スワイプした際に削除オプションが表示される
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // editingStyleが.deleteであるかどうかを調べる
        if editingStyle == .delete {
            
            //CoreDataHelper.swiftで定義したメソッドを利用して、CoreDataからノートを削除する。
            //indexPath.rowを使用して、選択されたノート(row)を削除する。
            CoreDataHelper.delete(note: notes[indexPath.row])
            
            //notesプロパティを更新して、変更を反映させる。
            notes = CoreDataHelper.retrieveNotes()
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayNote" {
                print("Table view cell tapped")
                
                // すべてのテーブルビューは、indexPathForSelecedRowというプロパティを持っている。
                // ユーザーがテーブルビューからcellを選択した場合、特定のcellのindexPathにアクセス可能
                // indexPathにはsection,rowのプロパティがあり、選択したテーブルビューのcellをマッピングする
                // データモデル(ここではnotes配列)に関連付けることができる。
                let indexPath = tableView.indexPathForSelectedRow!
                
                // テーブルビューにはsectionが1つしかないため、対応するindexPathのrowプロパティを使用して
                // 各cellを一意に識別できる。
                // indexPath.rowで、タッチされたcellに対応するnotes配列からノートを取り出す。
                let note = notes[indexPath.row]
                
                // ダウンキャスト
                // segueのdestinationプロパティを使用して、DispalyNoteViewControllerにアクセス
                let displayNoteViewController = segue.destination as! DisplayNoteViewController
                
                // DisplayNoteViewControllerのnoteプロパティを、ユーザーがタッチしたcellに対応するnoteに設定
                displayNoteViewController.note = note
                
            } else if identifier == "addNote" {
                print("+ button tapped")
            }
        }
    }
    
    @IBAction func unwindToNotesViewController(_ segue: UIStoryboardSegue) {
        self.notes = CoreDataHelper.retrieveNotes()
    }
    
    
}
