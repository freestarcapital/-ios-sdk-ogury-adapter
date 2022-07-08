#source 'https://github.com/CocoaPods/Specs.git'
source 'https://cdn.cocoapods.org/'
use_frameworks!

platform :ios, '11.0'

POD = 'FreestarAds-Ogury'
POD_TEST = POD + '_Tests'

target POD do
  pod 'FreestarAds-PreRelease', "~> 5.12-beta"
  pod 'OgurySdk', '~> 2.1.0'
  # pod 'FreestarAds-PreRelease', :path => '../FreestarAds-Core/FreestarAds-PreRelease.local.podspec'

  target POD_TEST do
    inherit! :search_paths
  end
end
