class AppraisalCompaniesController < ApplicationController
  layout 'layout_back'
  skip_before_filter :verify_authenticity_token

# Create

  # View
  # params: id
  def create
  	if params.has_key? :id
  		begin
  			@ac = AppraisalCompany.find params[:id]
  		rescue
  			@ac = AppraisalCompany.new
  		end
  	else
  		@ac = AppraisalCompany.new
  	end

  	if @ac.new_record?
  		authorize! :create, AppraisalCompany
  	else
  		authorize! :edit, @ac
  	end
  end

  # Handle
  # params: appraisal company form
  def save
    if params[:ac].has_key? :id
      begin
        ac = AppraisalCompany.find params[:ac][:id]
      rescue
        return render json: { status: 1 }
      end
    else
      ac = AppraisalCompany.new
    end

    result = ac.save_with_params params[:ac]

    if result[:status] != 0
      render json: result
    else
      render json: { status: 0, result: ac.id }
    end
  end

# / Create

# Manager

  # View
  def manager
    # Author
    authorize! :manager, AppraisalCompany

    @acs = AppraisalCompany.all
  end

  # Partial view
  def _manager_list
    # Author
    return render json: { staus: 6 } if cannot? :manager, AppraisalCompany

    per = Rails.application.config.item_per_page

    if params[:keyword].blank?
      acs = AppraisalCompany.all
    else
      acs = AppraisalCompany.search(params[:keyword])
    end

    count = acs.count

    return render json: { status: 1 } if count === 0

    render json: {
      status: 0,
      result: {
        list: render_to_string(partial: 'appraisal_companies/manager_list', locals: { acs: acs.page(params[:page].to_i, per) }),
        pagination: render_to_string(partial: 'shared/pagination', locals: { total: count, per: per })
      }
    }
  end

# / Manager

# Autocomplete

  def autocomplete
    acs = AppraisalCompany.search(params[:keyword]).limit(10)

    list = []
    acs.each do |ac|
      list << { value: ac.id, text: ac.name }
    end

    render json: { status: 0, result: list }
  end

# / Autocomplete

# Delete

  # Handle
  # params: id(*)
  def delete
    render json: AppraisalCompany.delete_by_id(params[:id])
  end

# / Delete

# Appraise

  # View
  def appraise
    # Author
    authorize! :view_assigned_list, AppraisalCompany

    @res = AppraisalCompany.get_assigned_real_estates_by_current_user
  end

  # Partial view
  def _appraise_list
    # Author
    return render json: { staus: 6 } if cannot? :view_assigned_list, AppraisalCompany

    per = Rails.application.config.item_per_page

    if params[:keyword].blank?
      res = AppraisalCompany.get_assigned_real_estates_by_current_user
    else
      res = AppraisalCompany.get_assigned_real_estates_by_current_user.search(params[:keyword])
    end

    count = res.count

    return render json: { status: 1 } if count === 0

    render json: {
      status: 0,
      result: {
        list: render_to_string(partial: 'appraisal_companies/appraise_list', locals: { res: res.page(params[:page].to_i, per) }),
        pagination: render_to_string(partial: 'shared/pagination', locals: { total: count, per: per })
      }
    }
  end

  # Handle
  def set_price
    result = AppraisalCompaniesRealEstate.update_price params

    render json: result
  end

# / Appraise

end
