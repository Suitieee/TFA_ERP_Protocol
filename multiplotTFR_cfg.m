function [cfg] = multiplotTFR_cfg(cfg, stat_t_freq, cap, x_lim, y_lim, z_lim, f)
    cfg.maskparameter = 'mask'; % logical
    cfg.maskstyle     = 'outline'; % outline the ROI
    cfg.colorbar      = 'yes'; 
    cfg.showlabels    = 'yes';
    cfg.xlim          = x_lim;  %toi
    cfg.ylim          = y_lim;   %foi
    cfg.zlim          = z_lim; 
    cfg.layout        = cap; % 'biosemi64.lay';

    stat_t_freq.fsample = f;
    
    figure;
    ft_multiplotTFR(cfg, stat_t_freq);