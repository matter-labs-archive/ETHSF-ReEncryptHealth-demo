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
    
    public var data: [UInt8]? = nil
    public var decKey: Data? = nil
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var biologicalSexLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var WeightLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    private let umbralService = UmbralService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateLabels(with sequence: [String.SubSequence]) {
        let age = sequence[0]
        ageLabel.text = "\(age)"
        
        let biologicalSex = sequence[1]
        biologicalSexLabel.text = "\(biologicalSex)"
        
        let bloodType = sequence[2]
        bloodTypeLabel.text = "\(bloodType)"
        
        WeightLabel.text = "\(sequence[3]) \(sequence[4])"
        
        let height = sequence[5]
        heightLabel.text = "\(height)"
    }
    
    private func decryptData() {
        guard let decKey = self.decKey else {return}
        guard let data = self.data else {return}
        guard let decryptedData = umbralService.decrypt(decKey: decKey, encrypted: data) else {return}
        guard let decryptedString = String(bytes: decryptedData, encoding: .utf8) else { return }
        self.dataLabel.text = decryptedString
        let decryptedElements = decryptedString.split(separator: " ")
        
        updateLabels(with: decryptedElements)
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
