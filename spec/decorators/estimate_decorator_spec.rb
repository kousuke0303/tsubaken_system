# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EstimateDecorator do
  let(:estimate) { Estimate.new.extend EstimateDecorator }
  subject { estimate }
  it { should be_a Estimate }
end
