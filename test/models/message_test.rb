# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  body          :text
#  spam          :boolean
#  stripped_body :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  front_id      :string           not null
#

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
