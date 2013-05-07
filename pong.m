%Pong
%Final Project for Art of Engineering by
%Parthiban Loganathan (pl2487)
%"Derek" Xingzhou He (xh2187)
%Brady Pan (bp2395)

function[] = pong()

clc;
clear;

EDGE_WIDTH = 8;
WIDTH = 200;
HEIGHT = 300;
GOAL_SIZE = 110;
GOAL_LEFT = (WIDTH-GOAL_SIZE)/2;
GOAL_RIGHT = WIDTH-(WIDTH-GOAL_SIZE)/2;

%appearance
GRAPH_COLOR = [0.18,0.4,0.58];
WALL_COLOR = [0,0.6,0.85];
SCORE_COLOR = [0.2,0.5,0.7];
BALL_SIZE = 10;
BALL_R = 3;
BALL_COLOR = [0,1,0];
BALL_SHAPE = 'o';

PADDLE_LENGTH = 50;
PADDLE_WIDTH = 2;
PADDLE_EDGE_THICKNESS = 3;
PADDLE_GOAL_DIS = 30;
PADDLE_DIM_X = [0,0,PADDLE_LENGTH,PADDLE_LENGTH,0];
PADDLE_DIM_Y = [0,PADDLE_WIDTH,PADDLE_WIDTH,0,0];
PADDLE_DIM = [PADDLE_DIM_X;PADDLE_DIM_Y];
PADDLE_COLOR = [0.72,0.86,0.98];

%control
game = [];
BALL_VELOCITY = 0.3;
ball = [];
ball_pos = [WIDTH/2, HEIGHT/2];
ball_v = [BALL_VELOCITY, BALL_VELOCITY];
SPEED_LIMIT = 1.5;

paddlePlot1 = [];
paddlePlot2 = [];
PADDLE_VELOCITY = 0.5;
paddle_dir1 = 0;
paddle_dir2 = 0;
paddle1 = [PADDLE_DIM(1,:) + WIDTH/2 - PADDLE_LENGTH/2; PADDLE_DIM(2,:) + PADDLE_GOAL_DIS];
paddle2 = [PADDLE_DIM(1,:) + WIDTH/2 - PADDLE_LENGTH/2; PADDLE_DIM(2,:) + HEIGHT - PADDLE_GOAL_DIS];

%mechanics
p1_score = 0;
p2_score = 0;
SCORE_LIMIT = 3;
playing_flag = 1;

drawField;
waitfor(msgbox(sprintf('Player 1 (bottom) uses left and right arrow keys to move paddle.\nPlayer 2 (top) uses Z and C keys to move paddle.'),'Instructions','help'));


TIMER = timer('TimerFcn',@callBack, 'ExecutionMode', 'fixedRate', 'Period', 0.01);
start(TIMER);

%Called in the thread
    function callBack(obj, event)
        % disp('Called');
        if playing_flag == 1
            updatePaddle;
            updateBall;
            redraw;
        else
            stop(TIMER);
            close(game);
        end
    end
            

%Draw field
    function drawField
        
        %draw figure and graph
        scrsz = get(0,'ScreenSize');
        game = figure('Position',[scrsz(3)/4 scrsz(4)/4 scrsz(4)/2 scrsz(4)/2]);
        set(game, 'Resize', 'off');
        axis([0 WIDTH 0 HEIGHT]);
        axis manual;
        set(gca, 'color', GRAPH_COLOR, 'YTick', [], 'XTick', []);
        hold on;
        
        %edge
        edge_X1 = [GOAL_LEFT,0,0,GOAL_LEFT];
        edge_X2 = [GOAL_RIGHT,WIDTH,WIDTH,GOAL_RIGHT];
        edge_Y1 = [0,0,HEIGHT,HEIGHT];
        edge_Y2 = [HEIGHT,HEIGHT,0,0];
        plot(edge_X1, edge_Y1 , '-','LineWidth', EDGE_WIDTH, 'Color', WALL_COLOR);
        plot(edge_X2, edge_Y2 , '-','LineWidth', EDGE_WIDTH, 'Color', WALL_COLOR);
        
        %ball
        ball = plot(ball_pos(1), ball_pos(2));
        set(ball, 'Marker', BALL_SHAPE);
        set(ball, 'MarkerFaceColor', BALL_COLOR);
        set(ball, 'MarkerEdgeColor', BALL_COLOR);
        set(ball, 'MarkerSize', BALL_SIZE);
        
        %paddles
        paddlePlot1 = plot(PADDLE_DIM, '-', 'LineWidth', PADDLE_EDGE_THICKNESS);
        set(paddlePlot1, 'Color', PADDLE_COLOR);
        paddlePlot2 = plot(PADDLE_DIM, '-', 'LineWidth', PADDLE_EDGE_THICKNESS);
        set(paddlePlot2, 'Color', PADDLE_COLOR);
        
        %score
        t = title(sprintf('P1: %d   P2: %d', p1_score, p2_score), 'Color', SCORE_COLOR);
        set(t, 'FontName', 'Consolas','FontSize', 12);
        
        %key listener
        set(game,'KeyPressFcn', @keyPress, 'KeyReleaseFcn', @keyRelease);
    end

%reset ball
    function resetBall
        ball_pos = [WIDTH/2, HEIGHT/2];
        ball_v = [BALL_VELOCITY, BALL_VELOCITY];
    end

%new game
    function newgame
        p1_score = 0;
        p2_score = 0;
        t = title(sprintf('P1: %d   P2: %d', p1_score, p2_score), 'Color', SCORE_COLOR);
        set(t, 'FontName', 'Consolas','FontSize', 12);
        resetBall;
        playing_flag = 1;
    end

%end game
    function endgame(i)
        playing_flag = 0;
        if i == 1
            button = questdlg('Player 1 Wins. Play again?','Game Over');
        elseif i == 2
            button = questdlg('Player 2 Wins. Play again?','Game Over');
        end
        if strcmp(button, 'Yes') == 1
            newgame;
        elseif strcmp(button, 'No') == 1
            return;
        elseif strcmp(button, 'Cancel') == 1
            return;
        end
    end

%key press
    function keyPress(src, event)
        if strcmp(event.Key, 'leftarrow') == 1
            paddle_dir1 = -1;
        end
        if strcmp(event.Key, 'rightarrow') == 1
            paddle_dir1 = 1;
        end
        if strcmp(event.Key, 'z') == 1
            paddle_dir2 = -1;
        end
        if strcmp(event.Key, 'c') == 1
            paddle_dir2 = 1;
        end
    end

%key release
    function keyRelease(src, event)
        if strcmp(event.Key, 'leftarrow') == 1
            paddle_dir1 = 0;
        end
        if strcmp(event.Key, 'rightarrow') == 1
            paddle_dir1 = 0;
        end
        if strcmp(event.Key, 'z') == 1
            paddle_dir2 = 0;
        end
        if strcmp(event.Key, 'c') == 1
            paddle_dir2 = 0;
        end
    end

%accelerate
    function accelerate
        rand_y = 1 + (1.04-1).*rand(1);
        ball_v(2) = ball_v(2)*rand_y;
        
        if ball_v(1) > SPEED_LIMIT
            ball_v(1) = SPEED_LIMIT;
        end
        if ball_v(2) > SPEED_LIMIT
            ball_v(2) = SPEED_LIMIT;
        end
    end

%redraw ball
    function updateBall
        
        %update position
        ball_pos(1) = ball_pos(1) + ball_v(1);
        ball_pos(2) = ball_pos(2) + ball_v(2);
        
        paddle1_left = paddle1(1,1);
        paddle1_right = paddle1(1,3);
        paddle1_top = paddle1(2,1);
        paddle1_bot = paddle1(2,2);
        
        paddle2_left = paddle2(1,1);
        paddle2_right = paddle2(1,3);
        paddle2_top = paddle2(2,2);
        paddle2_bot = paddle2(2,1);
        
        %goal collision
        if ball_pos(2) - BALL_R < 0
            p2_score = p2_score + 1;
            t = title(sprintf('P1: %d   P2: %d', p1_score, p2_score), 'Color', SCORE_COLOR);
            set(t, 'FontName', 'Consolas','FontSize', 12);
            if(p2_score >= SCORE_LIMIT)
                endgame(2);
            end
            resetBall;
            return;
        elseif ball_pos(2) + BALL_R > HEIGHT
            p1_score = p1_score + 1;
            t = title(sprintf('P1: %d   P2: %d', p1_score, p2_score), 'Color', SCORE_COLOR);
            set(t, 'FontName', 'Consolas','FontSize', 12);
            if(p1_score >= SCORE_LIMIT)
                endgame(1);
            end
            resetBall;
            return;
        end
        
        %paddle 1 collision
        if (ball_pos(1) + BALL_R > paddle1_left) && (ball_pos(1) - BALL_R < paddle1_right) && (ball_pos(2) - BALL_R < paddle1_top) && (ball_pos(2) + BALL_R > paddle1_bot) && ball_v(2) < 0
            ball_pos(2) = paddle1_top + BALL_R + 1;
            ball_v(2) = -1*ball_v(2);
            accelerate;
            return;
        end
        
        if (ball_pos(1) + BALL_R > paddle1_left) && (ball_pos(1) - BALL_R < paddle1_right) && (ball_pos(2) - BALL_R < paddle1_top) && (ball_pos(2) + BALL_R > paddle1_bot) && ball_v(2) > 0
            ball_pos(2) = paddle1_bot - BALL_R - 1;
            ball_v(2) = -1*ball_v(2);
            accelerate;
            return;
        end
        
        %paddle 2 collision
        if (ball_pos(1) + BALL_R > paddle2_left) && (ball_pos(1) - BALL_R < paddle2_right) && (ball_pos(2) - BALL_R < paddle2_top) && (ball_pos(2) + BALL_R > paddle2_bot) && ball_v(2) < 0
            ball_pos(2) = paddle2_top + BALL_R + 1;
            ball_v(2) = -1*ball_v(2);
            accelerate;
            return;
        end
        
        if (ball_pos(1) + BALL_R > paddle2_left) && (ball_pos(1) - BALL_R < paddle2_right) && (ball_pos(2) - BALL_R < paddle2_top) && (ball_pos(2) + BALL_R > paddle2_bot) && ball_v(2) > 0
            ball_pos(2) = paddle2_bot - BALL_R - 1;
            ball_v(2) = -1*ball_v(2);
            accelerate;
            return;
        end
        
        %wall collision
        if (ball_pos(1) - BALL_R < EDGE_WIDTH)
            ball_pos(1) = EDGE_WIDTH + BALL_R + 1;
            ball_v(1) = -1*ball_v(1);
            accelerate;
            return;
        end
        
        if (ball_pos(1) + BALL_R > WIDTH - EDGE_WIDTH)
            ball_pos(1) = WIDTH - EDGE_WIDTH - BALL_R - 1;
            ball_v(1) = -1*ball_v(1);
            accelerate;
            return;
        end
        
        if (ball_pos(2) + BALL_R > HEIGHT - EDGE_WIDTH) && (ball_pos(1) < GOAL_LEFT || ball_pos(1) > GOAL_RIGHT)
            ball_pos(2) = HEIGHT - EDGE_WIDTH - BALL_R - 1;
            ball_v(2) = -1*ball_v(2);
            accelerate;
            return;
        end
        
        if (ball_pos(2) - BALL_R < EDGE_WIDTH)  && (ball_pos(1) < GOAL_LEFT || ball_pos(1) > GOAL_RIGHT)
            ball_pos(2) = EDGE_WIDTH + BALL_R + 1;
            ball_v(2) = -1*ball_v(2);
            accelerate;
            return;
        end
        
    end

%redraw paddle
    function updatePaddle
        
        %update paddle coordinates
        paddle1(1,:) = paddle1(1,:) + (paddle_dir1*PADDLE_VELOCITY);
        paddle2(1,:) = paddle2(1,:) + (paddle_dir2*PADDLE_VELOCITY);
        
        %keep paddle inside field
        %paddle 1
        %for left edge
        if paddle1(1,1) < EDGE_WIDTH
            paddle1(1,:) = PADDLE_DIM(1,:) + EDGE_WIDTH + 1;
        %for right edge
        elseif paddle1(1,3) > WIDTH - EDGE_WIDTH
            paddle1(1,:) = PADDLE_DIM(1,:) + WIDTH - PADDLE_LENGTH - EDGE_WIDTH -1;
        end
        %paddle 2
        %for left edge
        if paddle2(1,1) < EDGE_WIDTH
            paddle2(1,:) = PADDLE_DIM(1,:) + EDGE_WIDTH + 1;
        %for right edge
        elseif paddle2(1,3) > WIDTH - EDGE_WIDTH
            paddle2(1,:) = PADDLE_DIM(1,:) + WIDTH - PADDLE_LENGTH - EDGE_WIDTH -1;
        end
    end

%redraw
    function redraw
        
        set(paddlePlot1, 'Xdata', paddle1(1,:), 'YData', paddle1(2,:));
        set(paddlePlot2, 'Xdata', paddle2(1,:), 'YData', paddle2(2,:));
        set(ball, 'XData', ball_pos(1), 'YData', ball_pos(2));
        drawnow;
    end

end