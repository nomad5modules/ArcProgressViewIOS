#
# Be sure to run `pod lib lint ArcProgressView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ArcProgressView'
  s.version          = '1.2.0'
  s.summary          = 'An arc based progress view that blends text color with background color.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This view animates smoothly between given progress values. If the progress values are coming in at a high frequency, automatic value animation can be turned off. The customisable progress text blends smoothly with the background color of the view. Beside a programmatic initialization it can be fully used within a storyboard.'

  s.homepage         = 'https://github.com/nomad5modules/ArcProgressViewIOS'
  s.screenshots      = 'https://github.com/nomad5modules/ArcProgressViewIOS/raw/master/Image/demo.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mlostek@gmail.com' => 'mlostek@gmail.com' }
  s.source           = { :git => 'https://github.com/nomad5modules/ArcProgressViewIOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_versions = '5.0'
  s.source_files = 'ArcProgressView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ArcProgressView' => ['ArcProgressView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit' #, 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
