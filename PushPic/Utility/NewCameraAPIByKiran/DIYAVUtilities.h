//
//  DIYAVUtilities.h
//  DIYAV
//
//  Created by Jonathan Beilin on 1/22/13.
//  Copyright (c) 2013 DIY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface DIYAVUtilities : NSObject

+ (AVCaptureDevice *)cameraInPosition:(AVCaptureDevicePosition)position;
+ (BOOL)isPhotoCameraAvailable;
+ (BOOL)isVideoCameraAvailable;
+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;

+ (BOOL)getTorchStatusForCameraInPosition:(AVCaptureDevicePosition)position;
+ (void)setTorch:(BOOL)torch forCameraInPosition:(AVCaptureDevicePosition)position;
+ (BOOL)getFlashStatusForCameraInPosition:(AVCaptureDevicePosition)position;
+ (void)setFlash:(BOOL)flash forCameraInPosition:(AVCaptureDevicePosition)position;
+ (void)setHighISO:(BOOL)highISO forCameraInPosition:(AVCaptureDevicePosition)position;

+ (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates withFrame:(CGRect)frame withPreview:(AVCaptureVideoPreviewLayer *)preview withPorts:(NSArray *)ports;

+ (AVCaptureVideoOrientation)getAVCaptureOrientationFromDeviceOrientation;

+ (NSString *)createAssetFilePath:(NSString *)extension;
+ (uint64_t)getFreeDiskSpace;

@end
