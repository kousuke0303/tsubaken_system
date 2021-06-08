# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SalesStatusDecorator do
  let(:sales_status) { SalesStatus.new.extend SalesStatusDecorator }
  subject { sales_status }
  it { should be_a SalesStatus }
end
