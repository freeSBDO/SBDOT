function [n,nb,mi,me,xy0,a,b,lb,r,s,paxis] = hanging_chain_data ();

%
% [n,nb,mi,me,xy0,a,b,lb,r,s,paxis] = hanging_chain_data ();
%
% Returns data for the hanging chain problem.
%
% Same as data_1a, but with triple floor.

  xy0 = [];
  a   = [];
  b   = [];
  lb  = [];
  r   = [];
  s   = [];

% Initial position of the chain

  xy0 = [ 0.1;  0.3;  0.5;  0.7;
         -0.2; -0.4; -0.4; -0.5];

% Coordinates of the second hook

  a =  1;
  b = -0.1;

% Desired length of the bars

  lb = [0.4 0.3 0.25 0.2 0.4]';

% Floor

  r = [-0.20; -0.40; -0.60];
  s = [-0.60; -0.10;  0.20];

% Plot axis

  paxis = zeros(1,4);
  paxis(1) = -0.05;     % xmin
  paxis(2) =  1.05;     % xmax
  paxis(3) = -0.60;     % ymin
  paxis(4) =  0.30;     % ymax

% Dimensions

  n  = length(xy0);
  nb = 0;
  mi = length(r)*n/2;
  me = length(lb);

end
