//
//  AKWhiteNoise.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

/**  */
public class AKWhiteNoise: AKNode {

    // MARK: - Properties

    private var internalAU: AKWhiteNoiseAudioUnit?
    private var token: AUParameterObserverToken?

    private var amplitudeParameter: AUParameter?

    /** Amplitude. (Value between 0-1). */
    public var amplitude = 1.0 {
        didSet {
            amplitudeParameter?.setValue(Float(amplitude), originator: token!)
        }
    }

    // MARK: - Initializers

    /** Initialize this noise node */
    public init(amplitude: Double = 1.0) {
        self.amplitude = amplitude
        super.init()

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Generator
        description.componentSubType      = 0x776e6f7a /*'wnoz'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKWhiteNoiseAudioUnit.self,
            asComponentDescription: description,
            name: "Local AKWhiteNoise",
            version: UInt32.max)

        AVAudioUnit.instantiateWithComponentDescription(description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitGenerator = avAudioUnit else { return }

            self.output = avAudioUnitGenerator
            self.internalAU = avAudioUnitGenerator.AUAudioUnit as? AKWhiteNoiseAudioUnit
            AKManager.sharedInstance.engine.attachNode(self.output!)
        }

        guard let tree = internalAU?.parameterTree else { return }

        amplitudeParameter = tree.valueForKey("amplitude") as? AUParameter

        token = tree.tokenByAddingParameterObserver {
            address, value in

            dispatch_async(dispatch_get_main_queue()) {
                if address == self.amplitudeParameter!.address {
                    self.amplitude = Double(value)
                }
            }
        }
        amplitudeParameter?.setValue(Float(amplitude), originator: token!)
    }
}
