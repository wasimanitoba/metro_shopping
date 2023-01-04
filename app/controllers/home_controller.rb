class HomeController < ApplicationController
  def index
    @splash_screen = true
    @items         = JSON.generate(Item.all.map(&:name))
  end
end
