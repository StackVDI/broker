VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock 
end

