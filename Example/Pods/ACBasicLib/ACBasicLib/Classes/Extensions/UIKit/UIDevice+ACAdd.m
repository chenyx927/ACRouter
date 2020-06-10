//
//  UIDevice+ACAdd.m
//  DMKJ
//
//  Created by zhanggy on 2018/2/28.
//  Copyright © 2018年 jingcai. All rights reserved.
//

#import "UIDevice+ACAdd.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/machine.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AdSupport/AdSupport.h>

#import "NSDictionary+ACAdd.h"
#import "NSString+ACAdd.h"


@implementation UIDevice (ACAdd)

- (float)iOSVer
{
    return [self.systemVersion floatValue];
}

- (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (NSString *)machineModelName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        if (!model) return;
        NSDictionary *dic = @{
                              @"Watch1,1" : @"Apple Watch",
                              @"Watch1,2" : @"Apple Watch",
                              
                              @"iPod1,1" : @"iPod touch 1",
                              @"iPod2,1" : @"iPod touch 2",
                              @"iPod3,1" : @"iPod touch 3",
                              @"iPod4,1" : @"iPod touch 4",
                              @"iPod5,1" : @"iPod touch 5",
                              @"iPod7,1" : @"iPod touch 6",
                              
                              @"iPhone1,1" : @"iPhone 1G",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPhone3,1" : @"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"iPhone 4",
                              @"iPhone3,3" : @"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPhone5,1" : @"iPhone 5",
                              @"iPhone5,2" : @"iPhone 5",
                              @"iPhone5,3" : @"iPhone 5c",
                              @"iPhone5,4" : @"iPhone 5c",
                              @"iPhone6,1" : @"iPhone 5s",
                              @"iPhone6,2" : @"iPhone 5s",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6s",
                              @"iPhone8,2" : @"iPhone 6s Plus",
                              @"iPhone8,4" : @"iPhone SE",
                              @"iPhone9,1" : @"iPhone 7",
                              @"iPhone9,3" : @"iPhone 7",
                              @"iPhone9,2" : @"iPhone 7 Plus",
                              @"iPhone9,4" : @"iPhone 7 Plus",
                              @"iPhone10,1" : @"iPhone 8",
                              @"iPhone10,4" : @"iPhone 8",
                              @"iPhone10,2" : @"iPhone 8 Plus",
                              @"iPhone10,5" : @"iPhone 8 Plus",
                              @"iPhone10,3" : @"iPhone X",
                              @"iPhone10,6" : @"iPhone X",
                              
                              @"iPad1,1" : @"iPad 1",
                              @"iPad2,1" : @"iPad 2 (WiFi)",
                              @"iPad2,2" : @"iPad 2 (GSM)",
                              @"iPad2,3" : @"iPad 2 (CDMA)",
                              @"iPad2,4" : @"iPad 2",
                              @"iPad2,5" : @"iPad mini 1",
                              @"iPad2,6" : @"iPad mini 1",
                              @"iPad2,7" : @"iPad mini 1",
                              @"iPad3,1" : @"iPad 3 (WiFi)",
                              @"iPad3,2" : @"iPad 3 (4G)",
                              @"iPad3,3" : @"iPad 3 (4G)",
                              @"iPad3,4" : @"iPad 4",
                              @"iPad3,5" : @"iPad 4",
                              @"iPad3,6" : @"iPad 4",
                              @"iPad4,1" : @"iPad Air",
                              @"iPad4,2" : @"iPad Air",
                              @"iPad4,3" : @"iPad Air",
                              @"iPad4,4" : @"iPad mini 2",
                              @"iPad4,5" : @"iPad mini 2",
                              @"iPad4,6" : @"iPad mini 2",
                              @"iPad4,7" : @"iPad mini 3",
                              @"iPad4,8" : @"iPad mini 3",
                              @"iPad4,9" : @"iPad mini 3",
                              @"iPad5,1" : @"iPad mini 4",
                              @"iPad5,2" : @"iPad mini 4",
                              @"iPad5,3" : @"iPad Air 2",
                              @"iPad5,4" : @"iPad Air 2",
                              @"iPad6,7" : @"iPad Pro (12.9-inch)",
                              @"iPad6,8" : @"iPad Pro (12.9-inch)",
                              @"iPad6,3" : @"iPad Pro (9.7-inch)",
                              @"iPad6,4" : @"iPad Pro (9.7-inch)",
                              @"iPad6,11" : @"iPad (5th generation)",
                              @"iPad6,12" : @"iPad (5th generation)",
                              @"iPad7,1" : @"iPad Pro (12.9-inch, 2nd generation)",
                              @"iPad7,2" : @"iPad Pro (12.9-inch, 2nd generation)",
                              @"iPad7,3" : @"iPad Pro (10.5-inch)",
                              @"iPad7,4" : @"iPad Pro (10.5-inch)",
                              
                              @"i386"   : @"iOS Simulator",
                              @"x86_64" : @"iOS Simulator",
                              };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}

- (NSString *)currentDeviceModelDescription
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE (A1662/A1723/A1724)";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (A1660/A1779/A1780)";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (A1778)";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus (A1661/A1785/A1786)";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus (A1784)";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8 (A1863/A1906/A1907)";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8 (A1905)";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus (A1864/A1898/A1899)";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus (A1897)";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X (A1865/A1902)";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X (A1901)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2 (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2 (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2 (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad mini 3 (A1599)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad mini 3 (A1600)";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad mini 3 (A1601)";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad mini 4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad mini 4 (A1550)";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (A1566)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (A1567)";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7-inch) (A1673)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7-inch) (A1674/A1675)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9-inch) (A1584)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9-inch) (A1652)";
    if ([platform isEqualToString:@"iPad6,11"])   return @"iPad (5th generation) (A1822)";
    if ([platform isEqualToString:@"iPad6,12"])   return @"iPad (5th generation) (A1823)";
    if ([platform isEqualToString:@"iPad7,1"])   return @"iPad Pro (12.9-inch, 2nd generation) (A1670)";
    if ([platform isEqualToString:@"iPad7,2"])   return @"iPad Pro (12.9-inch, 2nd generation) (A1671/A1821)";
    if ([platform isEqualToString:@"iPad7,3"])   return @"iPad Pro (10.5-inch) (A1701)";
    if ([platform isEqualToString:@"iPad7,4"])   return @"iPad Pro (10.5-inch) (A1709)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

- (NSString *)screenResolution {
    CGSize screenSize   = [UIScreen mainScreen].bounds.size;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%.0f-%.0f", screenSize.width * screenScale, screenSize.height * screenScale];
}

#pragma mark - screen size
+ (CGFloat)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}


+ (CGFloat)screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)statusBarHeight
{
    return [self isIPhoneX]?44:20;
}

+ (CGFloat)naviBarHeight
{
    return 44;
}

+ (CGFloat)naviBarAddStatusBarHeight
{
    return [self statusBarHeight]+[self naviBarHeight];
}

+ (CGFloat)tabBarHeight
{
    return [self isIPhoneX]?83:49;
}

+ (CGFloat)xBottomBarHeight
{
    return [self isIPhoneX]?34:0;
}

+ (CGFloat)uiHorizontalScale
{
    return [self screenWidth]/375;
}

+ (CGFloat)lineHeight
{
    return 1.f/[UIScreen mainScreen].scale;
}

+ (BOOL)isIPhone4
{
    return ([self screenHeight] < 568); 
}

+ (BOOL)isIPhone5
{
    return ([self screenHeight] == 568);
}

+ (BOOL)isIPhone6
{
    return ([self screenHeight] == 667);
}

+ (BOOL)isIPhone6P
{
    return ([self screenHeight] == 736);
}

+ (BOOL)isIPhoneX
{
    return ([self screenHeight] == 812) || ([self screenHeight] == 896);
}

#pragma mark - 内部方法
static const char *SIDFAModel   = "hw.model";
static const char *SIDFAMachine = "hw.machine";
static NSString *getSystemHardwareByName(const char *typeSpecifier)
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithUTF8String:answer];
    free(answer);
    return results;
}

static NSUInteger getSysInfo(uint typeSpecifier)
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

static NSString *getCPUType()
{
    NSMutableString *cpu = [[NSMutableString alloc] init];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    if (type == CPU_TYPE_X86_64) {
        [cpu appendString:@"x86_64"];
    }
    else if (type == CPU_TYPE_X86) {
        [cpu appendString:@"x86"];
    }
    else if (type == CPU_TYPE_ARM) {
        [cpu appendString:@"arm"];
        
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM_V6:
                [cpu appendString:@"v6"];
                break;
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"v7"];
                break;
            case CPU_SUBTYPE_ARM_V8:
                [cpu appendString:@"v8"];
                break;
        }
    }
    else if (type == CPU_TYPE_ARM64) {
        [cpu appendString:@"arm64"];
    }
    else {
        [cpu appendString:@"other"];
    }
    
    return cpu;
}

static NSString *diskCapacity()
{
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSString *diskSize = [fileAttributes[NSFileSystemSize] stringValue];
    return diskSize;
}

#pragma mark - 外部方法
+ (NSString *)macAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

+ (NSString *)IDFA
{
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"00000000-0000-0000-0000-000000000000";
    }
    else {
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"00000000-0000-0000-0000-000000000000";
        }
        else {
            ASIdentifierManager *asIM = (ASIdentifierManager *)[[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"00000000-0000-0000-0000-000000000000";
            }
            else {
                return [asIM.advertisingIdentifier UUIDString];
            }
        }
    }
}

+ (NSString *)IDFV
{
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"00000000-0000-0000-0000-000000000000";
}

+ (NSString *)countryCode
{
    NSLocale *locale      = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

+ (NSString *)languageCode
{
    NSString *language;
    NSLocale *locale = [NSLocale currentLocale];
    if ([[NSLocale preferredLanguages] count] > 0) {
        language = [[NSLocale preferredLanguages]objectAtIndex:0];
    }
    else {
        language = [locale objectForKey:NSLocaleLanguageCode];
    }
    
    return language;
}

+ (NSString *)systemBootTime
{
    NSTimeInterval timer_ = [NSProcessInfo processInfo].systemUptime;
    NSDate *startTime = [[NSDate date] dateByAddingTimeInterval:(-timer_)];
    return [NSString stringWithFormat:@"%.0f",[startTime timeIntervalSince1970]];
}

+ (NSString *)systemFileTime
{
    NSFileManager *file = [NSFileManager defaultManager];
    NSDictionary *dict  = [file attributesOfItemAtPath:@"System/Library/CoreServices" error:nil];
    NSDate *createT = (dict && [dict contains:NSFileCreationDate]) ? dict[NSFileCreationDate] : nil;
    NSDate *modifyT = (dict && [dict contains:NSFileModificationDate]) ? dict[NSFileModificationDate] : nil;
    NSString *createS = createT ? [NSString stringWithFormat:@"%.0f",[createT timeIntervalSince1970]] : @"0";
    NSString *modifyS = modifyT ? [NSString stringWithFormat:@"%.0f",[modifyT timeIntervalSince1970]] : @"0";
    return [NSString stringWithFormat:@"%@-%@",createS,modifyS];
}

+ (NSString *)carrierInfo
{
    NSMutableString* cInfo = [NSMutableString string];
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString *carrierName = [carrier carrierName];
    if (carrierName != nil){
        [cInfo appendString:carrierName];
    }
    
    NSString *mcc = [carrier mobileCountryCode];
    if (mcc != nil){
        [cInfo appendString:mcc];
    }
    
    NSString *mnc = [carrier mobileNetworkCode];
    if (mnc != nil){
        [cInfo appendString:mnc];
    }
    
    if ([NSString isEmpty:cInfo]) {
        [cInfo appendString:@"CarrierDefault"];
    }
    
    return cInfo;
}

+ (NSString *)hardwareInfo
{
    NSString *model        = getSystemHardwareByName(SIDFAModel);
    NSString *machine      = getSystemHardwareByName(SIDFAMachine);
    NSString *cpuType      = getCPUType();
    NSString *diskSize     = diskCapacity();
    NSUInteger totalMemory = getSysInfo(HW_PHYSMEM);
    
    NSString *hardwareString = [NSString stringWithFormat:@"%@,%@,%@,%@,%td",model,machine,cpuType,diskSize,totalMemory];
    
    hardwareString = hardwareString.md5;
    hardwareString = [hardwareString insert:8 string:@"-"];
    hardwareString = [hardwareString insert:13 string:@"-"];
    hardwareString = [hardwareString insert:18 string:@"-"];
    hardwareString = [hardwareString insert:23 string:@"-"];
    
    return hardwareString;
}

@end

