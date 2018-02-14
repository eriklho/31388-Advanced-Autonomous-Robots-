
global curr_pose ;
global ts;
global Rpar;
global linear_vel; 
global table1;
global table2;

curr_pose = [0;0;0]; % current position [ x, y, theta]
Rpar = [0.26;0.035;0.035]; % [wheel separation, right wheel radius, left wheel radius]  
ts = 0.01; % time stamp
linear_vel = []; %[right wheel linear vel, left wheel linear vel]
table1 =[];
table2 =[];


printStar()
clear;
printSquare()
clear;
printHex()
clear;

%%%%%%%%%%NOTE: After each function, buffers has to be cleares, because the
%%%%%%%%%%same array using everyhere%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Function draws the star %%%%%%%%%%
function printStar()
global table1;
for v=1:5
    forward(3,1);
    turn(pi*4/5,0.05);
end

figure;
hold on
for i=1:length(table1)
   plot(table1(i), table1(i,2), 'o')
end
end


%%%%%%%%%% Function draws the hexagon %%%%%%%%%%
function printHex()
global table1;
for v=1:6
    forward(3,1);
    turn(pi/3,0.05);
end

figure;
hold on
for i=1:length(table1)
   plot(table1(i), table1(i,2), 'o')
end

end

%%%%%%%%%% Function draws the square %%%%%%%%%%
function printSquare()
global table1;

forward(5,5)
turn(pi/2, 0.05)
forward(5,5)
turn(pi/2, 0.05)
forward(5,5)
turn(pi/2, 0.05)
forward(5,5)

figure;
hold on
for i=1:length(table1)
   plot(table1(i), table1(i,2), 'o')
end
end

%%%%%% Function makes move forward with given speed on given distance  %%%%%% 
function y=forward(dist, speed) % Arguments: dist - distance in metres; speed - linear speed for both wheels
global curr_pose ;
global Rpar; 
global ts;
global linear_vel;
global table1;

time = dist/speed; % how many seconds will move
linear_vel = [speed;speed]; 
    for v=0:ts:time
        y = kinupdate(curr_pose,Rpar,ts, linear_vel);
        curr_pose = y;
        table1(end+1,:) = [y(1,1) y(2,1) y(3,1)];   % log table
    end
end

%%%%%% Function turns simulation on rad radians with speed velocity %%%%%%%
function y=turn(rads_turn, speed)  
global curr_pose ;
global Rpar; 
global ts;
global linear_vel;
global table2;
theta = curr_pose(3,1); % theta from global position
 %  turn angle constraint in radians

if rads_turn < 0
    rads = theta - rads_turn;
    linear_vel = [-speed;speed];    
end
if rads_turn > 0
     rads = theta + rads_turn;
     linear_vel = [speed;-speed];
end

    while abs(theta) < rads
        y = kinupdate(curr_pose,Rpar,ts, linear_vel);
        curr_pose = y;
        theta = curr_pose(3,1);
        table2(end+1,:) = [y(1,1) y(2,1) y(3,1)];    
    end
end
  

%%%%%% Function makes move on one time stamp %%%%%%%
function new_pose = kinupdate(pose,robotpar,ts,wheelspeed) % pose - global postion [ x, y, theta]
%robotpar - robots parameters [wheel separation, right wheel radius, left wheel radius] 
%ts -  timestamp
% wheelspeed - linear speed [right wheel, left wheel]

theta = pose(3,1);
lin_speedR = wheelspeed(1,1);
lin_speedL = wheelspeed(2,1);
w = robotpar(3,1);

rotation_matrix = [cos(theta) sin(theta) 0;-sin(theta) cos(theta) 0; 0 0 1]; % rotation matrix
constraint_matrix = [ 1/2 1/2  0 ; 0 0 1 ; 1/w  -1/w  0]; % constraint matrix
wheel_speed = [lin_speedR; lin_speedL; 0] ; % wheel speed matrix
xi = inv(rotation_matrix)*constraint_matrix*wheel_speed; % positions using forward EULER solution.

new_pose = pose + xi*ts; % next position after timestamp

end

    
% % distance by time and timestamps
% for v=0:ts:time
%          rotation_matrix = [cos(theta) sin(theta) 0;-sin(theta) cos(theta) 0; 0 0 1]; 
%          xi = inv(rotation_matrix)*constraint_matrix*wheel_speed;
%          
%         next_pose = current_pose + xi*ts;
%         x = current_pose(1,1);
%         y = current_pose(2,1);
%         theta = current_pose(3,1);
%         x_next = next_pose(1,1);
%         y_next = next_pose(2,1);
%         theta_next = next_pose(3,1);
%         
%         distance = distance + sqrt((x_next-x)^2 +(y_next-y)^2); 
%          
%         table1(end+1,:) = [x y theta distance];
%         
%         current_pose = next_pose;
%         
% end
 


