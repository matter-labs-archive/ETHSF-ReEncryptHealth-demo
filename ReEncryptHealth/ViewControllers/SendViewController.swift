//
//  SendViewController.swift
//  ReEncryptHealth
//
//  Created by Anton Grigorev on 06.10.2018.
//  Copyright © 2018 Anton Grigorev. All rights reserved.
//

import UIKit

class SendViewController: UITableViewController {
    
    var data: String? = nil
    
    private enum ProfileSection: Int {
        case data
        case sendToContact
        case sendToMyself
    }
    
    @IBOutlet weak var dataLabel: UILabel!
    
    private func updateLabels() {
        if let data = self.data {
            dataLabel.text = data
        }
    }
    
    private func reencryptData() {
        data = "nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3"
        updateLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reencryptData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = ProfileSection(rawValue: indexPath.section) else {
            fatalError("A ProfileSection should map to the index path's section")
        }
        
        switch section {
        case .sendToContact: break
            //
        case .sendToMyself:
            self.performSegue(withIdentifier: "decryptForMyself", sender: self)
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DecryptViewController {
            vc.data = self.data
        }
    }
}
