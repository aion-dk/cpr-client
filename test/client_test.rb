require 'minitest/autorun'
require 'cpr_client'

class ClientTest < Minitest::Test

  # To run this test you have to setup environment variables with your login credentials
  # CPR_USER="your user" CPR_PASS="your password" rake test
  def setup
    user = ENV.fetch('CPR_USER') { |key| raise "Environment key #{key} is not set" }
    pass = ENV.fetch('CPR_PASS') { |key| raise "Environment key #{key} is not set" }
    @client = CPRClient.new(user, pass, true)
  end

  def test_wrong_password
    client = CPRClient.new('lolcat', 'bogus', true)
    assert_raises CPRClient::LoginError do
      client.login
    end
  end

  def test_login_request
    assert @client.login, 'Client should login'
  end

  def test_lookup
    assert_kind_of CPRClient::Record, @client.lookup('0707614285'), '"0707614285" should be in demo registry'
    assert_kind_of CPRClient::Record, @client.lookup('070761-4285'), '"070761-4285" should be in demo registry'
    assert_kind_of CPRClient::Record, @client.lookup(' 070761-4285 '), '" 070761-4285 " should be in demo registry'
  end

  def test_stamp
    assert_kind_of CPRClient::Record, @client.stamp('0707614285'), '"0707614285" should be in demo registry'
    assert_kind_of CPRClient::Record, @client.stamp('070761-4285'), '"070761-4285" should be in demo registry'
    assert_kind_of CPRClient::Record, @client.stamp(' 070761-4285 '), '" 070761-4285 " should be in demo registry'
  end

  def test_malformed_cpr
    assert_nil @client.lookup('lol'), '"lol" not in registry'
    assert_nil @client.lookup('123'), '"123" not in registry'
    assert_nil @client.lookup('12345678901234'), '"12345678901234" not in registry'
  end

  def test_no_record
    assert_nil @client.lookup('0000000000'), '"0000000000" not in registry'
    assert_nil @client.lookup('1111111111'), '"1111111111" not in registry'
  end

  # Records on the demo environment
  #
  # 0101980014
  # 0701614011
  # 0701614038
  # 0701614089
  # 0702614074
  # 0702614082
  # 0702614147
  # 0702614155
  # 0703614167
  # 0706614184
  # 0706614818
  # 0707614218
  # 0707614226
  # 0707614234
  # 0707614285
  # 0707614293
  # 0708610089
  # 0708614246
  # 0708614319
  # 0708614327
  # 0708614335
  # 0708614866
  # 0709610015
  # 0709614037
  # 0709614045
  # 0709614096
  # 0709614118
  # 0709614126
  # 0709614169
  # 0709614215
  # 0709614231
  # 0709614258
  # 0709614304
  # 0709614347
  # 0709614398
  # 0709614401
  # 0709614428
  # 0709614452
  # 0709614495
  # 0709614568
  # 0709614592
  # 0709614673
  # 0709614738
  # 0709614754
  # 0709614762
  # 0710614326
  # 0711614354
  # 0712614382
  # 0712614455
  # 0901414025
  # 0901414084
  # 0904414131
  # 0905414143
  # 0909610028
  # 0912414426
  # 1303814074
  # 1306814172
  # 1306814180
  # 1307610015
  # 1312814362

end