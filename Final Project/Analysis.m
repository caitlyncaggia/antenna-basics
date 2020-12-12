%% ECE 4370 Final Project
% Group 9

clear all; close all;

%% Inputs

% Given parameters
hTx = 0.20; % Height of transmitter [meters]
PtW = 700; % Transmit Power [Watts]
Gt = 20; % Transmit Gain [dBi]
lambda = 3e8/5.8e9; % Wavelength [meters]

% Simulation Results
Gr = 12.6; % Received Gain [dBi]
Za = 21.7 + 1i*0.17; % Antenna Impedance [Ohms]
Ra = real(Za); % Antenna Resistance [Ohms]

% Measurements/Design Parameters
hRx = 0.20; % Height of receiver [meters]
gearr = 50/8; % Gear ratio between motor and wheels
wheeld = 0.03175; % Wheel diameter [meters]
mass = 0.055; % Mass of the car [kilograms]

% Assumptions
effRF = 0.5; % Assume rectifier circuit is about 50% efficient
effm = 0.5; % Assume motor is about 50% efficient
Zm = 3/30e-3; % Impedance of load (motor) (3 V / no-load 30 mA)
g = 9.8; % Acceleration due to gravity
mu = 0.015; % Coefficient of rolling friction


%% Calculations

Pr = 0; % Start with everything discharged 
d = 1; % Start 1 meter away from source
deltat = 15/500; % Time step

for t = linspace(1,15,500)
    
    % Link Budget
    r = sqrt((d)^2 + (hTx-hRx)^2); % 2D distance from Tx to Rx in meters
    Pr = 10*log10(PtW) + Gr + Gt - 20*log10(4*pi/lambda) - 20*log10(r);
    PrW = 10^(Pr/10); % Convert back to Watts
    
    % Voltage to DC Motor
    Va = 2*abs(Zm)*sqrt(2*Ra*PrW)/abs(Za+Zm); % Voltage across antenna
    Vm = effRF*Va; % Voltage across load (motor)
    Im = PrW/Vm; % Current across load (motor)
    Pmotor = Vm*Im; % Power to wheels
    
    % Force to Wheels
    rpm = (abs(3-Vm)/3)*70000; % 3V DC motor, 70000 rpm
    torqueM = (Im*Vm*effm*60)/(rpm*2*pi); % Torque from motor
    torqueW = gearr*torqueM; % Torque to wheels considering gear ratio
    Fmotor = torqueW/(wheeld/2); % Forward force of wheels   
    Ffriction = mass*g*mu; % Frictional force
    Fnet = Fmotor - Ffriction; % Net force
    
    % Distance Traveled
    deltad = Pmotor / Fnet * deltat; % Distance gained
    
    if isnan(deltad) || PrW < 1e-8
        break
    else
        d = d+deltad;
    end
    
end

sprintf('Distance traveled is %f meters.', d-1)