//
//  Person.m
//  CopyTest
//
//  Created by wj on 2017/8/30.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>


@implementation Person 



- (id)copyWithZone:(NSZone *)zone
{
    Person * person = [[Person allocWithZone:zone]init];
    person.name = self.name;
    person.age = self.age;
    return person;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    Person * person = [[Person allocWithZone:zone]init];
    person.name = self.name;
    person.age = self.age;
    return person;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"person %@ , %p", self,self];
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.age forKey:@"age"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  
    self = [super init];
    if (self)
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
    }
    return self;
}

- (instancetype)copyMyself
{
    Person * newPerson = [[Person alloc] init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        id propertyValue = [self valueForKeyPath:name];
        [newPerson setValue:propertyValue forKey:name];
    }
    return newPerson;
    free(properties);
}
@end
