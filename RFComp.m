% RFComp.m
% written by jared kofron <jared.kofron@gmail.com>
% The RFComp class represents a noisy RF component, and is intended
% for use with the RFCasc class.  Do better later.
classdef RFComp
% properties
properties
    name; % readable name of object
    nf; % noise figure in dB
    g; % gain in dB
    t; % physical temperature of component
    nt; % noise temperature of component
end % properties

% methods
methods
    % constructor
    function obj = RFComp(name,varargin)
        % convert noise figure to temp
        nf_2_t = @(phys_t,nf) phys_t*(10^(nf/10)-1);

        % convert gain in dB to relative power
        db_2_pw = @(dB) 10^(dB/10);

        % parse inputs
        p = inputParser;
        p.addRequired('name',@ischar);
        p.addOptional('nf',99,@isnumeric);
        p.addOptional('nt',-99,@isnumeric);
        p.addOptional('g',0,@isnumeric);
        p.addOptional('t',290,@isnumeric);
        p.parse(name,varargin{:});
        % OK.  now some utility vars.
        has_t = ~(p.Results.t == 290);
        has_nt = ~(p.Results.nt == -99);
        has_g = ~(p.Results.g == 0);
        has_nf = ~(p.Results.nf == 99);

        % We need to know either noise figure or noise temperature
        % and gain.
        if ~has_nf && ~has_g 
            error('p8:rfcomp:bad_param',['You must specify either ' ...
                                'noise figure or gain!']);
        elseif has_nf && ~has_g
            w_str = sprintf(['Gain not specified for component: %s. ' ...
                             ' Using negative noise figure...'],name);
            warning(w_str);
            obj.g = -p.Results.nf;
            has_g = true;
        elseif has_g && ~has_nf && ~has_nt
            w_str = sprintf(['Noise figure not specified for component: %s. ' ...
                             ' Using gain...'],name);
            warning(w_str);
            if p.Results.g < 0
                obj.nf = -p.Results.g;
            else
                obj.nf = p.Results.g;
            end
            has_nf = true;
        end

        % if nf isn't set, get it.
        if isempty(obj.nf)
            obj.nf = p.Results.nf;
        end

        % set temperature of device
        if isempty(obj.t)
            obj.t  = p.Results.t;
        end

        % check and set noise temperature
        if isempty(obj.nt) 
            obj.nt = p.Results.nt;
        end

        % If we have NF, we need NT.  For that
        % we need physical T, unless of course NT
        % has been provided.
        if has_nf && ~has_nt
            obj.nt = nf_2_t(obj.t,obj.nf);
        elseif ~has_nf && has_g && ~has_nt
            obj.nt = nf_2_t(p.Results.t,p.Results.g);
            obj.nf = 10*log10(1+obj.nt/obj.t);
        elseif ~has_nf && has_nt
            obj.nf = 10*log10(1+obj.nt/obj.t);
        elseif ~has_nf && ~has_nt && ~has_g
            error('p8:rfcomp:bad_param',['You must specify either ' ...
                                'noise figure or noise temperature!']);
        end

        if isempty(obj.name)
            obj.name = p.Results.name;
        end

        if isempty(obj.g)
            obj.g  = p.Results.g;
        end
        
    end
end % methods

end % classdef