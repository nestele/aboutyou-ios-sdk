Pod::Spec.new do |s|

  s.name         = "AboutYouShop-iOS-SDK"
  s.version      = "1.0.1"
  s.summary      = "A library for AboutYou Shop integration in iOS"
  s.description  = <<-DESC
                   AboutYouShop-iOS-SDK is a library for [AboutYou](http://aboutyou.de) Shop integration in iOS. It is written in Objective-C and requires ARC and the iOS SDK 6.0 or above. The networking- and object mapping engine is build on top of [RestKit](https://github.com/RestKit/RestKit). It provides all necessary functions and convenience methods to make your app fully capable of the AboutYou API.
                   DESC
  s.homepage = 'http://aboutyou.de'
  s.license      = 'MIT'
  s.authors          = { "Marius Schmeding" => "marius.schmeding@slice-dice.de", 
			"Jesse Hinrichsen" => "jesse.hinrichsen@slice-dice.de" }

  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/aboutyou/aboutyou-ios-sdk.git", :tag => "#{s.version}" }
  s.requires_arc = true
  s.dependency 'RestKit', '~> 0.22.0'

  s.subspec 'Core' do |c|

    c.source_files = 'Classes/Core/**/*.{h,m}'

  end

  s.subspec 'UI' do |ui|

    ui.source_files = 'Classes/UI/**/*.{h,m}'
    ui.dependency 'AboutYouShop-iOS-SDK/Core'
    ui.dependency 'MBProgressHUD'

  end

end
