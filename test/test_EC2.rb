#--
# Amazon Web Services EC2 Query API Ruby library
#
# Ruby Gem Name::  amazon-ec2
# Author::    Glenn Rempe  (mailto:glenn@rempe.us)
# Copyright:: Copyright (c) 2007-2008 Glenn Rempe
# License::   Distributes under the same terms as Ruby
# Home::      http://github.com/grempe/amazon-ec2/tree/master
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "The EC2 method " do

  setup do
  end

  specify "EC2::Base attribute readers should be available" do
    @ec2 = EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret",
                          :use_ssl => true,
                          :server => "foo.example.com" )

    @ec2.use_ssl.should.equal true
    @ec2.port.should.equal 443
    @ec2.server.should.equal "foo.example.com"
  end

  specify "EC2::Base should work with insecure connections as well" do
    @ec2 = EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret",
                          :use_ssl => false,
                          :server => "foo.example.com" )

    @ec2.use_ssl.should.equal false
    @ec2.port.should.equal 80
    @ec2.server.should.equal "foo.example.com"
  end

  specify "EC2::Base should allow specification of port" do
    @ec2 = EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret",
                          :use_ssl => true,
                          :server => "foo.example.com",
                          :port => 8443 )

    @ec2.port.should.equal 8443
  end

  specify "EC2::Base should allow specification of base path" do
    @ec2 = EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret",
                          :base_path => '/services/Eucalyptus' )

    @ec2.base_path.should.equal '/services/Eucalyptus'
  end

  specify "EC2::Base should default base path to /" do
    @ec2 = EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret" )

    @ec2.base_path.should.equal '/'
  end

  specify "EC2::Base should allow specification of http method" do
    @ec2 = EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret",
                          :http_method => 'GET' )

    @ec2.http_method.should.equal 'GET'
  end

  specify "EC2::Base should default http method to POST" do
    @ec2 = EC2::Base.new( :access_key_id => "not a key",
                          :secret_access_key => "not a secret" )

    @ec2.http_method.should.equal 'POST'
  end

  specify "EC2.canonical_string(path) should conform to Amazon's requirements " do
    path = {"name1" => "value1", "name2" => "value2", "name3" => "value3"}
    if ENV['EC2_URL'].nil? || ENV['EC2_URL'] == 'https://ec2.amazonaws.com'
      EC2.canonical_string(path).should.equal "POST\nec2.amazonaws.com\n/\nname1=value1&name2=value2&name3=value3"
    elsif ENV['EC2_URL'] == 'https://us-east-1.ec2.amazonaws.com'
      EC2.canonical_string(path).should.equal "POST\nus-east-1.ec2.amazonaws.com\n/\nname1=value1&name2=value2&name3=value3"
    elsif ENV['EC2_URL'] == 'https://eu-west-1.ec2.amazonaws.com'
      EC2.canonical_string(path).should.equal "POST\neu-west-1.ec2.amazonaws.com\n/\nname1=value1&name2=value2&name3=value3"
    end
  end
  
  specify 'EC2.canonical_string(path) should allow specification of host, base path and method' do
    path = {"name1" => "value1", "name2" => "value2", "name3" => "value3"}
    EC2.canonical_string(path, 'foo.example.com', 'GET', '/services/Eucalyptus').should.
        equal "GET\nfoo.example.com\n/services/Eucalyptus\nname1=value1&name2=value2&name3=value3"
  end

  specify "EC2.encode should return the expected string" do
    EC2.encode("secretaccesskey", "foobar123", urlencode=true).should.equal "e3jeuDc3DIX2mW8cVqWiByj4j5g%3D"
    EC2.encode("secretaccesskey", "foobar123", urlencode=false).should.equal "e3jeuDc3DIX2mW8cVqWiByj4j5g="
  end

end
