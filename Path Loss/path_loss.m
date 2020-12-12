%% ECE 4370
% Homework 4
% 
% Caitlyn Caggia
%
%% Problem 1
% Measurements made in 2D for the first floor only.
% Indoor or 5.5m path loss measurements used.
R = [17.5 15 14.5 13 14 17.5 16 16.5 18.5 9.5 9.5 ...
    10 10.5 12 13.5 20.5 20.5 21 21 21.5 22 22.5];
Pl = [42.5 40.1 45.8 39.6 41.6 51.2 46.7 43.7 51.9 ...
    31.3 33.4 32.4 33.7 31.8 32 40.2 45 51.4 52.6 ...
    51.3 54.4 53.6];

n = sum(Pl .* log10(R)) / (10*sum(log10(R).^2))

N = length(R);
stdev1 = sqrt( 1/N * sum((Pl - 10*n*log10(R)).^2) )

%% Problem 2
% Measurements again made in 2D for the first floor only,
% using values for indoor or 5.5m path loss.
R =  0.5*5*[11.5 11.5 11.75 12 12.5 13 14.5 13.5 14.5 13.25...
    15 15.25 16 16.25 16.5 17.5 16.5 18];
Pl = [38.9 34.2 38.1 37.6 38.9 40.8 49.4 60.7 58.3 50.3...
    59.8 65.3 73.5 55.2 58.4 56.8 70.5 71.6];

A = [0 0; % outside 1
    0 0; % outside 2
    0 0; % outside 3
    0 0; % outside 4
    0 0; % outside 5
    0 0; % outside 6
    1 0; % garage
    1 0; % kitchen
    1 1; % stairwell
    1 0; % sitting room
    1 1; % dining room
    1 2; % foyer
    1 3; % bedroom 1
    1 0; % hallway
    1 1; % living room
    1 2; % bedroom 2
    1 4; % bedroom 1
    1 5]; % back room
    % number of interior / exterior walls
b = Pl - 20*log10(R); 
x = inv(A'*A) * A' * b(:);
fprintf('Loss for interior walls: %f\n',x(1))
fprintf('Loss for exterior walls: %f\n',x(2))

error = A*x - b(:);
var = 1/length(b) * error' * error;
stdev2 = sqrt(var)