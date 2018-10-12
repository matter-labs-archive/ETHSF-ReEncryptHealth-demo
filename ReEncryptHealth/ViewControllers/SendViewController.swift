//
//  SendViewController.swift
//  ReEncryptHealth
//
//  Created by Anton Grigorev on 06.10.2018.
//  Copyright © 2018 Anton Grigorev. All rights reserved.
//

import UIKit
import HealthKit

class SendViewController: UITableViewController {
    
    public var data: [UInt8]? = nil
    public var decKey: Data? = nil
    
    private enum ProfileSection: Int {
        case data
        case sendToContact
        case sendToMyself
    }
    
    @IBOutlet weak var dataLabel: UILabel!
    
    private func updateLabels() {
        if let data = self.data {
            if let result = String(bytes: data, encoding: String.Encoding.ascii) {
                 dataLabel.text = result
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
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
            vc.decKey = self.decKey
        }
    }
}
