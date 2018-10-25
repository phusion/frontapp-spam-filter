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

class Message < ApplicationRecord
end
