class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

        FORBIDDEN_MESSAGE = "You do not have adequate permissions to perform this action"
        VIEW_SONGS = "View songs"
        EDIT_SONGS = "Edit songs"
        DELETE_SONGS = "Delete songs"
        ADD_SONGS = "Add songs"


        private
        def authenticate_team
                set_current_user
                unless @current_user.belongs_to_team?(params[:team_id])
                        return render json: {errors: ["You do not have access to this team's resources"]}, status: 403
                else
                        @current_member = @current_user.memberships.find_by(team_id: params[:team_id])
                end
        end
        def set_current_user
                @current_user = User.find(current_user.id)
        end

        def name_passed?
                params.key?(:name)
        end

        def authenticate_admin
                unless @current_user.is_admin
                        return render  status: 403
                end
        end

        def return_forbidden
                return render json: FORBIDDEN_MESSAGE, status: 403
        end
end
