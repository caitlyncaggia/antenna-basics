% DipoleArray.m (ver 2.0)
% Author:  Greg Durgin                 Date: 27 September 2011
% Modified by Andrew McRae, October 1, 2015
% Updated by Caitlyn Caggia, October 31, 2018
%
% Compute the pattern and electrical parameter for a stack of
% N vertical half-wave dipoles.
clear all; close all;   % initialize

for i=1:5
    % User-defined inputs
    I = 1;                  % current amplitude (Amps)
    N = i;                  % number of stacked half-wave, in-phase dipoles
    M = 200000;             % number of elevation points to plot
    dB_min = -30;           % minimum gain to plot in polar coordinates
    
    % Initialized variables
    M = 2*ceil(M/2);        % ensure M is even
    mu_0 = 4*pi*1e-7;       % permeability of free space (H/m)
    ep_0 = 8.85e-12;        % permittivity of free space (F/m)
    eta = (mu_0/ep_0)^.5;   % impedance of free space (Ohms)
    theta = (0:M)/M * pi;   % generate range of elevation angles (rad)
    
    % Generate power pattern (actually S*r^2)
    S = tan(theta).^2 .* I^2 .* sin(N*pi/2 .* cos(theta)).^2;
    S(1) = 0; S(end)=0;     % zero out nulls due to singularity
    P_tot = sum(S.*sin(theta))*pi/(M+1)*2*pi;   % radiated power (W/m^2)
    D = 4*pi*S/P_tot;                           % compute directivity
    
    % Plotting functions
    figure
    theta_p = (0:(2*M+1))/2/M * 2*pi;       % index with Matlab polar coords
    D_plot = [ fliplr(D(1:M/2)) D fliplr(D(M/2+1:end)) ];
    DdB = max(10*log10(abs(D_plot)),dB_min)-dB_min; % compute log directivity (dB)
    polar(theta_p,DdB);                     % plot the directivity (dB)
    if N == 1
        title('Directivity of a \lambda/2 wire');
    else
        title(sprintf('Directivity of %i \\lambda/2 wire', N));
    end
    axis off;
    
    % Radiation parameter computation
    Gpeak = max(D);                 % peak gain computation
    Rrad = 2*P_tot/(N*I)^2;         % radiation resistance calculation
    hpbw = sum(D >= Gpeak/2)/M*180;      % calculate half-power BW
    
    %Calculate null nearest to main lobe
    mainLobeNull = acos(2/N);
    
    %Find side-lobe level; max that is outside the main lobe nulls
    SLL = max(D(theta < mainLobeNull))/Gpeak;
    
    % Display results
    fprintf('\n\n Wire with %i element(s)', N);
    fprintf('\n Element input current %2.1f A', N*I );
    fprintf('\n ----------------------------------------------');
    fprintf('\n Total radiated power:   %3.1f W/m^2 (%2.1f dBW)', ...
        P_tot, 10*log10(P_tot) );
    fprintf('\n Peak gain:              %3.1f (%2.1f dBi)', ...
        Gpeak, 10*log10(Gpeak) );
    fprintf('\n Half-power beamwidth:   %2.1f deg', hpbw);
    fprintf('\n Side-lobe level:        %2.1f dB', -10*log10(SLL) );
    fprintf('\n Radiation resistance:   %3.1f Ohms', Rrad );
    fprintf('\n Gain-beamwidth product: %3.2f deg', hpbw*Gpeak);
    fprintf('\n\n');
end

