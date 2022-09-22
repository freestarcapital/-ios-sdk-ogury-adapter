Pod::Spec.new do |spec|
  spec.name                = "FreestarAds-Ogury-PreRelease"
  spec.version             = "2.1.0.3-beta-5"
  spec.author              = 'Freestar'
  spec.license             =  { :type => 'Apache2.0', :file => 'LICENSE' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'The Freestar Ogury adapter'
  spec.platform            = :ios, '11.0'

  spec.vendored_frameworks  = 'build/FreestarAds-Ogury.xcframework'
  spec.dependency "FreestarAds-PreRelease", "~> 5.15-beta"
  spec.dependency 'OgurySdk', '~> 2.1.0'
  spec.dependency 'OguryChoiceManager'
  spec.dependency 'OguryAds'

  spec.source              = {
      :git => "https://gitlab.com/freestar/ios-binaries.git",
      :tag => "Ogury-PreRelease-2.1.0.3-beta-5"
  }

  spec.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }

end
