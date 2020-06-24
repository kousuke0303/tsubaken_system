# frozen_string_literal: true

require 'test_helper'

class MatterDecoratorTest < ActiveSupport::TestCase
  def setup
    @matter = Matter.new.extend MatterDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
