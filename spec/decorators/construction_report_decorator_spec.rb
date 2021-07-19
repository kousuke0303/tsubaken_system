# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConstructionReportDecorator do
  let(:construction_report) { ConstructionReport.new.extend ConstructionReportDecorator }
  subject { construction_report }
  it { should be_a ConstructionReport }
end
