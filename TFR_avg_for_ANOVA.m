clear; clc;
% load subj list
subj = load('subj.txt');
subj_num = length(subj);

% load the data before grandaverage, to extract the avg TFR in each ROI
load('D:\\TFA\avgTFR_all_bl\allTFR2.mat', 'allTFR2');
load('D:\\TFA\avgTFR_all_bl\allTFR4.mat', 'allTFR4');
load('D:\\TFA\avgTFR_all_bl\allTFR8.mat', 'allTFR8');
load('D:\\TFA\avgTFR_all_bl\allTFR16.mat', 'allTFR16');
load('D:\\TFA\avgTFR_all_bl\allTFR32.mat', 'allTFR32');
load('D:\\TFA\avgTFR_all_bl\allTFR64.mat', 'allTFR64');

% roi1: P7,8 PO7,8    [43 51 52 58],    200~240ms [71: 75], 5.2~6Hz [5: 6]
% roi2: O2,P8,PO4,6,8 [51 56 57 58 62], 250~300ms [76: 81], 5.2~6HZ [5: 6]
% roi3: F7            [6],              220~270ms [73: 78], 10~18Hz [10: 18]
% O1、OZ、POZ、PO5、PO7、(PO6、PO8 57 58)[60 61 57 58 55 53 52]; FT7\FC5\F5\f7 [6 7 15 16]
ROI_name = 'ROI3_F7_Alpha_beta_220_270';
Chan = [6];
Time = [73: 78];
Freq = [10: 18];
Size = length(Chan) * length(Time) * length(Freq);

% calculate the avg of the ROI region
avgpow = zeros(subj_num, 6); % 6 conditions
for i = 1: subj_num
     avgpow(i,1) = sum(allTFR2{1,i}.powspctrm(Chan, Freq, Time), 'all')/Size;
     avgpow(i,2) = sum(allTFR4{1,i}.powspctrm(Chan, Freq, Time), 'all')/Size;
     avgpow(i,3) = sum(allTFR8{1,i}.powspctrm(Chan, Freq, Time), 'all')/Size;
     avgpow(i,4) = sum(allTFR16{1,i}.powspctrm(Chan, Freq, Time), 'all')/Size;
     avgpow(i,5) = sum(allTFR32{1,i}.powspctrm(Chan, Freq, Time), 'all')/Size;
     avgpow(i,6) = sum(allTFR64{1,i}.powspctrm(Chan, Freq, Time), 'all')/Size;
end

save(['D:\\TFA\' ROI_name '.mat'], 'avgpow');
xlswrite(['D:\\TFA\' ROI_name '.xls'], avgpow);