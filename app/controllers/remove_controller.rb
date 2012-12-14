require 'pusher'

Pusher.app_id = '33265'
Pusher.key = 'a11a902c4f5c239e34bd'
Pusher.secret = '924769f3f9d2e9e23bb3'

class RemoveController < ActionController::Base
    protect_from_forgery

        def index

            if (params['x'] == nil ||
                params['y'] == nil)
                render :text => 'Missing parameters'
            else

                Pusher['test_channel'].trigger('buildEvent',
                   {
                       'type' => 0,
                       'x' => params['x'].to_i,
                       'y' => params['y'].to_i,
                   }
                )
            end
        end

end
