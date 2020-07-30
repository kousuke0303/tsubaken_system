# frozen_string_literal: true

require 'test_helper'

class Attendance::SubmanagerDecoratorTest < ActiveSupport::TestCase
  def setup
    @submanager = Attendance::Submanager.new.extend Attendance::SubmanagerDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
