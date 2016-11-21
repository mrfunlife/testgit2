//
//  FetchViewController.swift
//  BackgroundModes
//
//  Created by Fun Life on 11/16/16.
//  Copyright © 2016 FunLife. All rights reserved.
//

import UIKit

class FetchViewController: UIViewController {

    private var time: Date?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter
    }()
    
    @IBAction func btnUpdate(_ sender: Any) {
        fectch { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.updateUI()
        }

    }
    
    func fectch(_completion: () -> Void) {
    time = Date()
    _completion()
    }
    
    
    func updateUI(){
        guard   lblUpdateTime != nil else {
            return
        }
        
        if let time = time {
            lblUpdateTime.text = dateFormatter.string(from: time)
        }else {
            lblUpdateTime.text = "Not Yet Updated"
        }
    }

    @IBOutlet weak var lblUpdateTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
