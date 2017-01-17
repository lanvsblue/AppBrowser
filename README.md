# AppBrowser(Application属性查看器，不需要越狱！！！)

不需要越狱，调用私有方法 --- 获取完整的已安装应用列表、打开和删除应用操作、应用运行时相关信息的查看。

支持iOS10.X

## 功能
- [x] 已安装的应用列表
- [x] 应用的详情界面 (打开应用，删除应用，应用的相关信息展示)
- [x] 应用运行时信息展示（LSApplicationProxy）
- [ ] 定制喜欢的字段，展示在应用详情界面

## 介绍

#### 所有已安装应用列表（应用icon+应用名）

> 为了提供思路，这里只用伪代码，具体的私有代码调用请查看：`AppBrowser/AppBrowser/Model/LANAppHelper.m`

获取应用实例：

```objc
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
 
 #define APP_NAME_KEY_PATH @"_infoDictionary.propertyList.CFBundleDisplayName"
 #define APP_SHORT_NAME_KEY_PATH @"localizedShortName"
 
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

![应用列表](http://o9gma3fh0.bkt.clouddn.com/2016/12/AppBrowser/Installed%20app%201.png)

#### 应用运行时详情

打开应用：
```objc
//对应于LANAppHelper类中的+ (BOOL)openApplication:(id)application方法：
[applicationWorkspace openApplicationWithBundleID:[application bundleIdentifier]];
```

卸载应用：
```objc
//对应于LANAppHelper类中的+ (BOOL)removeApplication:(id)application方法：
[applicationWorkspace uninstallApplication:[application bundleIdentifier] withOptions:nil];
```

获取info.plist文件：
```objc
//info.plist文件实例化以后就是_infoDictionary属性，位置在[LSApplicationProxy superClass],也就是在LSBundleProxy类中
#define APP_PROPERTY_LIST_KEY_PATH @"_infoDictionary.propertyList"
```
应用运行时详情界面展示：

![应用运行时详情](http://o9gma3fh0.bkt.clouddn.com/2016/12/AppBrowser/app%20info%201.png)

* 右上角，从左往右第一个按钮用来打开应用；第二个按钮用来卸载这个应用
* INFO按钮用来解析并显示出对应的LSApplicationProxy类

#### 树形展示LSApplicationProxy类
通过算法，将LSApplicationProxy类，转换成了字典。

转换规则是：属性名为key，属性值为value，如果value是一个可解析的类（除了NSString,NSNumber...等等）或者是个数组或字典，则继续递归解析。
并且会找到superClass的属性并解析，superClass如果也符合解析原则，也会进入递归解析。

具体算法可以查看 LANAppHelper.m文件中的
```objc 
+(NSDictionary *)infoForApplication:(id)application;
```
![解析LSApplicationProxy类](http://o9gma3fh0.bkt.clouddn.com/2016/12/AppBrowser/LSApplicationProxy%201.png)

## 功能演示

#### 已安装的应用列表
![已安装的应用列表](http://o9gma3fh0.bkt.clouddn.com/2016/12/AppBrowser/installed%20app-squashed1.gif)

#### 应用详情页
![应用详情页](http://o9gma3fh0.bkt.clouddn.com/2016/12/AppBrowser/app%20info-squashed1.gif)

#### 打开应用
![打开应用](http://o9gma3fh0.bkt.clouddn.com/2016/12/AppBrowser/open%20app-squashed1.gif)

#### 卸载应用
![卸载应用](http://o9gma3fh0.bkt.clouddn.com/2016/12/AppBrowser/uninstall%20app-squashed1.gif)

#### 应用属性列表
![应用属性列表](http://o9gma3fh0.bkt.clouddn.com/2016/12/AppBrowser/LSApplicationProxy-squashed1.gif)

## 参考及引用
* [iOS-Runtime-Headers](https://github.com/nst/iOS-Runtime-Headers)
* [Retriever](https://github.com/cyanzhong/Retriever)
* [RuntimeInvoker](https://github.com/cyanzhong/RuntimeInvoker)
