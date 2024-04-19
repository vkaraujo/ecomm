class HomeController < ApplicationController
  NUM_OF_CATEGORIES = 4

  def index
    @main_categories = Category.take(NUM_OF_CATEGORIES)
  end
end
