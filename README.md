# Go/No-Go DeepLabCut

This repository contains analysis and plotting code used for the DeepLabCut data in *Grima et al., (2022)*: [paper](https://www.nature.com/articles/s41386-022-01312-6)

Notes: 
- Currently only works on Windows thanks to VideoReader not working on Mac (yet?)
- This is very bespoke code, written to tackle issues with aligning video and behaviour, as well as analysing and plotting the DLC data itself once extracted
- The files for plotting can be used independent of the files for analysis (though some functions may overlap).
- In some (most...) areas is poorly commented/formatted. If you have any questions, feel free to contact at: grimal@janelia.hhmi.org 

## Analysis
***DLC_gonogo_master***.      
Calls *DLC_filesort* to identify behaviour sessions that have DLC data counterparts. Depends on *get_dlc_filenames* and *get_exp_filenames_dlc*.  
Calls *DLC_extract* to first deal with aligning MED-PC and DLC data. Then generates a struct, all_dlc, containing all relevant DLC and behaviour data for analysis. This also depends on a few other functions:   
  - *get_event_times*:    returns timestamps for errors and cues. Dependent on *mpc_read_data*
  - *DLC_preproc*:        reads DLC data and interpolates. Dependent on *DLC_RawRead_gonogo* and *interpolateLowConfidence*
  - *DLC_findpeaks*:      identifies peaks in average luminance for video/behaviour alignment 
  - *videoframets*:       not OG, but a function that returns timestamps of video frames in a video file
  - *DLC_framenumber*:    converts behaviour timestamps into DLC frame numbers 
  - *DLC_plotbox*:        finds median points of DLC-labelled box features (poke, levers, etc.)
  
## Plotting
***DLC_gonogo_master_plotting***.   
Key functions:  
- *DLC_get_event_latency* for the latency from cue onset to a specific behavioural event (e.g. first lever press).
- *DLC_tracking_window* for normalised x,y co-ordinates in a time window.
- *DLC_3D_pdf* for calculating a pdf of occupation of each bin, when the box is divided into a grid. Can also plot.
- *DLC_traj_len* for calculating the total distance travelled each trial.
- *DLC_timecourse* for calculating the timecourse of travel in a trial.
- *DLC_plot_ind_traj_outcome* for plotting each trial's trajectory split by outcome (success or failure).
- *DLC_occupation* for calculating the proportion of trials a rat enters a specified x,y bin. 
- *DLC_cum_occupation* for calculating cumulative probability of visiting a box feature. 
- *DLC_compare_first_idxs* for calculating proportion of trials an animal visits a feature first, or if it's the only place they go, etc. Depends on *DLC_first_entry_idxs*. 














