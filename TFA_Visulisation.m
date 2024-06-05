clear; clc;
% load the subj list
subj = load('subj.txt');
subj_num = length(subj);

%% Load the grandaveraged data
load(['D:\\TFA\tfGA_bl\avgTFR2.mat'], 'tf2GA_avg');
load(['D:\\TFA\tfGA_bl\avgTFR4.mat'], 'tf4GA_avg');
load(['D:\\TFA\tfGA_bl\avgTFR8.mat'], 'tf8GA_avg');
load(['D:\\TFA\tfGA_bl\avgTFR16.mat'], 'tf16GA_avg');
load(['D:\\TFA\tfGA_bl\avgTFR32.mat'], 'tf32GA_avg');
load(['D:\\TFA\tfGA_bl\avgTFR64.mat'], 'tf64GA_avg');

%% TopoplotTFR in 6 conditions
% Set the plot scale;
% ROI1 + ROI2: Time = [0.2, 0.3], Freq = [0.2, 0.3], Powr = [-1, 4.9];
% ROI3:        Time = [0.22, 0.27], Freq = [10, 18], Powr = [-3.5, 3.5];
Time = [0.2, 0.3];
Freq = [5.2, 6];
Powr = [-1, 4.9];
fsample = 250; % the sampling rate after preprocessing;
Cap  = 'quickcap64.mat';

cfg = [];
topoplotTFR_cfg(cfg, tf2GA_avg, Cap, Time, Freq, Powr, fsample);
topoplotTFR_cfg(cfg, tf4GA_avg, Cap, Time, Freq, Powr, fsample);
topoplotTFR_cfg(cfg, tf8GA_avg, Cap, Time, Freq, Powr, fsample);
topoplotTFR_cfg(cfg, tf16GA_avg, Cap, Time, Freq, Powr, fsample);
topoplotTFR_cfg(cfg, tf32GA_avg, Cap, Time, Freq, Powr, fsample);
topoplotTFR_cfg(cfg, tf64GA_avg,Cap, Time, Freq, Powr, fsample);

%% statistical differences
% load the statistical difference data
pair_name = '2_8_400ms';
load(['D:\\TFA\stat_t_freq_' pair_name '.mat']); 

% Set the parameters of plotting
Time = [0.5, 10];
Freq = [0, 10]; % [0, 10] or [10, 20]
Powr = [-7, 7];
fsample = 250; % the sampling rate after preprocessing;
Cap  = 'quickcap64.mat';

% plot ttest result
% https://www.fieldtriptoolbox.org/template/layout/#neuroscan-quick-cap
plot_TF = stat_t_freq; % copy the data
plot_TF.stat(plot_TF.mask == 0) = 0; % Set the non-significant points zero

cfg = [];
cfg.parameter     = 'stat'; % plot the t-value
cfg = multiplotTFR_cfg(cfg, plot_TF, Cap, Time, Freq, Powr, fsample);
























%% plot(ft_multiplotTFR, ft_topoplotTFR): stat_t_freq
% plot ttest result
% https://www.fieldtriptoolbox.org/template/layout/#neuroscan-quick-cap
plot_TF = stat_t_freq;
plot_TF.stat(plot_TF.mask == 0) = 0;

pair_name = '2_8_400ms'; % 2_8_400ms
load(['D:\\时频分析_zj\stat_t_freq_' pair_name '.mat'], 'stat_t_freq');

cfg = [];
cfg.parameter     = 'stat'; % plot the t-value
cfg = multiplotTFR_cfg(cfg, plot_TF, data2);

plot_TF_a = tf2GA_avg;
plot_TF_a.powspctrm(plot_TF.mask == 0) = 0;
plot_TF_b = tf8GA_avg;
plot_TF_b.powspctrm(plot_TF.mask == 0) = 0;

tf2GA_avg.powspctrm(isnan(tf2GA_avg.powspctrm)) = 0;
tf8GA_avg.powspctrm(isnan(tf8GA_avg.powspctrm)) = 0;


cfg = [];
% cfg.parameter     = 'stat'; % plot the t-value
cfg = topoplotTFR_cfg(cfg, plot_TF_a, data2);
cfg = topoplotTFR_cfg(cfg, plot_TF_b, data2);
cfg = topoplotTFR_cfg(cfg, tf2GA_avg, data2);
cfg = topoplotTFR_cfg(cfg, tf8GA_avg, data2);

%% TFR: time-frequency difference

tfGA_a = tf2GA;
tfGA_b = tf8GA;
pair_name = '2_8';

cfg = [];
cfg.parameter    = 'powspctrm';
cfg.operation    = '(x1-x2) / (x1+x2)';
tf_difference    = ft_math(cfg,tfGA_a,tfGA_b); 

tfd = tf_difference;
tfd.mask = stat.mask;
tfd.elec    = data2.elec; % load the electrode and the fsample
tfd.fsample = data2.fsample;

save(['D:\\时频分析_zj\tfd_' pair_name '.mat'], 'tfd');

% baseline normalization
cfg.baseline      = [-0.5, -0.1]; % correction:[-0.4, -0.1]
cfg.baselinetype  = 'db';

tfd_bl         = ft_math(cfg,tfGA_a,tfGA_b); 
tfd_bl.mask    = stat.mask;
tfd_bl.elec    = data2.elec; % load the electrode and the fsample
tfd_bl.fsample = data2.fsample;
save(['D:\\时频分析_zj\tfd_bl_' pair_name '.mat'], 'tfd_bl');

% load(['D:\\时频分析_zj\tfd_' pair_name '.mat'], 'tfd');
% load(['D:\\时频分析_zj\tfd_bl_' pair_name '.mat'], 'tfd_bl');

%% plot conditon different (ft_multiplotTFR, ft_singleplotTFR)

cfg               = [];
cfg.zlim          =  [-0.1 0.1];  %'maxabs' 
cfg = multiplotTFR_cfg(cfg, tfd, data2);

cfg               = [];
cfg.zlim          = [-0.1 0.1];  %'maxabs'
cfg = multiplotTFR_cfg(cfg, tfd_bl, data2);

cfg              = [];
cfg.zlim         = 'maxabs';  %'maxabs' [-3 3]
cfg = multiplotTFR_cfg(cfg, tfd_bl, data2); % 差异就在maxabs
title('Aesthetic interface');

cfg = singleplotTFR_cfg(cfg, channel, tfd_bl, data2);

%% 地形图:TFR_BL
cfg = [];
cfg.xlim         = [0.15 0.25];  %toi
cfg.ylim         = [4 7];   %foi
cfg.zlim         = 'maxabs'; 
cfg.marker       = 'on';

cfg = topoplotTFR_cfg(cfg, tfd_bl, data2);

%% 地形图: tf_difference
cfg = [];
cfg.xlim         = [0.4 0.8];
cfg.ylim         = [16 24];
cfg.zlim         = 'maxabs';
cfg.marker       = 'on';

cfg = topoplotTFR_cfg(cfg, tfd, data2);
title('界面美 vs 界面丑');

%% singleplotTFR: TFR_BL
    cfg = [];
    cfg = singleplotTFR_cfg(cfg, 'PO8', tfd_bl, data2);

%% plot(ft_multiplotTFR, ft_topoplotTFR): stat_t_freq
% plot ttest result
% https://www.fieldtriptoolbox.org/template/layout/#neuroscan-quick-cap
plot_TF = stat_t_freq;
plot_TF.stat(plot_TF.mask == 0) = 0;

pair_name = '2_8_400ms'; % 2_8_400ms
load(['D:\\时频分析_zj\stat_t_freq_' pair_name '.mat'], 'stat_t_freq');

cfg = [];
cfg.parameter     = 'stat'; % plot the t-value
cfg = multiplotTFR_cfg(cfg, plot_TF, data2);

plot_TF_a = tf2GA_avg;
plot_TF_a.powspctrm(plot_TF.mask == 0) = 0;
plot_TF_b = tf8GA_avg;
plot_TF_b.powspctrm(plot_TF.mask == 0) = 0;

tf2GA_avg.powspctrm(isnan(tf2GA_avg.powspctrm)) = 0;
tf8GA_avg.powspctrm(isnan(tf8GA_avg.powspctrm)) = 0;


cfg = [];
% cfg.parameter     = 'stat'; % plot the t-value
cfg = topoplotTFR_cfg(cfg, plot_TF_a, data2);
cfg = topoplotTFR_cfg(cfg, plot_TF_b, data2);
cfg = topoplotTFR_cfg(cfg, tf2GA_avg, data2);
cfg = topoplotTFR_cfg(cfg, tf8GA_avg, data2);

%% TFR: time-frequency difference

tfGA_a = tf2GA;
tfGA_b = tf8GA;
pair_name = '2_8';

cfg = [];
cfg.parameter    = 'powspctrm';
cfg.operation    = '(x1-x2) / (x1+x2)';
tf_difference    = ft_math(cfg,tfGA_a,tfGA_b); 

tfd = tf_difference;
tfd.mask = stat.mask;
tfd.elec    = data2.elec; % load the electrode and the fsample
tfd.fsample = data2.fsample;

save(['D:\\时频分析_zj\tfd_' pair_name '.mat'], 'tfd');

% baseline normalization
cfg.baseline      = [-0.5, -0.1]; % correction:[-0.4, -0.1]
cfg.baselinetype  = 'db';

tfd_bl         = ft_math(cfg,tfGA_a,tfGA_b); 
tfd_bl.mask    = stat.mask;
tfd_bl.elec    = data2.elec; % load the electrode and the fsample
tfd_bl.fsample = data2.fsample;
save(['D:\\时频分析_zj\tfd_bl_' pair_name '.mat'], 'tfd_bl');

% load(['D:\\时频分析_zj\tfd_' pair_name '.mat'], 'tfd');
% load(['D:\\时频分析_zj\tfd_bl_' pair_name '.mat'], 'tfd_bl');

%% plot conditon different (ft_multiplotTFR, ft_singleplotTFR)

cfg               = [];
cfg.zlim          =  [-0.1 0.1];  %'maxabs' 
cfg = multiplotTFR_cfg(cfg, tfd, data2);

cfg               = [];
cfg.zlim          = [-0.1 0.1];  %'maxabs'
cfg = multiplotTFR_cfg(cfg, tfd_bl, data2);

cfg              = [];
cfg.zlim         = 'maxabs';  %'maxabs' [-3 3]
cfg = multiplotTFR_cfg(cfg, tfd_bl, data2); % 差异就在maxabs
title('Aesthetic interface');

cfg = singleplotTFR_cfg(cfg, channel, tfd_bl, data2);

%% 地形图:TFR_BL
cfg = [];
cfg.xlim         = [0.15 0.25];  %toi
cfg.ylim         = [4 7];   %foi
cfg.zlim         = 'maxabs'; 
cfg.marker       = 'on';

cfg = topoplotTFR_cfg(cfg, tfd_bl, data2);

%% 地形图: tf_difference
cfg = [];
cfg.xlim         = [0.4 0.8];
cfg.ylim         = [16 24];
cfg.zlim         = 'maxabs';
cfg.marker       = 'on';

cfg = topoplotTFR_cfg(cfg, tfd, data2);
title('界面美 vs 界面丑');

%% singleplotTFR: TFR_BL
    cfg = [];
    cfg = singleplotTFR_cfg(cfg, 'PO8', tfd_bl, data2);
