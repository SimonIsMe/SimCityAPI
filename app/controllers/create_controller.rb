require 'pusher'

Pusher.app_id = '33265'
Pusher.key = 'a11a902c4f5c239e34bd'
Pusher.secret = '924769f3f9d2e9e23bb3'

class CreateController < ActionController::Base
    protect_from_forgery


        def area

            if (params['x_from'] == nil ||
                params['y_from'] == nil ||
                params['x_to'] == nil ||
                params['y_to'] == nil)
                render :text => 'Missing parameters'
            else

                $x_from = params['x_from'].to_i;
                $y_from = params['y_from'].to_i;
                $x_to = params['x_to'].to_i;
                $y_to = params['y_to'].to_i;

                if ($x_from > $x_to)
                    $buffor = $x_from;
                    $x_from = $x_to;
                    $x_to = $buffor;
                end
                if ($y_from > $y_to)
                    $buffor = $y_from;
                    $y_from = $y_to;
                    $y_to = $buffor;
                end

                $width = $x_to - $x_from + 1;
                $height = $y_to - $x_from + 1;

                $position_x = [];
                $position_y = [];

                $y = $y_from
                while $y <= $y_to
                    $x = $x_from
                    while $x <= $x_to
                        $position_x << $x;
                        $position_y << $y;
                        $x = $x + 1
                    end
                    $y = $y + 1;
                end;


                $segments = $width * $height
                if ($segments < 0)
                    $segments = $segments * (-1)
                end

                if (session['current'] - $segments * 10 <=  session['current'])

                    session['current'] = session['current'] - $segments * 10

                    Pusher['test_channel'].trigger('buildEvent',
                        {
                            'type' => params['type'].to_i,
                            'position_x' => $position_x,
                            'position_y' => $position_y
                        }
                    )

                    Pusher['test_channel'].trigger('buildEvent',
                       {
                           'type' => 6,
                           'current' => session['current'],
                           'forecast' => 123
                       }
                    )
                end

                #render :text => $position_x
            end

        end

        def road

            #session['current'] = 1000

            if (params['x_from'] == nil ||
                params['y_from'] == nil ||
                params['x_to'] == nil ||
                params['y_to'] == nil)
                render :text => 'Missing parameters'
            else

                $width = (params['x_from'].to_i - params['x_to'].to_i);
                $height = (params['y_from'].to_i - params['y_to'].to_i);

                if $width < 0
                    $width = $width * (-1)
                end

                if $height < 0
                    $height = $height * (-1)
                end

                $x_from =  params['x_from'].to_i;
                $y_from =  params['y_from'].to_i;
                $x_to =  params['x_to'].to_i;
                $y_to =  params['y_to'].to_i;

                if ($x_from < $x_to)
                    $x_tmp_from = $x_from;
                    $x_tmp_to = $x_to;
                    $x2 = $x_from;
                else
                    $x_tmp_from = $x_to;
                    $x_tmp_to = $x_from;
                    $x2 = $x_to;
                end

                if ($y_from <= $y_to)
                    $y_tmp_from = $y_from;
                    $y_tmp_to = $y_to;
                else
                    $y_tmp_from = $y_to;
                    $y_tmp_to = $y_from;
                end

                $position_x = [];
                $position_y = [];

                if ($width > $height)
                    #  leży
                    $x = $x_tmp_from;
                    while $x <= $x_tmp_to
                        $position_x << $x;
                        $position_y << $y_from;
                        $x = $x + 1;
                    end

                    $y = $y_tmp_from;
                    while $y <= $y_tmp_to
                        $position_x << $x_to;
                        $position_y << $y;
                        $y = $y + 1
                    end

                else
                    #  stoi lub kwadrat
                    $x = $x_tmp_to;
                    while  $x >= $x_tmp_from;
                        $position_x << $x;
                        $position_y << $y_to;
                        $x = $x - 1;
                    end

                    $y = $y_tmp_to;
                    while $y >= $y_tmp_from
                        $position_x << $x_from;
                        $position_y << $y;
                        $y = $y - 1
                    end

                end

                Pusher['test_channel'].trigger('buildEvent',
                     {
                         'type' => 1,
                         'position_x' => $position_x,
                         'position_y' => $position_y
                     }
                )

                $segments = $width + $height + 1
                session['current'] = session['current'] - $segments * 5
                Pusher['test_channel'].trigger('buildEvent',
                   {
                        'type' => 6,
                        'current' => session['current'],
                        'forecast' => 123
                   }
                )
            end
        end

end
