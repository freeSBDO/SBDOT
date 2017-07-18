function [coord,ground,init,inter,final] = hanging_chain_plot_params ();

%
% [coord,ground,init,inter,final] = hanging_chain_plot_params ();
%
% This function can be used to set a few plot parameters. To modify the
% parameters, copy this file in the working directory and change the
% settings (files in the Libopt environment should not be modified).

% Specifications for axis

  coord.present = 1;    % with (1) or without (0) axis

% Specifications for the floor/ground

  ground.present = 1;   % with (1) or without (0) the floor/ground (in case there is indeed a floor)
  ground.color   = 0.81*[1 1 1];        % higher for lighter (0.81 is the Matlab gray)

% Specifications for the initial hanging chain

  init.present = 1;     % with (1) or without (0) initial hanging chain
  init.type    = '-';
  init.color   = 'r';
  init.width   = 1;

% Specifications for the intermediate hanging chains

  inter.present = 1;    % with (1) or without (0) intermediate hanging chains
  inter.type = '--';
  inter.color = 'm';
  inter.width = 1;

% Specifications for the final hanging chain

  final.present = 1;    % with (1) or without (0) final hanging chain
  final.type = '-';
  final.color = 'b';
  final.width = 2;

end
