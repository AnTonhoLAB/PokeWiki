# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# source to download other pods
source 'https://github.com/CocoaPods/Specs.git'

# source to download GGDevelopmentKit
source 'https://github.com/AnTonhoLAB/Podspecs.git'

target 'PokeWiki' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PokeWiki
  pod 'RxSwift', '>= 5.0.0'
  pod 'RxCocoa', '>= 5.0.0'
  pod 'Alamofire', '~> 5.5'
  pod 'GGDevelopmentKit', '~> 0.2.1'

  target 'PokeWikiTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking'
    pod 'RxTest'
  end

  target 'PokeWikiUITests' do
    # Pods for testing
  end
end
