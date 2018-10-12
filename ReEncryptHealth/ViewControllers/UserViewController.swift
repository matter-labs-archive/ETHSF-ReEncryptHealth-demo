//
//  UserViewController.swift
//  ReEncryptHealth
//
//  Created by Anton Grigorev on 05.10.2018.
//  Copyright © 2018 Anton Grigorev. All rights reserved.
//

import UIKit
import HealthKit

class UserViewController: UITableViewController {
    
    private enum ProfileSection: Int {
        case mainInfo = 0
        case readHealthKitData = 1
        case send = 2
    }
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var biologicalSexLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var WeightLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    private var encryptedData: [UInt8]? = nil
    private var decKey: Data? = nil
    
    private let userProfile = UserProfile()
    private let umbralService = UmbralService()
    
    private func updateHealthInfo(completion: @escaping ()->()) {
        loadAndDisplayAgeSexAndBloodType()
        loadAndDisplayMostRecentWeight()
        loadAndDisplayMostRecentHeight()
        completion()
    }
    
    private func loadAndDisplayAgeSexAndBloodType() {
        do {
            let userAgeSexAndBloodType = try UserDataStore.getAgeSexAndBloodType()
            userProfile.age = userAgeSexAndBloodType.age
            userProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
            userProfile.bloodType = userAgeSexAndBloodType.bloodType
            updateLabels()
        } catch let error {
            self.displayAlert(for: error)
        }

    }
    
    private func updateLabels() {
        if let age = userProfile.age {
            ageLabel.text = "\(age)"
        }
        
        if let biologicalSex = userProfile.biologicalSex {
            biologicalSexLabel.text = biologicalSex.byString
        }
        
        if let bloodType = userProfile.bloodType {
            bloodTypeLabel.text = bloodType.byString
        }
        
        if let weight = userProfile.weightInKilograms {
            let weightFormatter = MassFormatter()
            weightFormatter.isForPersonMassUse = true
            WeightLabel.text = weightFormatter.string(fromKilograms: weight)
        }
        
        if let height = userProfile.heightInMeters {
            let heightFormatter = LengthFormatter()
            heightFormatter.isForPersonHeightUse = true
            heightLabel.text = heightFormatter.string(fromMeters: height)
        }
        
        self.view.isUserInteractionEnabled = true
    }
    
    private func encryptData(completion: @escaping ()->()) {
        let dataInString = "\(ageLabel.text ?? "Unknown") \(biologicalSexLabel.text ?? "Unknown") \(bloodTypeLabel.text ?? "Unknown") \(WeightLabel.text ?? "Unknown") \(heightLabel.text ?? "Unknown")"
        let dataInUTF8 = dataInString.utf8
        let arrayData = [UInt8](dataInUTF8)
        guard let umbralParams = umbralService.getUmbralParams() else {return}
        guard let keys = umbralService.getKeys(params: umbralParams) else {return}
        guard let encryptedData = umbralService.encrypt(signKey: keys.signKey, message: arrayData) else {return}
        self.encryptedData = encryptedData
        self.decKey = keys.decKey
        completion()
    }
    
    private func loadAndDisplayMostRecentHeight() {
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
        
        UserDataStore.getMostRecentSample(for: heightSampleType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                    self.displayAlert(for: error)
                }
                
                return
            }
            
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self.userProfile.heightInMeters = heightInMeters
            self.updateLabels()
        }
    }
    
    private func loadAndDisplayMostRecentWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        
        UserDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                    self.displayAlert(for: error)
                }
                return
            }
            
            let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self.userProfile.weightInKilograms = weightInKilograms
            self.updateLabels()
        }
    }
    
    private func displayAlert(for error: Error) {
        
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "O.K.",
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = ProfileSection(rawValue: indexPath.section) else {
            fatalError("A ProfileSection should map to the index path's section")
        }
        
        switch section {
        case .readHealthKitData:
            self.view.isUserInteractionEnabled = false
            updateHealthInfo {
                
            }
        case .send:
            self.encryptData { [weak self] in
                guard let _ = self?.encryptedData else {return}
                self?.performSegue(withIdentifier: "reencrypt", sender: self)
            }
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SendViewController {
            vc.data = self.encryptedData
            vc.decKey = self.decKey
        }
    }
}
