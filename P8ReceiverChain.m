% P8ReceiverChain.m
% written by jared kofron <jared.kofron@gmail.com>
% This function builds the project 8 receiver chain in terms of
% RFComp and RFCasc and returns the final RFCasc object.  Note that
% this is for a single channel of the receiver!
function p8receiver = P8ReceiverChain()
p8receiver = RFCasc();

% kapton window
k_wind = RFComp('kapton window','nf',0.6,'t',50,'g',-0.6);
p8receiver = p8receiver.add_comp(k_wind);

% NRAO amp
p8receiver = p8receiver.add_comp(RFComp('NRAO amp',...
                                        'nt',25,...
                                        'g',25));

% cable from NRAO to high frequency cascade
p8receiver = p8receiver.add_comp(RFComp('cold to warm cable',...
                                        'nf',9,...
                                        't',200,...
                                        'g',-9));

% quinstar amp QLW-18262530-J0
p8receiver = p8receiver.add_comp(RFComp('quinstar QLW-18262530-J0',...
                                        'nf',2.5,...
                                        't',290,...
                                        'g',30));

% high frequency filter Lorch 4E27-26000
p8receiver = p8receiver.add_comp(RFComp('preselect filter lorch 4E27-26000',...
                                        'nf',0.5,...
                                        't',290,...
                                        'g',-0.5));

% high frequency mixer Miteq TB0426LW1
p8receiver = p8receiver.add_comp(RFComp('miteq mixer TB0426LW1',...
                                        'nf',10,...
                                        't',290,...
                                        'g',-10));

% high frequency output amp Mini-Circuits ZX60-3018G-S+
p8receiver = p8receiver.add_comp(RFComp('high frequency output amp',...
                                        'nf',2.7,...
                                        't',290,...
                                        'g',20));

% low frequency input amps
p8receiver = p8receiver.add_comp(RFComp('low frequency input amp 1',...
                                        'nf',2.7,...
                                        't',290,...
                                        'g',20));

p8receiver = p8receiver.add_comp(RFComp('low frequency input amp 2',...
                                        'nf',2.7,...
                                        't',290,...
                                        'g',20));

% low frequency mixer Polyphase IRM0622B
p8receiver = p8receiver.add_comp(RFComp('polyphase mixer IRM0622B',...
                                        'nf',9,...
                                        't',290,...
                                        'g',-9));

% low frequency DC block filter MC ZFHP-0R055-S+
% loss less than 1.6dB over passband
p8receiver = p8receiver.add_comp(RFComp('DC block ZFHP-0R055-S+',...
                                        'nf',1.6,...
                                        't',290,...
                                        'g',-1.6));

% AA filter MC SLP-90+
p8receiver = p8receiver.add_comp(RFComp('anti-aliasing filter SLP-90+',...
                                        'nf',1,...
                                        't',290,...
                                        'g',-1));

% directional coupler ZX30-17-5-S+
p8receiver = p8receiver.add_comp(RFComp('directional coupler ZX30-17-5-S+',...
                                        'nf',1,...
                                        't',290,...
                                        'g',-1));

% low frequency output amps
p8receiver = p8receiver.add_comp(RFComp('low frequency output amp 1',...
                                        'nf',2.7,...
                                        't',290,...
                                        'g',20));

p8receiver = p8receiver.add_comp(RFComp('low frequency output amp 2',...
                                        'nf',2.7,...
                                        't',290,...
                                        'g',20));
end
