require 'pusher'

Pusher.app_id = '33265'
Pusher.key = 'a11a902c4f5c239e34bd'
Pusher.secret = '924769f3f9d2e9e23bb3'

class StartController < ActionController::Base

    def index
        session['current'] = 1000;

        Pusher['test_channel'].trigger('buildEvent',
           {
               'type' => 6,
               'current' => session['current'],
               'forecast' => 123
           }
        )
    end

    def update

        Pusher['test_channel'].trigger('buildEvent',
           {
               'type' => 6,
               'current' => session['current'] - 99,
               'forecast' => 123
           }
        )

    end

end
