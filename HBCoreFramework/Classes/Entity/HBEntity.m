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

static Class classOfProperty(struct objc_property * property) {
    const char * attributes = property_getAttributes(property);
    Class clazz = nil;
    NSLog(@"%s",attributes);
    unsigned int attributesCount;
    objc_property_attribute_t * attributes_t = property_copyAttributeList(property, &attributesCount);
    for (unsigned int attrIndex=0; attrIndex < attributesCount; attrIndex ++) {
        objc_property_attribute_t property_attr_t = attributes_t[attrIndex];
        NSLog(@"property attribute %d: name = %s | value = %s",attrIndex,property_attr_t.name,property_attr_t.value);
        if (strcmp("T", property_attr_t.name)==0) {//看是什么类型的
            char * value = filerClassName(property_attr_t.value);
            NSString * className = [[NSString alloc ]initWithCString:value encoding:NSUTF8StringEncoding];
            clazz = NSClassFromString(className);
            NSLog(@"class is %@",clazz);
            free(value);
        }
    }
    return clazz;
}

static bool needRecursiveWithClass(Class clazz) {
    if ([clazz conformsToProtocol:@protocol(HBEntityProtocol)]) {
        return YES;
    }
    return NO;
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
    return [[self alloc] init];
}

+ (instancetype)transferEntityWithDic:(NSDictionary *)dic {
    unsigned int outCount;
    NSDictionary * reverseTransferDic = nil;
    if ([self hb_transferDic]) {
       reverseTransferDic = [self reverseTransferDic:[self hb_transferDic]];
    }
    id instance = [[self alloc] init];
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
            if ([clazz isSubclassOfClass:[NSMutableArray class]] || [clazz isSubclassOfClass:[NSDictionary class]]) {
                if ([self conformsToProtocol:@protocol(HBEntityProtocol)] &&
                    [self respondsToSelector:@selector(hb_objectClassForKeyDic)]) {
                    NSDictionary * mapedKeyClass = [self hb_objectClassForKeyDic];
                    if (mapedKeyClass) {
                        Class cls = mapedKeyClass[key];
                        if (cls && ![cls isSubclassOfClass:[NSNull class]]) {
                            clazz = cls;
                            id data = [clazz transferEntityWithObject:dic[key]];
                            ((void (*)(id,SEL,id))(void *)objc_msgSend)(instance,propertyInfo.setter,data);
                        }
                    }
                }
            }
            ((void (*)(id,SEL,id))(void *)objc_msgSend)(instance,propertyInfo.setter,dic[key]);
        }
    }
    return instance;
}

+ (NSArray *)hb_filerArray{
    return @[@"hash",@"superclass",@"description",@"debugDescription"];
}

+ (NSDictionary *)hb_transferDic {
    return @{@"entityname":@"entityName",
             @"entitynum":@"entityNum"};
}

+ (NSDictionary *)hb_objectClassForKeyDic {
    return @{@"hehe":[HBStorage class]};
}

//- (void)setEntityAge2:(HBStorage *)entityAge {
//    _entityAge
//}
@end
