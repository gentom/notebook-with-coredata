//
//  DisplayNotesViewController.swift
//  notebook
//
//  Created by Gento Morikawa on 2017/08/06.
//  Copyright © 2017年 gentom. All rights reserved.
//

import UIKit


//新しいノートの作成、既存のノートの変更
class DisplayNoteViewController: UIViewController {

    @IBOutlet weak var noteContentTextView: UITextView!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        /* 
         noteプロパティの値をアンラップし、実際の値をnoteという名前のローカル変数
         に格納するために、オプションのバインディング手法を使用。
        */
        if let note = note {
            /* 
             noteプロパティがnilでない場合にのみ実行される。
             テキストフィールドとテキストビューのプロパティをnoteの
             タイトルと内容にそれぞれ設定。
            */
            noteTitleTextField.text = note.title
            noteContentTextView.text = note.content
        } else {
            /*
             noteプロパティがnilの場合に実行される。
             新しいノートを作成する際に呼ばれる。
             テキストフィールドとテキストビューを空の文字列に設定し、
             ユーザーが新しいノートに入力できるようにする。
            */
            noteTitleTextField.text = ""
            noteContentTextView.text = ""
        }
        
        /*
         ＊下記のコードは上記の if let / else と同じ意味
         noteTitleTextField.text = note?.title ?? ""
         noteContentTextView.text = note?.content ?? ""
        */
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            //ノートオブジェクトが存在すれば更新し、変更されたオブジェクトを保存する。
            // noteのプロパティがnilの場合は、ノートが新規生成される。
            // この判定は Nil Coalescing Operator で行っている。
            // ?? -> Nil Coalescing Operator
            let note = self.note ?? CoreDataHelper.newNote()
            note.title = noteTitleTextField.text ?? ""
            note.content = noteContentTextView.text ?? ""
            CoreDataHelper.saveNote()
        }
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let notesTableViewController = segue.destination as! NotesTableViewController
        if segue.identifier == "save" {
            if let note = note {
                /*
                 noteのプロパティがnilでない場合(ノートのタイトルと内容を更新するだけで良い場合)、実行される。
                */
                note.title = noteTitleTextField.text ?? ""
                note.content = noteContentTextView.text ?? ""
                // データをリロードするようテーブルビューに指示。
                // これにより、作成した既存ノートの編集内容がノート一覧に反映される。
                notesTableViewController.tableView.reloadData()
            } else {
                // noteのプロパティがnilであれば実行される。(ノートが新規生成される)
                let newNote = Note()
                newNote.title = noteTitleTextField.text ?? ""
                newNote.content = noteContentTextView.text ?? ""
                notesTableViewController.notes.append(newNote)
            }
        }
    }
    */
    
}
