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
            // ?? -> Nil Coalescing Operator
            let note = self.note ?? CoreDataHelper.newNote()
            note.title = noteTitleTextField.text ?? ""
            note.content = noteContentTextView.text ?? ""
            CoreDataHelper.saveNote()
        }
    }
    
}
