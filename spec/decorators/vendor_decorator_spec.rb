# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VendorDecorator do
  let(:vendor) { Vendor.new.extend VendorDecorator }
  subject { vendor }
  it { should be_a Vendor }
end
