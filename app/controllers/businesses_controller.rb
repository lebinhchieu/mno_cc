class BusinessesController < ApplicationController
  layout 'layout_front'

  def index

  end

  def manager
  	render layout: 'layout_back'
  end

  def create
  	render layout: 'layout_back'
  end
  
  def create_category
  	render layout: 'layout_back'
  end
end
