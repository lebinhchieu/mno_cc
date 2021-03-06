class SessionsController < ApplicationController
	layout 'layout_back'

	# Index

		# View
		def index

		end

		# params: purpose (enum: host, campaign, time), date_from, date_to
		# def get_data
		# 	where = []
		# 	case params[:purpose]
		# 	when 'year'
		# 		date_from = Date.strptime(params[:date_from], '%Y') if params[:date_from].present?
		# 		date_to = Date.strptime(params[:date_to], '%Y').next_year if params[:date_to].present?
		# 	when 'month'
		# 		date_from = Date.strptime(params[:date_from], '%m/%Y') if params[:date_from].present?
		# 		date_to = Date.strptime(params[:date_to], '%m/%Y').next_month if params[:date_to].present?
		# 	else
		# 		date_from = Date.strptime(params[:date_from], '%d/%m/%Y') if params[:date_from].present?
		# 		date_to = Date.strptime(params[:date_to], '%d/%m/%Y').next_day if params[:date_to].present?
		# 	end

		# 	if params[:date_from].present? && params[:date_to].present? && date_from > date_to
		# 		date_temporary = date_from
		# 		date_from = date_to
		# 		date_to = date_temporary
		# 	end
			
		# 	if params[:date_from].present?
		# 		where << "created_at > '#{date_from}'"
		# 	end
		# 	if params[:date_to].present?
		# 		where << "created_at < '#{date_to}'"
		# 	end

		# 	sessions = Session.where(where.join(' AND '))

		# 	visitor_data = []
		# 	lead_data = []

		# 	case params[:purpose]
		# 	when 'host'
		# 		sessions.reorder('').group_by{ |s| s.referrer_host_name }.each do |host_name, sessions_by_host_name|

		# 			visitor_count = 0
		# 			lead_count = 0

		# 			sessions_by_host_name.group_by{ |s| s.user_info_type.blank? ? 'visitor' : 'lead' }.each do |status, sessions_by_status|
		# 				if status == 'visitor'
		# 					visitor_count = sessions_by_status.count
		# 				else
		# 					lead_count = sessions_by_status.count
		# 				end
		# 			end

		# 			visitor_data << {
		# 				label: host_name,
		# 				count: visitor_count
		# 			}
		# 			lead_data << {
		# 				label: host_name,
		# 				count: lead_count
		# 			}
		# 		end
		# 	when 'campaign'
		# 		sessions.reorder('').group_by{ |s| s.utm_campaign }.each do |campaign, sessions_by_campaign|

		# 			visitor_count = 0
		# 			lead_count = 0

		# 			sessions_by_campaign.group_by{ |s| s.user_info_type.blank? ? 'visitor' : 'lead' }.each do |status, sessions_by_status|
		# 				if status == 'visitor'
		# 					visitor_count = sessions_by_status.count
		# 				else
		# 					lead_count = sessions_by_status.count
		# 				end
		# 			end

		# 			visitor_data << {
		# 				label: campaign,
		# 				count: visitor_count
		# 			}
		# 			lead_data << {
		# 				label: campaign,
		# 				count: lead_count
		# 			}
		# 		end
		# 	when 'day'
		# 		sessions.group_by{ |s| s.created_at.month.to_s + '/' + s.created_at.day.to_s + '/' + s.created_at.year.to_s }.each do |time, sessions_by_time|

		# 			visitor_count = 0
		# 			lead_count = 0

		# 			sessions_by_time.group_by{ |s| s.user_info_type.blank? ? 'visitor' : 'lead' }.each do |status, sessions_by_status|
		# 				if status == 'visitor'
		# 					visitor_count = sessions_by_status.count
		# 				else
		# 					lead_count = sessions_by_status.count
		# 				end
		# 			end

		# 			visitor_data << {
		# 				label: time,
		# 				count: visitor_count
		# 			}
		# 			lead_data << {
		# 				label: time,
		# 				count: lead_count
		# 			}
		# 		end
		# 	when 'month'
		# 		sessions.group_by{ |s| s.created_at.month.to_s + '/' + s.created_at.year.to_s }.each do |time, sessions_by_time|

		# 			visitor_count = 0
		# 			lead_count = 0

		# 			sessions_by_time.group_by{ |s| s.user_info_type.blank? ? 'visitor' : 'lead' }.each do |status, sessions_by_status|
		# 				if status == 'visitor'
		# 					visitor_count = sessions_by_status.count
		# 				else
		# 					lead_count = sessions_by_status.count
		# 				end
		# 			end

		# 			visitor_data << {
		# 				label: time,
		# 				count: visitor_count
		# 			}
		# 			lead_data << {
		# 				label: time,
		# 				count: lead_count
		# 			}
		# 		end
		# 	when 'year'
		# 		sessions.group_by{ |s| s.created_at.year.to_s }.each do |time, sessions_by_time|

		# 			visitor_count = 0
		# 			lead_count = 0

		# 			sessions_by_time.group_by{ |s| s.user_info_type.blank? ? 'visitor' : 'lead' }.each do |status, sessions_by_status|
		# 				if status == 'visitor'
		# 					visitor_count = sessions_by_status.count
		# 				else
		# 					lead_count = sessions_by_status.count
		# 				end
		# 			end

		# 			visitor_data << {
		# 				label: time,
		# 				count: visitor_count
		# 			}
		# 			lead_data << {
		# 				label: time,
		# 				count: lead_count
		# 			}
		# 		end
		# 	end

		# 	render json: { status: 0, result: { visitors: visitor_data, leads: lead_data } }
		# end

		# Json data
		# params: get (enum: campagin, term, content), by, date_type (enum: day, month, quarter, year)
		def get_data

			params[:date_type] ||= 'day'

			data = {
				date_type: params[:date_type]
			}

			def date_group time
				case params[:date_type]
				when 'month'
					"#{time.year.to_s}/#{time.month.to_s}"
				when 'quarter'
					"#{time.year.to_s}/Q#{(time.month / 3.0).ceil.to_s}"
				when 'year'
					"#{time.year.to_s}"
				else
					"#{time.year.to_s}/#{time.month.to_s}/#{time.day.to_s}"
				end					
			end

			case params[:get]
			when 'campaign'
				session_infos = SessionInfo.where('utm_campaign IS NOT NULL')

				data[:chart] = {}
				data[:table] = {}
				session_infos.order('created_at ASC').group_by{ |s| s.utm_campaign }.each do |utm_campaign, by_campaign|
					data[:chart][utm_campaign] = []
					by_campaign.group_by{ |s| date_group s.created_at }.each do |date, by_date|
						data[:chart][utm_campaign] << {
							date: date,
							count: by_date.count
						}
					end

					data[:table][utm_campaign] = by_campaign.count
				end

			when 'term'
				by_campaign = SessionInfo.where utm_campaign: params[:by]

				data[:chart] = {}
				data[:table] = {}
				by_campaign.order('created_at ASC').group_by{ |s| s.utm_term }.each do |utm_term, by_term|
					data[:chart][utm_term] = []
					by_term.group_by{ |s| date_group s.created_at }.each do |date, by_date|
						data[:chart][utm_term] << {
							date: date,
							count: by_date.count
						}
					end

					data[:table][utm_term] = by_term.count
				end

			when 'content'

				by_term = SessionInfo.where utm_term: params[:by]

				data[:chart] = {}
				data[:table] = {}
				by_term.order('created_at ASC').group_by{ |s| s.utm_content }.each do |utm_content, by_content|
					data[:chart][utm_content] = []
					by_content.group_by{ |s| date_group s.created_at }.each do |date, by_date|
						data[:chart][utm_content] << {
							date: date,
							count: by_date.count
						}
					end

					data[:table][utm_content] = by_content.count
				end

			else
				return render json: { status: 1 }
			end

			render json: { status: 0, result: data }
		end

	# / Index

end