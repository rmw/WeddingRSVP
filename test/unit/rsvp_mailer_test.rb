require 'test_helper'

class RsvpMailerTest < ActionMailer::TestCase
  test "responded" do
    @expected.subject = 'RsvpMailer#responded'
    @expected.body    = read_fixture('responded')
    @expected.date    = Time.now

    assert_equal @expected.encoded, RsvpMailer.create_responded(@expected.date).encoded
  end

  test "postresponse" do
    @expected.subject = 'RsvpMailer#postresponse'
    @expected.body    = read_fixture('postresponse')
    @expected.date    = Time.now

    assert_equal @expected.encoded, RsvpMailer.create_postresponse(@expected.date).encoded
  end

end
