# frozen_string_literal: true

require 'test_helper'

class SupplierDecoratorTest < ActiveSupport::TestCase
  def setup
    @supplier = Supplier.new.extend SupplierDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
