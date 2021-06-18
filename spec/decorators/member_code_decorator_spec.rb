# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberCodeDecorator do
  let(:member_code) { MemberCode.new.extend MemberCodeDecorator }
  subject { member_code }
  it { should be_a MemberCode }
end
