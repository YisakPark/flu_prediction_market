class StaticPagesController < ApplicationController
  def home
  end

  def help
    @securities = Security.where(group: "EB1")
  end
end
