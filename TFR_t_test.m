clear; clc;
% load the subj list
subj = load('subj.txt');
subj_num = length(subj);

load('data2.mat');

%% load baselined data & average by all subject
% load individual subject data
allTFR2 = {};
allTFR4 = {};
allTFR8 = {};
allTFR16 = {};
allTFR32 = {};
allTFR64 = {};

%% Baselined
for i=1:subj_num
    subj_id = num2str(subj(i)); 
    
    load(['D:\\TFA\\TFR_low\',subj_id, 'TFR2_bl.mat'], 'TFR2_bl');
    allTFR2{i} = TFR2_bl;    
    
    load(['D:\\TFA\\TFR_low\',subj_id, 'TFR4_bl.mat'], 'TFR4_bl');
    allTFR4{i} =  TFR4_bl;
    
    load(['D:\\TFA\\TFR_low\',subj_id, 'TFR8_bl.mat'], 'TFR8_bl');
    allTFR8{i} =  TFR8_bl;
    
    load(['D:\\TFA\\TFR_low\',subj_id, 'TFR16_bl.mat'], 'TFR16_bl');
    allTFR16{i} =  TFR16_bl;
    
    load(['D:\\TFA\\TFR_low\',subj_id, 'TFR32_bl.mat'], 'TFR32_bl');
    allTFR32{i} =  TFR32_bl;
    
    load(['D:\\TFA\\TFR_low\',subj_id, 'TFR64_bl.mat'], 'TFR64_bl');
    allTFR64{i} =  TFR64_bl;
end  

% save data
save(['D:\\TFA\avgTFR_all_bl\allTFR2.mat'], 'allTFR2');
save(['D:\\TFA\avgTFR_all_bl\allTFR4.mat'], 'allTFR4');
save(['D:\\TFA\avgTFR_all_bl\allTFR8.mat'], 'allTFR8');
save(['D:\\TFA\avgTFR_all_bl\allTFR16.mat'], 'allTFR16');
save(['D:\\TFA\avgTFR_all_bl\allTFR32.mat'], 'allTFR32');
save(['D:\\TFA\avgTFR_all_bl\allTFR64.mat'], 'allTFR64');
%% compute the grand average for each conditions
load(['D:\\TFA\\avgTFR_all_bl\allTFR2.mat'], 'allTFR2');
load(['D:\\TFA\\avgTFR_all_bl\allTFR4.mat'], 'allTFR4');
load(['D:\\TFA\\avgTFR_all_bl\allTFR8.mat'], 'allTFR8');
load(['D:\\TFA\\avgTFR_all_bl\allTFR16.mat'], 'allTFR16');
load(['D:\\TFA\\avgTFR_all_bl\allTFR32.mat'], 'allTFR32');
load(['D:\\TFA\\avgTFR_all_bl\allTFR64.mat'], 'allTFR64');

cfg = [];
cfg.keepindividual = 'yes';

tf2GA =ft_freqgrandaverage(cfg, allTFR2{:});
tf4GA =ft_freqgrandaverage(cfg, allTFR4{:});
tf8GA =ft_freqgrandaverage(cfg, allTFR8{:});
tf16GA =ft_freqgrandaverage(cfg, allTFR16{:});
tf32GA =ft_freqgrandaverage(cfg, allTFR32{:});
tf64GA =ft_freqgrandaverage(cfg, allTFR64{:});

save(['D:\\TFA\tfGA_bl\allTFR2.mat'], 'tf2GA');
save(['D:\\TFA\tfGA_bl\allTFR4.mat'], 'tf4GA');
save(['D:\\TFA\tfGA_bl\allTFR8.mat'], 'tf8GA');
save(['D:\\TFA\tfGA_bl\allTFR16.mat'], 'tf16GA');
save(['D:\\TFA\tfGA_bl\allTFR32.mat'], 'tf32GA');
save(['D:\\TFA\tfGA_bl\allTFR64.mat'], 'tf64GA');

cfg = [];
cfg.keepindividual = 'no';

tf2GA_avg = ft_freqgrandaverage(cfg, allTFR2{:});
tf4GA_avg = ft_freqgrandaverage(cfg, allTFR4{:});
tf8GA_avg = ft_freqgrandaverage(cfg, allTFR8{:});
tf16GA_avg= ft_freqgrandaverage(cfg, allTFR16{:});
tf32GA_avg= ft_freqgrandaverage(cfg, allTFR32{:});
tf64GA_avg= ft_freqgrandaverage(cfg, allTFR64{:});

save(['D:\\TFA\tfGA_bl\avgTFR2.mat'], 'tf2GA_avg');
save(['D:\\TFA\tfGA_bl\avgTFR4.mat'], 'tf4GA_avg');
save(['D:\\TFA\tfGA_bl\avgTFR8.mat'], 'tf8GA_avg');
save(['D:\\TFA\tfGA_bl\avgTFR16.mat'], 'tf16GA_avg');
save(['D:\\TFA\tfGA_bl\avgTFR32.mat'], 'tf32GA_avg');
save(['D:\\TFA\tfGA_bl\avgTFR64.mat'], 'tf64GA_avg');
%% Paired-sample t-tests across all freqbands, all electrodes t-test 

% load grandaveraged data with all trials
load('D:\\TFA\tfGA_bl\allTFR2.mat', 'tf2GA');
load('D:\\TFA\tfGA_bl\allTFR8.mat', 'tf8GA');

tfGA_a = tf2GA;
tfGA_b = tf8GA;
pair_name = '2_8_400ms'; % 400ms means the TFR baseline is the first 400 ms:[-500 -100]

% t-test with correction
cfg           = [];
cfg.method    = 'analytic'; % using a parametric test
cfg.statistic = 'ft_statfun_depsamplesT'; % using dependent samples
cfg.correctm  = 'fdr'; % no multiple comparisons correction or 'bonferroni'or 'fdr'
cfg.alpha     = 0.05;
cfg.frequency = [1 30];
cfg.latency   = [-0.5 2];

% design
Nsub = 90; % number of subject
cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];
cfg.ivar                = 1; % the 1st row in cfg.design contains the independent variable
cfg.uvar                = 2; % the 2nd row in cfg.design contains the subject number

stat_t_freq = ft_freqstatistics(cfg,tfGA_a,tfGA_b);
save(['D:\\TFA\stat_t_freq_' pair_name '.mat'], 'stat_t_freq');

