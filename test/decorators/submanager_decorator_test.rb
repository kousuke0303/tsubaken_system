# frozen_string_literal: true

require 'test_helper'

class SubmanagerDecoratorTest < ActiveSupport::TestCase
  def setup
    @submanager = Submanager.new.extend SubmanagerDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
