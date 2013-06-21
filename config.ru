require_relative './web_app'


use WebApp::Artists, :urls => ['/artists']
run Rack::Handler::WEBrick.run(WebApp::Index.new)