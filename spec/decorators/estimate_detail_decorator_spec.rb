# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EstimateDetailDecorator do
  let(:estimate_detail) { EstimateDetail.new.extend EstimateDetailDecorator }
  subject { estimate_detail }
  it { should be_a EstimateDetail }
end
