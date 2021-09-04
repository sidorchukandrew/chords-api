class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

        private
        def authenticate_team
                set_current_user
                unless @current_user.belongs_to_team?(params[:team_id])
                        return render json: {errors: ["You do not have access to this team's resources"]}, status: 403
                end
        end
        def set_current_user
                @current_user = User.find(current_user.id)
        end

        def name_passed?
                params.key?(:name)
        end

        def authenticate_admin
                unless @current_user.is_admin?
                        return render  status: 403
                end
        end
end
