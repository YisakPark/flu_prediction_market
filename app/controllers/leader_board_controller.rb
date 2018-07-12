class LeaderBoardController < ApplicationController
  def index
    #get user array sort by asset in descending order and slice array from first upto 10th element
    @user_arr_sort_by_asset = User.get_user_arr_sort_by_asset.slice(0, 10)
  end
end
