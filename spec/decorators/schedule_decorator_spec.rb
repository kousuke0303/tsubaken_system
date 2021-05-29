# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleDecorator do
  let(:schedule) { Schedule.new.extend ScheduleDecorator }
  subject { schedule }
  it { should be_a Schedule }
end
