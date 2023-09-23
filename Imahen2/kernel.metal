//
//  kernel.metal
//  core-image-demo-uikit
//
//  Created by Marty Nodado on 7/27/23.
//

#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h> // includes CIKernelMetalLib.h

extern "C" {
    namespace coreimage {
                
        // Edge Detection Compute Kernel
        constant half3x3 sobelX = half3x3(-1, 0, 1,
                                          -2, 0, 2,
                                          -1, 0, 1);
                                              
        constant half3x3 sobelY = half3x3(-1, -2, -1,
                                           0, 0, 0,
                                           1, 2, 1);

        kernel void sobelEdgeDetect(texture2d<half, access::read> inputTexture [[texture(0)]],
                                    texture2d<half, access::write> outputTexture [[texture(1)]],
                                    uint2 gid [[thread_position_in_grid]]) {
            
            half4 sumX = half4(0);
            half4 sumY = half4(0);

            for (int y = -1; y <= 1; y++) {
                for (int x = -1; x <= 1; x++) {
                    half4 color = inputTexture.read(gid + uint2(x, y));
                    sumX += color * sobelX[y + 1][x + 1];
                    sumY += color * sobelY[y + 1][x + 1];
                }
            }

            half magnitude = sqrt(sumX.x * sumX.x + sumY.x * sumY.x);

            outputTexture.write(half4(magnitude), gid);
        }
    }
}






