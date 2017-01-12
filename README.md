# Ipify

[![CI Status](http://img.shields.io/travis/Vincent Peng/Ipify.svg?style=flat)](https://travis-ci.org/Vincent Peng/Ipify)
[![Version](https://img.shields.io/cocoapods/v/Ipify.svg?style=flat)](http://cocoapods.org/pods/Ipify)
[![License](https://img.shields.io/cocoapods/l/Ipify.svg?style=flat)](http://cocoapods.org/pods/Ipify)
[![Platform](https://img.shields.io/cocoapods/p/Ipify.svg?style=flat)](http://cocoapods.org/pods/Ipify)

Retrieve your public IP address from [ipify's API service](https://www.ipify.org/).

## Usage

```swift
import Ipify

Ipify.getPublicIPAddress { result in
	switch result {
	case .success(let ip):
		print(ip) //=> '210.11.178.112'
		
	case .failure(let error):
		print(error.localizedDescription)
	}
}
```

## Requirements
* Swift 3
* iOS 8+

## Installation

Ipify is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Ipify"
```

## Author

Vincent Peng, vincent@vincentpeng.me

## Credit

Big thanks to [Randall Degges](http://www.rdegges.com) for running and maintaining [ipify](https://www.ipify.org)!

## License

Ipify is available under the MIT license. See the LICENSE file for more info.


