clear; clc;
% load the subj list
subj = load('subj.txt');
subj_num = length(subj);

% load the toolboxes
eeglab;
addpath(genpath('D:\MATLAB\toolbox\fieldtrip'));

for i = 1 : subj_num
    %% load data & transfer
    % https://www.fieldtriptoolbox.org/tutorial/continuous/
    subj_id = num2str(subj(i));   
    % Load the EEG data that has deleted the rejected trials
    filepath = ['D:\TFA\06.reject2\', subj_id, 'reject2.set']; 
    
    cfg                         = [];
    cfg.dataset                 = filepath;
    data_all                    = ft_preprocessing(cfg); % Load EEG data
    
    % eeglab;
    EEG = pop_loadset( 'filename',[subj_id 'reject2.set'],'filepath',['D:\\TFA\\06.reject2\\']);
    EEG = eeg_checkset( EEG );
    dataPre = eeglab2fieldtrip(EEG, 'preprocessing'); % for trial indices
    %% segment the trial
    cfg=[];
    cfg.trials = (dataPre.trialinfo.type == 2);
    data2 = ft_selectdata(cfg, data_all);
    
    cfg.trials = (dataPre.trialinfo.type == 4);
    data4 = ft_selectdata(cfg, data_all);
    
    cfg.trials = (dataPre.trialinfo.type == 8);
    data8 = ft_selectdata(cfg, data_all);
    
    cfg.trials = (dataPre.trialinfo.type == 16);
    data16 = ft_selectdata(cfg, data_all);
    
    cfg.trials = (dataPre.trialinfo.type == 32);
    data32 = ft_selectdata(cfg, data_all);
    
    cfg.trials = (dataPre.trialinfo.type == 64);
    data64 = ft_selectdata(cfg, data_all);
    %% wavelet [1-30Hz] TFA
    % wavelet [30-100Hz], width = 7, foi = 30:1:100, toi =-0.5:0.01:2
    % https://www.fieldtriptoolbox.org/tutorial/timefrequencyanalysis/
    cfg            = [];
    cfg.output     = 'pow';
    cfg.channel    = 'all';
    cfg.method     = 'wavelet';
    cfg.width      = 3;   % default:7£» If cycle£ºcfg.width = linspace(3, 10, 57)
    cfg.foi        = 1:1:30; % 1Hz steps
    cfg.toi        = -0.5:0.01:2; % Time step
%     cfg.keeptrials = 'yes'; % keep single trials or not
    
    % TFA 
    TFR2  = ft_freqanalysis(cfg, data2);
    TFR4  = ft_freqanalysis(cfg, data4);
    TFR8  = ft_freqanalysis(cfg, data8);
    TFR16 = ft_freqanalysis(cfg, data16);
    TFR32 = ft_freqanalysis(cfg, data32);
    TFR64 = ft_freqanalysis(cfg, data64);
    
    % baseline normalisation
    cfg.baseline   = [-0.5, -0.1];
    cfg.baselinetype  = 'db'; 
    TFR2_bl  = ft_freqbaseline(cfg, TFR2);
    TFR4_bl  = ft_freqbaseline(cfg, TFR4);
    TFR8_bl  = ft_freqbaseline(cfg, TFR8);
    TFR16_bl = ft_freqbaseline(cfg, TFR16);
    TFR32_bl = ft_freqbaseline(cfg, TFR32);
    TFR64_bl = ft_freqbaseline(cfg, TFR64);
    %% save data
    save(['D:\TFA\TFR_low\',subj_id, 'TFR2.mat'], 'TFR2'); 
    save(['D:\TFA\TFR_low\',subj_id, 'TFR4.mat'], 'TFR4'); 
    save(['D:\TFA\TFR_low\',subj_id, 'TFR8.mat'], 'TFR8'); 
    save(['D:\TFA\TFR_low\',subj_id, 'TFR16.mat'], 'TFR16'); 
    save(['D:\TFA\TFR_low\',subj_id, 'TFR32.mat'], 'TFR32'); 
    save(['D:\TFA\TFR_low\',subj_id, 'TFR64.mat'], 'TFR64'); 
    
    save(['D:\TFA\TFR_low\',subj_id, 'TFR2_bl.mat'],'TFR2_bl');
    save(['D:\TFA\TFR_low\',subj_id, 'TFR4_bl.mat'],'TFR4_bl');
    save(['D:\TFA\TFR_low\',subj_id, 'TFR8_bl.mat'],'TFR8_bl');
    save(['D:\TFA\TFR_low\',subj_id, 'TFR16_bl.mat'],'TFR16_bl');
    save(['D:\TFA\TFR_low\',subj_id, 'TFR32_bl.mat'],'TFR32_bl');
    save(['D:\TFA\TFR_low\',subj_id, 'TFR64_bl.mat'],'TFR64_bl');
end   