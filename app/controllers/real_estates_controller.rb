class RealEstatesController < ApplicationController
  layout 'layout_front'

  def index
  end

  def demo
  end

  def category

  end

# View
  
  # View
  # params: id(*)
  def view
    begin
      @re = RealEstate.find params[:id]

      session[:real_estate_viewed] ||= []
      unless session[:real_estate_viewed].include? params[:id]
        @re.update(view_count: @re.view_count + 1)
        session[:real_estate_viewed] << params[:id]
      end
    rescue
      redirect_to '/'
    end
  end

# /View

# Create

  # View
  # params: id (if edit)
  def create
    if params.has_key? :id
      begin
        @re = RealEstate.find params[:id]
      rescue
        @re = RealEstate.new
      end
    else
      @re = RealEstate.new
    end
    
    # Author
    if @re.new_record?
      authorize! :create, RealEstate
      @is_appraisal = params.has_key? :appraisal
    else
      authorize! :edit, @re
      @is_appraisal = @re.appraisal_type != 0

      if @re.user_id == 0
        @re.params['remote_ip'] = request.remote_ip
        @re.save
      end
    end

    render layout: 'layout_back'
  end  

  # Handle
  # params: real-estate form
  def save
    is_draft = params.has_key? :draft

    if params[:real_estate][:id].blank?
      params[:real_estate][:user_id] = signed? ? current_user.id : 0
      real_estate = RealEstate.new
    else 
      real_estate = RealEstate.find(params[:real_estate][:id])
      return render json: { status: 1 } if real_estate.nil?
    end

    unless signed?
      params[:real_estate][:remote_ip] = request.remote_ip
    end

    result = real_estate.save_with_params(params[:real_estate], is_draft)

    return render json: result if result[:status] != 0

    if !signed? && params[:real_estate][:id].blank?
      RealEstateMailer.active(real_estate).deliver_later
    end

    render json: { status: 0, result: real_estate.id }
  end

  # Handle => View
  # params: id, secure_code
  def active
    result = RealEstate.active params[:id], params[:secure_code]

    return redirect_to '/' if result[:status] != 0

    @status = result[:result]
    render layout: 'layout_back'
  end

# / Create

  # def preview
  #   @real_estate = RealEstate.create_real_estate params['real_estate']

  #   render json: Hash[status: 1, result: render_to_string(partial: '/real_estates/preview')]
  # end

# My list

  # View
  def my
    # Author
    authorize! :view_my, RealEstate

    @res = RealEstate.where(user_id: current_user.id).order(updated_at: 'desc')

    render layout: 'layout_back'
  end

  # Partial view
  # params: keyword, page
  def _my_list
    # Author
    return render json: { status: 6 } if cannot? :view_my, RealEstate

    per = Rails.application.config.item_per_page

    params[:page] ||= 1
    params[:page] = params[:page].to_i

    if params[:keyword].blank?
      res = RealEstate.where(user_id: current_user.id)
    else
      res = RealEstate.where(user_id: current_user.id).search(params[:keyword])
    end

    count = res.count

    return render json: { status: 1 } if count === 0

    render json: {
      status: 0,
      result: {
        list: render_to_string(partial: 'real_estates/my_list', locals: { res: res.page(params[:page], per) }),
        pagination: render_to_string(partial: 'shared/pagination', locals: { total: count, per: per, page: params[:page] })
      }
    }
  end

  def change_show_status
    RealEstate.update_show_status params[:id], params[:is_show]

    render json: Hash[status: 0]
  end

# / My list

# Pending

  # View
  def pending
    # Author
    authorize! :approve, RealEstate

    @res = RealEstate.get_pending.order(updated_at: 'asc')

    render layout: 'layout_back'
  end

  # Partial view
  # params: keyword
  def _pending_list
    # Author
    return render json: { staus: 6 } if cannot? :approve, RealEstate

    per = Rails.application.config.item_per_page
    
    params[:page] ||= 1
    params[:page] = params[:page].to_i

    if params[:keyword].blank?
      res = RealEstate.get_pending.order(updated_at: 'asc')
    else
      res = RealEstate.get_pending.search(params[:keyword])
    end

    count = res.count

    return render json: { status: 1 } if count === 0

    render json: {
      status: 0,
      result: {
        list: render_to_string(partial: 'real_estates/pending_list', locals: { res: res.page(params[:page], per) }),
        pagination: render_to_string(partial: 'shared/pagination', locals: { total: count, per: per, page: params[:page] })
      }
    }
  end

  # Handle
  # params: id(*)
  def approve   
    render json: RealEstate.update_pending_status(params[:id], 0)
  end

# / Pending

# Appraise

  # View
  def appraise
    # Author
    return render json: { staus: 6 } if cannot? :appraise, RealEstate

    @res = RealEstate.where('appraisal_type <> 0 AND appraisal_price IS NULL').order(updated_at: 'asc')

    render layout: 'layout_back'
  end

  # Partial view
  def _appraise_list
    # Author
    return render json: { staus: 6 } if cannot? :appraise, RealEstate

    per = Rails.application.config.item_per_page

    if params[:keyword].blank?
      res = RealEstate.where('appraisal_type <> 0 AND appraisal_price IS NULL').order(updated_at: 'asc')
    else
      res = RealEstate.where('appraisal_type <> 0 AND appraisal_price IS NULL').search(params[:keyword])
    end

    count = res.count

    return render json: { status: 1 } if count == 0

    render json: {
      status: 0,
      result: {
        list: render_to_string(partial: 'real_estates/appraise_list', locals: { res: res.page(params[:page].to_i, per) }),
        pagination: render_to_string(partial: 'shared/pagination', locals: { total: count, per: per })
      }
    }
  end

  # Handle
  # params: id(*), ac_id(*)
  def set_appraisal_company
    result = AppraisalCompaniesRealEstate.assign params[:id], params[:ac_id]

    if result[:status] != 0
      render json: result
    else
      render json: { status: 0 }
    end
  end
  
# / Appraise

# Delete

  # Handle
  # params: id(*)
  def delete
    result = RealEstate.delete_by_id(params[:id])

    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { render json: result }
    end
  end

# / Delete

# Search

  # Partial view
  # params: 
  #   per, page, price(x;y), real_estate_type, is_full
  #   newest, cheapest
  def search
    res = RealEstate.search_with_params params
    
    params[:per] ||= Rails.application.config.real_estate_item_per_page
    params[:per] = params[:per].to_i

    params[:page] ||= 1
    params[:page] = params[:page].to_i

    render json: {
      status: 0,
      result: {
        list: render_to_string(partial: 'real_estates/item_list', locals: { res: res.page(params[:page], params[:per]) }),
        pagination: render_to_string(partial: 'shared/pagination_2', locals: { total: res.count, per: params[:per], page: params[:page] })
      }
    }
  end

# / Search

end
