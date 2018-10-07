# ReEncryptHealth

Safely sending private medical data, using threshold proxy re-encryption with Umbral

Initialized [@ETHSanFrancisco-hackathon](https://ethsanfrancisco.devpost.com/) by:

 * [shamatar](https://github.com/orgs/matterinc/people/shamatar) (Main developer: Umbral Swift library, TinyBigInt Swift library)
 * [BaldyAsh](https://github.com/BaldyAsh) (iOS application, TinyBigInt Swift library)

## What is it
- Native Swift application showing how to use our Umral proxy re-encryption library - [EllipticSwift](https://github.com/shamatar/ellipticswift):
  - Get your medical data from Apple
  - Encrypt it
  - Re-encrypt it and send to someone you trust
  - Secure and convenient
- Swift implementation of David Nuñez's threshold proxy re-encryption scheme: [Umbral](https://github.com/nucypher/umbral-doc/blob/master/umbral-doc.pdf).
Implemented with [TinyBigInt](https://github.com/matterinc/TinyBigIntSwift), it is a referential and open-source cryptography library
extending the traditional cryptological narrative of "Alice and Bob" by introducing a new actor,
*Ursula*, who has the ability to take secrets encrypted for Alice and *re-encrypt* them for Bob.

## Accomplishments that we're proud of
It works! Hooooray!!!

## What we learned
Umbral algorithm and how to work with Apples' medical data, how to write and how not to write Big Ints on Swift.

## What's next
- improve app - more medical data, more new Apple Watch features like ECG
- improve Umbral lib
- improve Big Int lib

## Big shout out to
[NuCypher team](www.nucypher.com) for their work on [open-source projects](https://github.com/nucypher) and the proxy re-encryption network!
