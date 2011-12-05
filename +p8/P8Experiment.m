% P8Experiment.m
% written by jared kofron <jared.kofron@gmail.com>
% The P8Experiment class encapsulates all of the experimental
% parameters relevant to a given run of the detector, such as
% magnetic field, amplifier temperature, gas pressure, and so on.
classdef P8Experiment
% settable properties
    properties
        mainField;
        trapCurrent;
        activePressure;
    end
    % dependent (derived) properties
    properties (Dependent = true, SetAccess = private)
        centerFrequency; % center signal frequency
    end

    % getters & setters
    methods
        % setters
        function obj = set.mainField(obj,val)
            if isequal(size(val),[1 2]) == 0
                error('Magnetic field must have a precision.');
            end
            obj.mainField = val;
        end
        function obj = set.trapCurrent(obj,val)
            if isequal(size(val),[1 2]) == 0
                error('Trap current must have a precision.');
            end
            obj.trapCurrent = val;
        end
        function obj = set.activePressure(obj,val)
            if isequal(size(val),[1 2]) == 0
                error('Active region pressure must have a precision.');
            end
            obj.activePressure = val;
        end
        % get the 'naked' cyclotron frequency for the given
        % experiment.  all frequencies are in rad/s.
        function cfreq = get.centerFrequency(obj)
            q = 1.60217646e-19; % electron charge in C
            m = 9.10938188e-31; % electron mass in kg
            cfreq = q/m*obj.mainField;
        end
        function efreq = edepFrequency(obj,energy) % energy in eV
            restmass = 511.0e3;
            efreq = obj.centerFrequency/(1+energy/restmass);
        end
    end
end