//
//  DecryptViewController.swift
//  ReEncryptHealth
//
//  Created by Anton Grigorev on 06.10.2018.
//  Copyright © 2018 Anton Grigorev. All rights reserved.
//

import UIKit

class DecryptViewController: UITableViewController {
    
    private enum ProfileSection: Int {
        case data = 0
        case mainInfo = 1
        case decrypt = 2
    }
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var biologicalSexLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var WeightLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    var data: String? = nil
    var age: String? = nil
    var biologicalSex: String? = nil
    var bloodType: String? = nil
    var weight: String? = nil
    var height: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLabel.text = data
    }
    
    private func updateLabels() {
        if let age = self.age {
            ageLabel.text = "\(age)"
        }
        
        if let biologicalSex = self.biologicalSex {
            biologicalSexLabel.text = biologicalSex
        }
        
        if let bloodType = self.bloodType {
            bloodTypeLabel.text = bloodType
        }
        
        if let weight = self.weight {
            WeightLabel.text = weight
        }
        
        if let height = self.height {
            heightLabel.text = height
        }
        
        if let data = self.data {
            dataLabel.text = data
        }
    }
    
    private func decryptData() {
        self.age = "24"
        self.biologicalSex = "Male"
        self.height = "Unknown"
        self.weight = "76 кг"
        self.bloodType = "A-"
        updateLabels() 
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = ProfileSection(rawValue: indexPath.section) else {
            fatalError("A ProfileSection should map to the index path's section")
        }
        
        switch section {
        case .decrypt:
            decryptData()
        default: break
        }
    }
    
}
