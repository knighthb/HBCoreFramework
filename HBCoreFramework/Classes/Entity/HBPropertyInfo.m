//
//  HBPropertyInfo.m
//  HBCoreFramework
//
//  Created by knight on 16/4/4.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "HBPropertyInfo.h"
@interface HBPropertyInfo()
@property (nonatomic, assign, readwrite) objc_property_t property;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *value;
@property (nonatomic, strong, readwrite) Class clazz;
@property (nonatomic, assign, readwrite) SEL getter;
@property (nonatomic, assign, readwrite) SEL setter;
@property (nonatomic, assign, readwrite)HBTypeEncodingPropertyType type;
@property (nonatomic, copy, readwrite)NSString * iVarName;
@end

@implementation HBPropertyInfo
static char * filerClassName(const char * sourceValue) {
    size_t len = strlen(sourceValue);
    if (len <= 0) return nil;
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
bool strEqualTo(const char * srcStr,const char * desStr) {
    return strcmp(srcStr, desStr)==0?YES:NO;
}
- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) return nil;
    self = [super init];
    if (self) {
        _property = property;
        const char * name = property_getName(property);
        if (name) {
            _name = [NSString stringWithUTF8String:name];
        }
        _type = HBTypeEncodingUnkownType;
        char * capitalizedName = malloc(strlen(name)+1);
        stpcpy(capitalizedName, name);
        capitalizedName[0] = capitalizedName[0]-'a'+'A';
        NSString * methodName = [NSString stringWithUTF8String:capitalizedName];
        NSString * originalSetterName = [NSString stringWithFormat:@"set%@:",methodName];
        _setter = sel_registerName([originalSetterName UTF8String]);
        _getter = sel_registerName([methodName UTF8String]);
        const char * attributes = property_getAttributes(property);
        if (attributes) {
            unsigned int attributesCount;
            objc_property_attribute_t * attributes_t = property_copyAttributeList(property, &attributesCount);
            if (attributesCount > 0) {
                for (unsigned int attrIndex; attrIndex < attributesCount; attrIndex ++) {
                    objc_property_attribute_t property_attr_t = attributes_t[attrIndex];
                    if (strEqualTo("T", property_attr_t.name)) {
                        [self parseClassWithPropertyAttributeValue:property_attr_t.value];
                    }else if(strEqualTo("R", property_attr_t.name)) {
                        _type |= HBTypeEncodingPropertyReadOnly;
                    }else if (strEqualTo("C", property_attr_t.name)) {
                        _type |= HBTypeEncodingPropertyCopy;
                    }else if (strEqualTo("&", property_attr_t.name)) {
                        _type |= HBTypeEncodingPropertyRetain;
                    }else if (strEqualTo("D", property_attr_t.name)) {
                        _type |= HBTypeEncodingPropertyDynamic;
                    }else if (strEqualTo("W", property_attr_t.name)) {
                        _type |= HBTypeEncodingPropertyWeak;
                    }else if (strEqualTo("N", property_attr_t.name)) {
                        _type |= HBTypeEncodingPropertyNonAtomic;
                    }else if (strEqualTo("S", property_attr_t.name)) {
                        NSString * setterName = [NSString stringWithUTF8String:property_attr_t.value];
                        _setter = sel_registerName([setterName UTF8String]);
                    }else if (strEqualTo("G", property_attr_t.name)) {
                        NSString * getterName = [NSString stringWithUTF8String:property_attr_t.value];
                        _getter = sel_registerName([getterName UTF8String]);
                    }else if (strEqualTo("V", property_attr_t.name)) {
                        _iVarName = [NSString stringWithUTF8String:property_attr_t.value];
                    }
                }
            }
        }
    }
    return self;
}

- (void)parseClassWithPropertyAttributeValue:(const char *)attrValue {
    char * value = filerClassName(attrValue);
    NSString * className = [[NSString alloc ]initWithCString:value encoding:NSUTF8StringEncoding];
    _clazz = NSClassFromString(className);
    free(value);
}

@end
