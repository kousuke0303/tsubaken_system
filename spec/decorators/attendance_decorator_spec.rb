# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttendanceDecorator do
  let(:attendance) { Attendance.new.extend AttendanceDecorator }
  subject { attendance }
  it { should be_a Attendance }
end
