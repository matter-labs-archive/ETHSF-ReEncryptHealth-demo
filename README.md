## Inspiration
On ETHBerlin the Nucypher team has asked me to if their proxy re-encryption protocol can be implemented on mobile devices. By that time I've already started to implement a pure-Swift library (no C/C++ parts) for Elliptic curve arithmetics and pairings. On this hackathon, I've decided with the help of team members to start implementing their proxy re-encryption protocol Umbral as a demo for my library.

## What it does
Allows arbitrary EC arithmetics (not in extension fields yet) to be used on mobile devices with good speed and without a mess of C/C++ integrations, so making Umbral proxy re-encryption will be trivial once it's finished and polished

## How we **BUIDL** it
Part of the library was ready; now it required the following extensions
- Define curve over the abstract field that can operate on any wide unsigned integer type that has some properties
- Backport wide integers (UInt256/UInt512) for iOS devices. This library is universal for MacOS/iOS, but on MacOS it was using U256 implemented using AVX Intel processor instructions, so equivalent for iOS has to be backported (more precisely - polyfilled)
- Start implementing Umbral itself

## Challenges I ran into
- Implementing fast wide arithmetics is always a challenge
- For the ease of work with UInt256 some functionality had to be implemented for UInt512 (full multiplication UInt256 * UInt256 -> UInt512, modular reduction UInt512 -> UInt256)
- Arithmetics of UInt256/UInt512 has to be tested first to event start testing elliptic curve arithmetics

## Accomplishments that I'm proud of
- UInt256 is entirely valid except modular reduction (see next point)
- UInt512 is valid except of the division for some reason

## What I learned
- The naive implementation of wide integer types through arrays involves too many Copy-on-Write, so manual memory management is good if you know what you are doing 

## What's next for Keep your privacy with you
- Finish and polish a library (testing mainly + documentation)
- Finish and test Umbral
- Ideally, add a backed that does proxy re-encryption and sends notifications re-encryption requests to the mobile device to get a fresh re-encryption key


---



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
