# AppBrowser(Application属性查看器，不需要越狱！！！)
不需要越狱，调用私有方法 --- 获取完整的已安装应用列表、打开和删除应用操作、应用运行时相关信息的查看。

## 介绍

#### 所有已安装应用列表（应用icon+应用名）

> 为了提供思路，这里只用伪代码，具体的私有代码调用请查看：`AppBrowser/AppBrowser/Model/LANAppHelper.m`

获取应用实例：

```objc
#define APP_NAME_KEY_PATH @"_infoDictionary.propertyList.CFBundleDisplayName"
#define APP_SHORT_NAME_KEY_PATH @"localizedShortName"

//首先获取 LSApplicationWorkspace 实例
//对应于LANAppHelper类中的+(id)defaultWorkspace;方法：
id<LSApplicationWorkspace *> applicationWorkspace = [LSApplicationWorkspace defaultWorkspace];

//使用 LSApplicationWorkspace 获取应用列表（LSApplicationProxy对象列表）
//对应于LANAppHelper类中的+(id)allInstalledApplications;方法：
NSArray<LSApplicationProxy *> applicationArray = [applicationWorkspace allInstalledApplications];

//取出第一个应用对象
id<LSApplicationProxy *> application = applicationArray[0];
```

获取应用名和应用的icon：
```objc
/* 
 * APP_NAME_KEY_PATH 和 APP_SHORT_NAME_KEY_PATH 的定义在代码头上
 * 应用的名字有可能出现在两个地方：
 * 在桌面上显示的普通应用的应用名来自info.plist文件中的CFBundleDisplayName字段
 * 在桌面的部分系统应用显示的是localizedShortName
 * 对应于LANAppHelper类中的+(id)nameForApplication:(id)application;方法：
 */
NSString *applicationName = [application valueForKeyPath:APP_NAME_KEY_PATH] ?:
                                      [application valueForKeyPath:APP_SHORT_NAME_KEY_PATH];

/* 
 * 应用的图片可以调用UIImage的私用方法：_applicationIconImageForBundleIdentifier:format:scale:
 * 传入BundleID，格式，缩放大小
 * 对应于LANAppHelper类中的+(id)iconForApplication:(id)application;方法：
 */
 UIImage *applicationImage = [UIImage _applicationIconImageForBundleIdentifier:[application bundleIdentifier] 
                                                                        format:@"" 
                                                                         scale:@([UIScreen mainScreen].scale)];
```
应用列表界面展示：

![应用列表]()

#### 应用运行时详情
