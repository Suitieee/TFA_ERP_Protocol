function [cfg] = topoplotTFR_cfg(cfg, stat_t_freq, Cap, x_lim, y_lim, z_lim,  f)
    
    cfg.maskparameter   = 'mask';
    cfg.maskstyle       = 'outline';
    cfg.colorbar        = 'yes';
    cfg.showlabels      = 'yes';
    cfg.layout          = Cap; % biosemi64.lay
    cfg.xlim            = x_lim;  %toi
    cfg.ylim            = y_lim; % zlim = [-0.00825 0.0085];   %foi
    cfg.zlim            = z_lim;
    stat_t_freq.fsample = f;
    
    figure;
    ft_topoplotTFR(cfg, stat_t_freq);