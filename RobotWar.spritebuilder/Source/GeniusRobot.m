//
//  GeniusRobot.m
//  RobotWar
//
//  Created by Melanie H. on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GeniusRobot.h"

typedef NS_ENUM(NSInteger, RobotState) {
    RobotStateDefault,
    RobotStateTurnaround,
    RobotStateFiring,
    RobotStateSearching
};

@implementation GeniusRobot {
    RobotState _currentRobotState;
    
    CGPoint _lastKnownPosition;
    CGFloat _lastKnownPositionTimestamp;
}

- (void)run {
    while (true) {
        if (_currentRobotState == RobotStateFiring) {
            
            if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 1.f) {
                _currentRobotState = RobotStateSearching;
            } else {
                CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                if (angle >= 0) {
                    [self turnGunRight:abs(angle)];
                } else {
                    [self turnGunLeft:abs(angle)];
                }
                [self shoot];
            }
        }
        
        if (_currentRobotState == RobotStateSearching) {
            CGFloat angle = CCRANDOM_0_1()*90;
            //[self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
            if (angle >= 0) {
                [self turnGunRight:abs(angle)];
                [self shoot];
            } else {
                [self turnGunLeft:abs(angle)];
                [self shoot];
            }
        }
        
        if (_currentRobotState == RobotStateDefault) {
            [self moveBack:100];
        }
    }
}

- (void)bulletHitEnemy:(Bullet *)bullet {
    [self shoot];
    // There are a couple of neat things you could do in this handler
}

- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
    if (_currentRobotState != RobotStateFiring) {
        [self cancelActiveAction];
    }
    
    _lastKnownPosition = position;
    _lastKnownPositionTimestamp = self.currentTimestamp;
    _currentRobotState = RobotStateFiring;
}

- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
    [self cancelActiveAction];
    
    if (RobotWallHitDirectionFront) {
        _currentRobotState = RobotStateSearching;
    }
    else if (RobotWallHitDirectionBack) {
        _currentRobotState = RobotStateSearching;
    }
    /* if (_currentRobotState != RobotStateTurnaround) {
        [self cancelActiveAction];
        
        RobotState previousState = _currentRobotState;
        _currentRobotState = RobotStateTurnaround;
        
        // always turn to head straight away from the wall
        if (angle >= 0) {
            [self turnRobotLeft:abs(angle)];
        } else {
            [self turnRobotRight:abs(angle)];
            
        }
        
        [self moveAhead:20];
        
        _currentRobotState = previousState;
    }*/
}

@end
