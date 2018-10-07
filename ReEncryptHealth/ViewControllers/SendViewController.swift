//
//  SendViewController.swift
//  ReEncryptHealth
//
//  Created by Anton Grigorev on 06.10.2018.
//  Copyright © 2018 Anton Grigorev. All rights reserved.
//

import UIKit

class SendViewController: UITableViewController {
    
    private enum ProfileSection: Int {
        case data
        case sendToContact
        case sendToMyself
    }
    
    
    private func updateLabels() {
    }
    
    private func loadAndDisplayData() {
        
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
        if let sendViewController = segue.destination as? DecryptViewController {
            
        }
    }
}
