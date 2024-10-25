Pod::Spec.new do |s|
  # Pod name
  s.name         = 'myvcx'
  
  # Version and summary
  s.version      = '1.0.0'
  s.summary      = 'A description of myvcx framework.'
  
  # The homepage for the pod
  s.homepage     = 'https://instnt.org/'
  
  # The author information
  s.author       = { 'Your Name' => 'your.email@example.com' }
  
  # License for the pod
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  
  # Add a dummy source since you're using a local framework
  # s.source       = { :git => 'https://github.com/your/repo.git', :tag => '1.0.0' } # Adjust with your actual repo


  # Specify the source location for the ZIP file
   s.source       = { :http => 'https://github.com/instnt-inc/instnt-aries-vcx/releases/download/abhishek_GithubAction2/vcx.xcframework.zip' } # Replace with your ZIP file URL
  
  # Specify the source files (i.e., the .swift files)
  s.source_files = 'aries/agents/ios/ariesvcx/ariesvcx/Source/vcx.swift'  # Replace with the actual path if necessary
  
  s.platform     = :ios, '17.0'
  
  # Frameworks you want to link (if necessary)
  # s.frameworks = 'vcx.xcframework'
  
  #s.vendored_frameworks = 'vcx.xcframework'

  
end
