//
//  HBPropertyInfo.h
//  HBCoreFramework
//
//  Created by knight on 16/4/4.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_OPTIONS(NSUInteger, HBTypeEncodingPropertyType) {
    HBTypeEncodingPropertyMask       = 0xFF,
    HBTypeEncodingUnkownType = 0,
    HBTypeEncodingPropertyRetain = 1,
    HBTypeEncodingPropertyCopy   = 1 << 1,
    HBTypeEncodingPropertyNonAtomic = 1 << 2,
    HBTypeEncodingPropertyReadOnly  = 1 << 3,
    HBTypeEncodingPropertyWeak     = 1 << 4,
    HBTypeEncodingPropertyDynamic   = 1 << 5,
    HBTypeEncodingPropertyGetter    = 1 << 6,
    HBTypeEncodingPropertySetter   = 1 << 7,
};

@interface HBPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *value;
@property (nonatomic, strong, readonly) Class clazz;
@property (nonatomic, assign, readonly) SEL getter;
@property (nonatomic, assign, readonly) SEL setter;
@property (nonatomic, assign, readonly)HBTypeEncodingPropertyType type;
@property (nonatomic, copy, readonly)NSString * iVarName;

- (instancetype)initWithProperty:(objc_property_t)property;
@end
