# YSimpleImagePicker
This is IOS Swift Universal Static Library for Image picking from gallery or camera with some simple customization



## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like `YSimpleImagePicker` in your projects. 

First, add the following line to your [Podfile](http://guides.cocoapods.org/using/using-cocoapods.html):

```ruby
pod 'YSimpleImagePicker'
```

Second, install `YSimpleImagePicker` into your project:

```ruby
pod install
```

## Usage

Import Library into View Controller

```ruby
import YSimpleImagePicker
```

Then get shared instance as
```ruby
let shared = YSimpleImagePicker.shared
```

```ruby
shared.selectImage(refController: self, onSelection: { (img) in
        self.imageview.image = img
}) { (error) in
        print(error)
}
```

## License

`YSimpleImagePicker` is distributed under the terms and conditions of the [MIT license]
