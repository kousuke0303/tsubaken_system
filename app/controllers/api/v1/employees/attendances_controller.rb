class Api::V1::Employees::AttendancesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api

  # 従業員自身の一月分の勤怠取得
  def index
  end

  # 出退勤登録
  def register
  end
end
