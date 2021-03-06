//
//  HBEntity.m
//  HBCoreFramework
//
//  Created by knight on 16/3/25.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBEntity.h"
#import "HBStorage.h"
#import "HBPropertyInfo.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HBEntityUtil.h"
@implementation HBEntity
static char * filerClassName(const char * sourceValue) {
    size_t len = strlen(sourceValue);
    char * value = malloc(sizeof(char *)*strlen(sourceValue-3));
    unsigned int i;
    unsigned int j = 0;
    for (i=0; i < len; i++) {
        char tmp = sourceValue[i];
        if ('@'!=tmp && '\"'!=tmp) {
            value[j++] = sourceValue[i];
        }
    }
    value[j]= '\0';
    return value;
}

static bool isSameClass(Class sourceClazz, Class desClazz) {
    if (strcmp(class_getName(sourceClazz), class_getName(desClazz))==0) {
        return YES;
    }else {
        //        if () {
        //            <#statements#>
        //        }
        return NO;
    }
}

+ (BOOL)boolValueWith:(NSString *)boolString {
    if (boolString && boolString.length > 0) {
        const char * lowercaseBoolString = boolString.lowercaseString.UTF8String;
        //只要不是no、false和0都返回YES
        if (strEqualTo("no", lowercaseBoolString) ||
            strEqualTo("false", lowercaseBoolString) ||
            strEqualTo("0", lowercaseBoolString)) {
            return NO;
        }else {
            return YES;
        }
    }
    return NO;
}

static bool isFoundationClass(Class clazz) {
    
    if (isSameClass(clazz ,[NSString class])) {
        return YES;
    }else if (isSameClass(clazz,[NSNumber class])){
        return YES;
    }else if (isSameClass(clazz,[NSData class])) {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)reverseTransferDic:(NSDictionary *)transferDic {
    if (!transferDic || transferDic.count <=0) {
        return transferDic;
    }else {
        NSMutableDictionary * reverseTransferDic = @{}.mutableCopy;
        [transferDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            reverseTransferDic[obj] = key;
        }];
        return reverseTransferDic;
    }
}


+ (instancetype)transferEntityWithObject:(id)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [self transferEntityWithDic:object];
    }else if ([object isKindOfClass:[NSArray class]]) {
        return [self transferEntityWithArray:object];
    }
    return [[self alloc] init];
}

+ (instancetype)transferEntityWithArray:(NSArray *)array {
    unsigned int outCount;
    NSDictionary * reverseTransferDic = nil;
    id instance = [[self alloc] init];
    
    if ([instance respondsToSelector:@selector(hb_transferDic)]) {
        reverseTransferDic = [self reverseTransferDic:[instance hb_transferDic]];
    }
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    if (outCount > 0) {
        for (unsigned int index = 0; index < outCount; index++) {
            struct objc_property * property = properties[index];
            const char * name =  property_getName(property);
            NSLog(@"%s",name);
            NSString * key = [NSString stringWithUTF8String:name];
            if ([[self hb_filerArray] containsObject:key]) {
                continue;
            }
            if (reverseTransferDic) {
                if (reverseTransferDic[key]) {
                    key = reverseTransferDic[key];
                }
            }
            HBPropertyInfo * propertyInfo = [[HBPropertyInfo alloc] initWithProperty:property];
            id data =[self entityArray:array withKey:key];
            if ([propertyInfo canSetValue]) {
                ((void (*)(id,SEL,id))(void *)objc_msgSend)(instance,propertyInfo.setter,data);
            }
            
        }
    }
    return instance;

}

+ (NSMutableArray *)entityArray:(NSArray *)array withKey:(NSString *)key{
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray * instanceArray = @[].mutableCopy;
        for (unsigned int index = 0; index<[array count]; index++) {
            if ([self conformsToProtocol:@protocol(HBEntityProtocol)] &&
                [self respondsToSelector:@selector(hb_objectClassForKeyDic)]) {
                NSDictionary * mapedKeyClass = [self hb_objectClassForKeyDic];
                if (mapedKeyClass) {
                    Class cls = mapedKeyClass[key];
                    if (cls && ![cls isSubclassOfClass:[NSNull class]]) {
                        id data = [cls transferEntityWithObject:array[index]];
                        [instanceArray addObject:data];
                    }
                }
            }
        }
        return instanceArray;
    }
    return nil;
}

+ (instancetype)transferEntityWithDic:(NSDictionary *)dic {
    unsigned int outCount;
    NSDictionary * reverseTransferDic = nil;
    id instance = [[self alloc] init];

    if ([instance respondsToSelector:@selector(hb_transferDic)]) {
        reverseTransferDic = [self reverseTransferDic:[instance hb_transferDic]];
    }
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    if (outCount > 0) {
        for (unsigned int index = 0; index < outCount; index++) {
            struct objc_property * property = properties[index];
            const char * name =  property_getName(property);
            NSLog(@"%s",name);
            NSString * key = [NSString stringWithUTF8String:name];
            if ([[self hb_filerArray] containsObject:key]) {
                continue;
            }
            if (reverseTransferDic) {
                if (reverseTransferDic[key]) {
                    key = reverseTransferDic[key];
                }
            }
            HBPropertyInfo * propertyInfo = [[HBPropertyInfo alloc] initWithProperty:property];
            Class clazz = propertyInfo.clazz;
            if ([clazz isSubclassOfClass:[NSArray class]]) {
                if ([self conformsToProtocol:@protocol(HBEntityProtocol)] &&
                    [self respondsToSelector:@selector(hb_objectClassForKeyDic)]) {
                    NSDictionary * mapedKeyClass = [self hb_objectClassForKeyDic];
                    if (mapedKeyClass) {
                        Class cls = mapedKeyClass[key];
                        if (cls && ![cls isSubclassOfClass:[NSNull class]]) {
                            clazz = cls;
                            id data = [self entityArray:dic[key] withKey:key];
                            if ([propertyInfo canSetValue]) {
                                ((void (*)(id,SEL,id))(void *)objc_msgSend)(instance,propertyInfo.setter,data);
                            }
                        }
                    }
                }
            }else if ([clazz conformsToProtocol:@protocol(HBEntityProtocol)]) {
                //自定义实体
                id data = [clazz transferEntityWithObject:dic[key]];
                if ([propertyInfo canSetValue]) {
                    ((void (*)(id,SEL,id))(void *)objc_msgSend)(instance,propertyInfo.setter,data);
                }
            }else {
                //普通
                if (!propertyInfo.isNumber) {
                    if ([propertyInfo canSetValue]) {
                        ((void (*)(id,SEL,id))(void *)objc_msgSend)(instance,propertyInfo.setter,dic[key]);
                    }
                }else {
                    if (propertyInfo.isNumber) {
                        NSNumberFormatter * numFormatter =   [[NSNumberFormatter alloc] init];
                       NSNumber * data = [numFormatter numberFromString:[NSString stringWithFormat:@"%@",dic[key]]];
                        [self sendMsgToInstance:instance withSetter:propertyInfo withNumber:data];
                    }
                }
            }
        }
    }
    return instance;
}

+ (void)sendMsgToInstance:(id )instance
               withSetter:(HBPropertyInfo *) propertyInfo
               withNumber:(NSNumber *)number{
    if ([propertyInfo canSetValue]) {
        if (propertyInfo.type & HBTypeEncodingUIntegerType) {
            ((void (*)(id,SEL,NSUInteger))(void *)objc_msgSend)(instance,propertyInfo.setter,[number unsignedIntegerValue]);
        }
        else if (propertyInfo.type & HBTypeEncodingIntegerType) {
            ((void (*)(id,SEL,NSInteger))(void *)objc_msgSend)(instance,propertyInfo.setter,[number integerValue]);
        }else if (propertyInfo.type & HBTypeEncodingBoolType) {
            ((void (*)(id,SEL,BOOL))(void *)objc_msgSend)(instance,propertyInfo.setter,[number boolValue]);
        }else if (propertyInfo.type & HBTypeEncodingDoubleType){
            ((void (*)(id,SEL,double))(void *)objc_msgSend)(instance,propertyInfo.setter,[number doubleValue]);
        }else if (propertyInfo.type & HBTypeEncodingFloatType) {
            ((void (*)(id,SEL,float))(void *)objc_msgSend)(instance,propertyInfo.setter,[number floatValue]);
        }else if (propertyInfo.type & HBTypeEncodingIntType) {
            ((void (*)(id,SEL,int))(void *)objc_msgSend)(instance,propertyInfo.setter,[number intValue]);
        }else if (propertyInfo.type & HBTypeEncodingLongType) {
            ((void (*)(id,SEL,long))(void *)objc_msgSend)(instance,propertyInfo.setter,[number longValue]);
        }else if (propertyInfo.type & HBTypeEncodingShortType) {
            ((void (*)(id,SEL,short))(void *)objc_msgSend)(instance,propertyInfo.setter,[number shortValue]);
        }
    }
    
}

+ (NSArray *)hb_filerArray{
    return @[@"hash",@"superclass",@"description",@"debugDescription"];
}
@end
