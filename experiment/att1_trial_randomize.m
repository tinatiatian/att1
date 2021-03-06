% Randomized all parameters for the trial


%% Initialize NaN fields of all settings

% New trial initialized
if tid == 1
    % Do nothing
else
    f1 = fieldnames(expsetup.stim);
    ind = strncmp(f1,'esetup', 6) |...
        strncmp(f1,'edata', 5);
    for i=1:numel(ind)
        if ind(i)==1
            if ~iscell(expsetup.stim.(f1{i}))
                [m,n,o]=size(expsetup.stim.(f1{i}));
                expsetup.stim.(f1{i})(tid,1:n,1:o) = NaN;
            elseif iscell(expsetup.stim.(f1{i}))
                [m,n,o]=size(expsetup.stim.(f1{i}));
                expsetup.stim.(f1{i}){tid,1:n,1:o} = NaN;
            end
        end
    end
end

var_copy = struct; % This structure exists for training purposes only


%% Which exp version is running?

expsetup.stim.esetup_exp_version{tid,1} = expsetup.stim.exp_version_temp;


%% Trial duration for lever training

%============
% Modified part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'lever hold training');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = NaN;
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_train_trial_duration = temp1(1); % Copy variable for error trials
end
%=============
expsetup.stim.esetup_train_trial_duration(tid,1) = temp1(1);


%% Lever acquire and maintain durations

% Fixation acquire duration
temp1=Shuffle(expsetup.stim.fixation_acquire_duration);
expsetup.stim.esetup_lever_acquire_duration(tid,1) = temp1(1); % Same as fixation

% Fixation maintain duration (or maintain button press if no eyetracking is done)
temp1=Shuffle(expsetup.stim.fixation_maintain_duration);
expsetup.stim.esetup_lever_maintain_duration(tid,1) = temp1(1); % Same as fixation


%% Fixation position

% Fixation position
expsetup.stim.esetup_fix_coord(tid,1:2) = [expsetup.stim.fixation_position(1), expsetup.stim.fixation_position(2)];


%% How many attention stimuli

% How many attention stimuli
%============
% Modified part part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'introduce distractors');
ind2 = find(ind0==1);
if ind1>ind2
    t1 = expsetup.stim.att_stim_number_max;
elseif ind1==ind2
    t1 = expsetup.stim.att_stim_number_max;
    var_copy.esetup_att_stim_number = t1;
elseif ind1<ind2
    t1 = expsetup.stim.att_stim_number_ini;
end
%=============
expsetup.stim.esetup_att_stim_number(tid,1) = t1;


%% Attention stimulus positions

% How many attention repetitions
t1 = expsetup.stim.esetup_att_stim_number(tid,1);
t2 = expsetup.stim.att_stim_reps;
t_max = expsetup.stim.att_stim_number_max;

% Select locations
a = Shuffle(expsetup.stim.att_stim_arc);
temp1 = a(1:t1); % Select as many objects as there are

% Determine the coordinates/size for each att stimulus repetition
for j = 1:t2
    expsetup.stim.esetup_att_stim_arc(tid, 1:t1, j) = temp1;
    expsetup.stim.esetup_att_stim_radius(tid, 1:t1, j) = expsetup.stim.att_stim_radius;
end


%% Size of attention stimulus

%============
% How many attention repetitions
t1 = expsetup.stim.esetup_att_stim_number(tid,1);
t2 = expsetup.stim.att_stim_reps;
t_max = expsetup.stim.att_stim_number_max;

%=============
% Modified part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'reduce target size');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.att_stim_size);
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_att_stim_size = NaN(1, t_max, t2);
    for j = 1:t2
        var_copy.esetup_att_stim_size(1,1:t1,j) = temp1(1); % Copy variable for error trials
    end
elseif ind1<ind2
    temp1 = Shuffle(expsetup.stim.att_stim_size_ini);
end
%=============

% Determine the coordinates/size for each att stimulus repetition
for j = 1:t2
    expsetup.stim.esetup_att_stim_size(tid, 1:t1, j) = temp1(1);
end


%%  Phase of the att stimulus

%============
% How many attention repetitions
t1 = expsetup.stim.esetup_att_stim_number(tid,1);
t2 = expsetup.stim.att_stim_reps;
t_max = expsetup.stim.att_stim_number_max;

%============
% Modified part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'introduce gabor phase change');
ind2 = find(ind0==1);
if ind1>ind2
    % Calculate phase
    for i = 1:t1
        for j = 1:t2
            expsetup.stim.esetup_att_stim_phase(tid,i,j) = randn;
        end
    end
elseif ind1==ind2
    % Calculate phase
    var_copy.esetup_att_stim_phase = NaN(1,t_max,t2);
    for i = 1:t1
        for j = 1:t2
            temp1 = randn;
            expsetup.stim.esetup_att_stim_phase(tid,i,j) = temp1;
            var_copy.esetup_att_stim_phase(1,i,j) = temp1;
        end
    end
elseif ind1<ind2
    temp1 = randn;
    % Calculate phase
    for i = 1:t1
        for j = 1:t2
            expsetup.stim.esetup_att_stim_phase(tid,i,j) = temp1;
        end
    end
end
%=============


%% Probe location

% Probe location and radius is location no1
expsetup.stim.esetup_probe_arc(tid,1) = expsetup.stim.esetup_att_stim_arc(tid,1,1);
expsetup.stim.esetup_probe_radius(tid,1) = expsetup.stim.esetup_att_stim_radius(tid,1,1);


%% Attention stimulus tilt angle

%============
% How many attention repetitions
t1 = expsetup.stim.esetup_att_stim_number(tid,1);
t2 = expsetup.stim.att_stim_reps;
t_max = expsetup.stim.att_stim_number_max;

% Determine the tilt angle for each att stimulus
temp1=Shuffle(expsetup.stim.att_stim_angle);
for j = 1:t2
    if numel(expsetup.stim.att_stim_angle) >= expsetup.stim.esetup_att_stim_number(tid,1)
        expsetup.stim.esetup_att_stim_angle(tid,1:t1,j) = temp1(1:t1);
    else
        for i = 1:t1
            temp1=Shuffle(expsetup.stim.att_stim_angle);
            expsetup.stim.esetup_att_stim_angle(tid,i,j) = temp1(1);
        end
    end
end

%% Probe tilt angle

% Does probe orientation change or not?
c1=Shuffle(expsetup.stim.probe_change);

%============
% Modified part part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'single target same orientation two rings');
ind2 = find(ind0==1);
if ind1<=ind2
    c1 = 1; % Same orientation stimuli shown only 
end
if strcmp(expsetup.stim.esetup_exp_version{tid}, 'single target orientation change one ring') ||...
        strcmp(expsetup.stim.esetup_exp_version{tid}, 'single target orientation change two rings')
    c1 = 2; % Orientation change stimuli only
end
%=============

% Probe tilt angle

%============
% Modified part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'introduce probe angle difference');
ind2 = find(ind0==1);
if ind1>ind2
    p_diff = expsetup.stim.probe_angle_diff;
elseif ind1==ind2
    p_diff = expsetup.stim.probe_angle_diff;
elseif ind1<ind2
    p_diff = expsetup.stim.probe_angle_diff_ini;
end
%=============


if c1(1)==1 % No probe angle change
    expsetup.stim.esetup_probe_change(tid,1) = c1(1); % Save whether it is probe change or no change
elseif c1(1)==2 % Probe angle change
    a = Shuffle(p_diff); % Difference from probe angle
    b = expsetup.stim.esetup_att_stim_angle(tid,1,1); % First element is probe angle
    temp1 = a(1)+b;
% % %     if temp1<0
% % %         temp1 = temp1+180;
% % %     elseif temp1>=180
% % %         temp1 = temp1-180;
% % %     end
    expsetup.stim.esetup_probe_angle(tid,1) = temp1; % Save probe angle
    j = expsetup.stim.att_stim_reps_probe;
    expsetup.stim.esetup_att_stim_angle(tid,1,j) = temp1; % Over-write with the new probe angle
    expsetup.stim.esetup_probe_change(tid,1) = c1(1); % Save whether it is probe change or no change
end


%% Probe & distractor contrast

%==========
% Determine contrast of the probe
expsetup.stim.esetup_probe_contrast(tid,1) = expsetup.stim.probe_contrast;

%============
% How many attention repetitions
t1 = expsetup.stim.esetup_att_stim_number(tid,1);
t2 = expsetup.stim.att_stim_reps;
t_max = expsetup.stim.att_stim_number_max;

% Distractor contrast

%============
% Fixed part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'introduce distractors');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.distractor_contrast);
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_distractor_contrast = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    temp1 = 0; % No distractors
end
%=============
expsetup.stim.esetup_distractor_contrast(tid,1) = temp1(1);

% Save distractor contrast
for i = 1:t1
    for j = 1:t2
        if i==1 % Probe contrast
            expsetup.stim.esetup_att_stim_contrast(tid,i,j) = expsetup.stim.esetup_probe_contrast(tid,1);
        else  % Distractor contrast
            expsetup.stim.esetup_att_stim_contrast(tid,i,j) = expsetup.stim.esetup_distractor_contrast(tid,1);
        end
    end
end

% Copy distractor contrast in case it is needed
if strcmp(expsetup.stim.esetup_exp_version{tid}, 'introduce distractors')
    var_copy.esetup_att_stim_contrast = NaN(1, t_max, t2);
    for i = 1:t1
        for j = 1:t2
            if i==1 % Probe contrast
                var_copy.esetup_att_stim_contrast(1,i,j) = expsetup.stim.esetup_probe_contrast(tid,1);
            else  % Distractor contrast
                var_copy.esetup_att_stim_contrast(1,i,j) = expsetup.stim.esetup_distractor_contrast(tid,1);
            end
        end
    end
end

%% Probe duration

% Probe duration
temp1 = Shuffle(expsetup.stim.probe_duration);
expsetup.stim.esetup_probe_duration(tid,1) = temp1(1);

% Probe isi varies as a function of training
%============
% Fixed part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'increase probe isi');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.probe_isi);
elseif ind1==ind2
    temp1 = Shuffle(tv1(2).temp_var_current);
    var_copy.esetup_probe_isi = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    temp1 = Shuffle(expsetup.stim.probe_isi_ini);
end
%=============
expsetup.stim.esetup_probe_isi(tid,1) = temp1(1);



%% Attention cue fix soa

% Fixation - att cue soa varies as a function of training

%============
% Fixed part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'increase probe isi');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.att_cue_fix_soa);
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_att_cue_fix_soa = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    temp1 = Shuffle(expsetup.stim.att_cue_fix_soa_ini);
end
%=============
expsetup.stim.esetup_att_cue_fix_soa(tid,1) = temp1(1);


%% Att cue position

% Attention cue position (angle on a circle)
% Same as probe position
expsetup.stim.esetup_att_cue_arc(tid,1) = expsetup.stim.esetup_probe_arc(tid,1);

% Length
%============
% Fixed part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'decrease att cue length');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.att_cue_length);
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_att_cue_length = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    temp1 = Shuffle(expsetup.stim.att_cue_length_ini);
end
%=============
expsetup.stim.esetup_att_cue_length(tid,1) = temp1(1);



%% Response ring position

% Response position (angle on a circle)
temp1=Shuffle(expsetup.stim.response_ring_arc);
expsetup.stim.esetup_response_ring_arc(tid,1) = temp1(1);

% Response radius (distance from center)
temp1=Shuffle(expsetup.stim.response_ring_radius);
expsetup.stim.esetup_response_ring_radius(tid,1) = temp1(1);


%% Response ring sequecne

% Response ring sequence on the trial
if strcmp(expsetup.stim.esetup_exp_version{tid}, 'lever hold training')
    temp1=[NaN,NaN]; % No rings shown during lever hold training
elseif strcmp(expsetup.stim.esetup_exp_version{tid}, 'release lever on long ring')
    temp1=[1,NaN]; % No rings shown during lever hold training
elseif strcmp(expsetup.stim.esetup_exp_version{tid}, 'release lever on big ring')
    temp1=[1,NaN]; % No rings shown during lever hold training
else
    temp1=Shuffle(expsetup.stim.response_ring_sequence);
    if strcmp(expsetup.stim.esetup_exp_version{tid}, 'single target same orientation one ring')
        temp1(temp1==2)=NaN; % Only one ring is shown, random order
    end
    if strcmp(expsetup.stim.esetup_exp_version{tid}, 'single target orientation change one ring')
        temp1(temp1==1)=NaN; % Only one ring is shown, random order
    end
end
expsetup.stim.esetup_response_ring_sequence(tid,:) = temp1;


%%  Response ring duration

%============
% Fixed part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'release lever on long ring');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.response_ring_duration);
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_response_ring_duration = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    temp1 = Shuffle(expsetup.stim.response_ring_duration_ini);
end
%=============
expsetup.stim.esetup_response_ring_duration(tid,1) = temp1(1);


%% Response ring size

%============
% Fixed part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'release lever on big ring');
ind2 = find(ind0==1);
if ind1>ind2
    temp1 = Shuffle(expsetup.stim.response_ring_size_start);
elseif ind1==ind2
    temp1 = Shuffle(tv1(1).temp_var_current);
    var_copy.esetup_response_ring_size_start = temp1(1); % Copy variable for error trials
elseif ind1<ind2
    temp1 = Shuffle(expsetup.stim.response_ring_size_start_ini);
end
%=============
expsetup.stim.esetup_response_ring_size_start(tid,1) = temp1(1);
expsetup.stim.esetup_response_ring_size_end(tid,1) = expsetup.stim.response_ring_size_end;


%% Add background texture?

%============
% Fixed part
ind0 = strcmp(expsetup.stim.training_stage_matrix, expsetup.stim.esetup_exp_version{tid});
ind1 = find(ind0==1);
ind0 = strcmp(expsetup.stim.training_stage_matrix, 'add background texture');
ind2 = find(ind0==1);
if ind1>=ind2
    temp1 = Shuffle(expsetup.stim.noise_background_texture_on);
elseif ind1==ind2
    temp1 = Shuffle(expsetup.stim.noise_background_texture_on);
elseif ind1<ind2
    temp1 = 0;
end
%=============

expsetup.stim.esetup_noise_background_texture_on(tid,1) = temp1(1);


%% If previous trial was an error, then copy settings of the previous trial

if tid>1
    if expsetup.stim.trial_error_repeat == 1 % Repeat error trial immediately
        if  ~strcmp(expsetup.stim.edata_error_code{tid-1}, 'correct')
            f1 = fieldnames(expsetup.stim);
            ind = strncmp(f1,'esetup', 6);
            for i=1:numel(ind)
                if ind(i)==1
                    if ~iscell(expsetup.stim.(f1{i}))
                        [m,n,o]=size(expsetup.stim.(f1{i}));
                        expsetup.stim.(f1{i})(tid,1:n,1:o) = expsetup.stim.(f1{i})(tid-1,1:n,1:o);
                    elseif iscell(expsetup.stim.(f1{i}))
                        expsetup.stim.(f1{i}){tid} = expsetup.stim.(f1{i}){tid-1};
                    end
                end
            end
        end
    end
end

%% Training protocol update
% If previous trial was an error, some stimulus properties are not copied
% (very important, else task will not get easier)

if tid>1
    if expsetup.stim.trial_error_repeat == 1 % Repeat error trial immediately
        if  ~strcmp(expsetup.stim.edata_error_code{tid-1}, 'correct')
            if ~isempty(fieldnames(var_copy))
                f1 = fieldnames(var_copy);
                for i=1:numel(f1)
                    if ~iscell(expsetup.stim.(f1{i}))
                        [m,n,o]=size(var_copy.(f1{i}));
                        expsetup.stim.(f1{i})(tid,1:n,1:o) = var_copy.(f1{i})(1:m,1:n,1:o);
                    elseif iscell(expsetup.stim.(f1{i}))
                        expsetup.stim.(f1{i}){tid} = var_copy.(f1{i});
                    end
                end
            end
        end
    end
end

