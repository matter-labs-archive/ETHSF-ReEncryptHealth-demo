//
//  UmbralService.swift
//  ReEncryptHealth
//
//  Created by Anton Grigorev on 10.10.2018.
//  Copyright © 2018 Anton Grigorev. All rights reserved.
//

import Foundation
import EllipticSwift
import BigInt
import CryptoSwift

class UmbralService {
    
    private func hashFunc(_ data: Data) -> Data {
        return data.sha3(.keccak256)
    }
    
    private func kdf(_ data: Data) -> Data {
        return data.sha3(.keccak512)
    }
    
    public func getUmbralParams() -> UmbralParameters<NaivePrimeField<U256>>? {
        let curve = EllipticSwift.secp256k1Curve
//        let curve = EllipticSwift.bn256Curve
        let generatorX = BigUInt("79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798", radix: 16)!
        let generatorY = BigUInt("483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8", radix: 16)!
        do {
            let params = try UmbralParameters(curve: curve,
                                               generator: (generatorX, generatorY),
                                               hashFunction: hashFunc,
                                               kdf: kdf)
            return params
        } catch {
            print(error)
            return nil
        }
    }
    
    public func getKeys(params: UmbralParameters<NaivePrimeField<U256>>) -> (signKey: Data, decKey: Data)? {
        do {
            let threshold = 5
            let delegatorKey = try UmbralKey(params: params)
            let delegateeKey = try UmbralKey(params: params)
            let res = try Encapsulator.encapsulate(parameters: params, delegatorKey: delegatorKey)
            let capsule = res.capsule
            let symKey = res.symmeticKey
            let fragments = try RekeyGenerator.generateRekeyFragments(parameters: params, delegatorKey: delegatorKey, delegateeKey: delegateeKey, numFragments: 20, threshold: threshold)
            let capsuleFragments = try fragments!.map { (fragment) throws -> CapsuleFragment<UmbralParameters<NaivePrimeField<U256>>, NaivePrimeField<U256>> in
                return try Reencapsulator.reencapsulate(parameters: params, capsule: capsule, fragment: fragment)
            }
            let fragmentsSlice = Array(capsuleFragments[0 ..< threshold])
            delegatorKey.bnKey = nil
            let decKey = try Reencapsulator.decapsulateFragments(parameters: params, capsuleFragments: fragmentsSlice, delegatorKey: delegatorKey, delegateeKey: delegateeKey)
            return (signKey: symKey, decKey: decKey)
        } catch {
            print(error)
            return nil
        }
    }
    
    public func encrypt(signKey: Data, message: Array<UInt8>) -> [UInt8]? {
        do {
            let key = [UInt8](signKey)
            let left = Array(key.prefix(upTo: key.count/2))
            let right = Array(key.suffix(from: key.count/2))
//            let key = BigUInt(signKey)
//            print(key.bitWidth)
//            print(key.bitWidth/2)
//            let width = key.bitWidth/2
//            let left = String(key >> width)
//            let right = String((key >> width) << width)
//            let encrypted = try ChaCha20(key: left, iv: right).encrypt(message)
            
            let gcm = GCM(iv: right, mode: .combined)
            let aes = try AES(key: left, blockMode: gcm, padding: .noPadding)
            let encrypted = try aes.encrypt(message)
            return encrypted
            
        } catch {
            return nil
        }
    }
    
    public func decrypt(decKey: Data, encrypted: [UInt8]) -> [UInt8]? {
        do {
            let key = [UInt8](decKey)
            let left = Array(key.prefix(upTo: key.count/2))
            let right = Array(key.suffix(from: key.count/2))
            let gcm = GCM(iv: right, mode: .combined)
            let aes = try AES(key: left, blockMode: gcm, padding: .noPadding)
            //let decrypted = try ChaCha20(key: left, iv: right).decrypt(encrypted)
            let decrypted = try aes.decrypt(encrypted)
            return decrypted
        } catch {
            return nil
        }
    }
    
}
