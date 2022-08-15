function [dataraw,data] = DLC_preproc(dlc_filename,criterion,filterparts)
%DLC_PREPROC Read in DLC data using DLC_RawRead_gonogo (dataraw) and
%interpolate across low confidence values (data)
[dataraw, bodyparts]  = DLC_RawRead_gonogo(dlc_filename);
[data] = interpolateLowConfidence(dataraw,criterion, filterparts);
end
