# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientDecorator do
  let(:client) { Client.new.extend ClientDecorator }
  subject { client }
  it { should be_a Client }
end
