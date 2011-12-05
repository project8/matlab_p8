% RFCasc.m
% written by jared kofron <jared.kofron@gmail.com>
% An RFCasc object is a representation of an RF cascade.  It is
% fundamentally a list of objects which are assumed to be connected
% in series.  
classdef RFCasc
% properties of the chain.  This is where the components are stored.
properties (SetAccess = private)
    components;
end

% derived properties.  These are calculated every time their
% getters are called due to the dynamic nature of the cascade.
properties (Dependent = true)
    gain;
    noise_t;
end

% yay methods
methods
    % display.  yay!
    function disp(obj)
        ncomps = length(obj.components);
        if ncomps == 0
            fprintf(1,'empty\n');
        end
        for i = 1:length(obj.components)
            el = obj.components(i);
            fprintf(1,['%d) %s (g=%ddB '...
                       'nt=%dK, '...
                       'phys_t=%dK, '...
                       'nf=%ddB)\n'],...
                    i,...
                    el.name,...
                    el.g,...
                    el.nt,...
                    el.t,...
                    el.nf);
        end
    end

    % add a component to the chain.
    function new_c = add_comp(obj,component)
    % OK.  we need to do some checks here.  First, is the thing to
    % be added actually an RFComp?
        if ~isa(component,'p8.RFComp')
            error('p8:rfcasc:bad_param',['Components must be members ' ...
                                'of the RFComp class.']);
        end
        % Next, is the name for this new component taken?
        for el = obj.components
            if strcmp(el.name,component.name) % uh oh
                error('p8:rfcasc:name_taken', ['A component with ' ...
                                    'that name already exists.']);
            end
        end
        % OK, go ahead.
        new_c = obj;
        new_c.components = [obj.components, component];
    end

    % calculate the gain of the system.
    function gain = get.gain(obj)
        gain = 0;
        for el = obj.components
            gain = gain + el.g;
        end
    end

    % calculate the noise temperature of the system
    function noise_t = get.noise_t(obj)
        ncomps = length(obj.components);
        if ncomps == 0
            error('p8:rfcasc:no_noise_t',['Noise temperature undefined ' ...
                                'for cascade with no elements.']);
        end
        noise_t = obj.components(1).nt;
        for el = 2:length(obj.components)
            % we need this.
            db_2_pw = @(dB) 10^(dB/10);
            % calculate gain of chain before this component
            sys_gain = 1;
            for pos = 1:(el-1)
                sys_gain = sys_gain*db_2_pw(obj.components(pos).g);
            end
            % add temp of component divided by total system gain up
            % to this point.
            noise_t = noise_t + obj.components(el).nt/sys_gain;
        end
    end
    
end

end