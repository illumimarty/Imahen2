//
//  MetalKernel.swift
//  Imahen2
//
//  Created by Marty Nodado on 9/22/23.
//

import Foundation
import CoreImage

class ImahenMetalKernel: CIImageProcessorKernel {
    static let device: MTLDevice? = MTLCreateSystemDefaultDevice()
    static var computePipelineState: MTLComputePipelineState?
    var metalFunctionName: String
    
    override init() {
        metalFunctionName = ""
    }
    
    init(_ functionName: String!) {
        metalFunctionName = functionName
    }
    
    func setMetalScheme(to scheme: String) {
        metalFunctionName = scheme
    }
    
    func setupKernel() -> Bool? {
        if ImahenMetalKernel.device != nil {
            guard let defaultLibrary = ImahenMetalKernel.device?.makeDefaultLibrary() else { return nil }
            guard let kernelFunction = defaultLibrary.makeFunction(name: metalFunctionName) else { return nil }
            
            do {
                ImahenMetalKernel.computePipelineState = try ImahenMetalKernel.device?.makeComputePipelineState(function: kernelFunction)
            } catch {
                print("Failed to create compute pipeline state: \(error.localizedDescription)")
                return false
            }
        }
        return true
    }
    
    override class var outputIsOpaque: Bool {
        return true
    }
    
    override class func process(with inputs: [CIImageProcessorInput]?, arguments: [String : Any]?, output: CIImageProcessorOutput) throws {
        let kernel = ImahenMetalKernel()
        kernel.setMetalScheme(to: arguments!["functionName"] as! String)
        
        if kernel.setupKernel() != nil {
            if ImahenMetalKernel.computePipelineState == nil { return }
        }
        
        let commandQueue = self.device?.makeCommandQueue()
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else { return }
        commandBuffer.label = "EDKernel"
        
        // Kernel information
        guard
            let input: CIImageProcessorInput = inputs?.first,
            let srcTexture = input.metalTexture,
            let dstTexture = output.metalTexture else {
            return
        }
        
        // Mapping pixels to threadgroups
        let blockDim = 8
        
        var numBlocksInWidth = srcTexture.width / blockDim
        if (srcTexture.width % blockDim != 0) {
            numBlocksInWidth += 1
        }
        
        var numBlocksInHeight = srcTexture.height / blockDim
        if (srcTexture.height % blockDim != 0) {
            numBlocksInHeight += 1
        }
        
        let threadsPerThreadgroup = MTLSize(width: blockDim, height: blockDim, depth: 1)
        let threadsPerGrid = MTLSizeMake(numBlocksInWidth, numBlocksInHeight, 1)
        
        // Creating the ComputeEncoder
        if let computeEncoder = commandBuffer.makeComputeCommandEncoder() {
            computeEncoder.setComputePipelineState(ImahenMetalKernel.computePipelineState!)
            computeEncoder.setTextures([srcTexture, dstTexture], range: 0..<2)
            computeEncoder.dispatchThreadgroups(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
            computeEncoder.endEncoding()
            
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            print("Done!")
        }
    }
}
