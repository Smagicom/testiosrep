# Uncomment the next line to define a global platform for your project
# platform :ios, '17.0'

target 'MovieDB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
	
  # Pods for MovieDB
  pod 'SnapKit', '~> 5.0.0'
  pod 'Alamofire'
  target 'MovieDBTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MovieDBUITests' do
    # Pods for testing
  end
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['VALID_ARCHS'] = 'arm64, arm64e, x86_64'
    end
  end

end