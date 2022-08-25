#source 'https://github.com/CocoaPods/Specs.git'
source 'https://cdn.cocoapods.org/'
use_frameworks!

platform :ios, '11.0'

POD = 'FreestarAds-Ogury'
POD_TEST = POD + '_Tests'

target POD do
  pod 'FreestarAds-PreRelease', '~> 5.15.0-beta-2'
  pod 'OgurySdk', '~> 2.1.0'
  pod 'OguryAds'
  pod 'OguryChoiceManager'
 
  target POD_TEST do
    inherit! :search_paths
  end
end
