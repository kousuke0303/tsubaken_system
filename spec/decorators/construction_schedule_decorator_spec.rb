# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConstructionScheduleDecorator do
  let(:construction_schedule) { ConstructionSchedule.new.extend ConstructionScheduleDecorator }
  subject { construction_schedule }
  it { should be_a ConstructionSchedule }
end
