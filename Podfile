#source 'https://github.com/CocoaPods/Specs.git'
source 'https://cdn.cocoapods.org/'
use_frameworks!

platform :ios, '11.0'

POD = 'FreestarAds-Ogury'
POD_TEST = POD + '_Tests'

target POD do
  # pod 'FreestarAds-PreRelease', '~> 5.13.0-beta-2'
  pod 'FreestarAds-PreRelease', :path => '/Users/charles/Documents/DEVELOPER/WORKSPACE/FREESTAR/ios-core-sdk/FreestarAds-Core/FreestarAds-PreRelease.local.podspec'
  pod 'OgurySdk', '~> 2.1.0'

  target POD_TEST do
    inherit! :search_paths
  end
end
