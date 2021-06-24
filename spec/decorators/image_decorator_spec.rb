# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageDecorator do
  let(:image) { Image.new.extend ImageDecorator }
  subject { image }
  it { should be_a Image }
end
