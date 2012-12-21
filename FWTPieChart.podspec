Pod::Spec.new do |s|
  s.name         = "FWTPieChart"
  s.version      = "0.0.1"
  s.summary      = "FWTPieChart is a small set of classes that shows how to create circular progress view and pie charts."
  s.homepage     = "https://github.com/FutureWorkshops/FWTPieChart"
  s.license      = { :type => 'Apache License Version 2.0', :file => 'LICENSE' }
  s.author       = { 'Marco Meschini' => 'marco@futureworkshops.com' }
  s.source       = { :git => "https://github.com/FutureWorkshops/FWTPieChart.git",  :tag => "0.0.1" }
  s.platform     = :ios
  s.source_files = 'FWTPieChart/FWTPieChart'
  s.framework    = 'QuartzCore'
end
