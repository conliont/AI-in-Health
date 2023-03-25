%% Import the beacons dataset
beacons_dataset = readtable("beacons_dataset.csv");
beacons = beacons_dataset;
load("final_data.mat");

%% Delete all the wrong ids 
for i=height(beacons):-1:1

    id=str2double(beacons.part_id(i));

    if isnan(id) || id<1000 || id>9999 % if part_id is not a 4digit number 
                                       % erase it from the dataset
        beacons(i,:)=[];
    end
end

% %% Homogenous
% % do some preprocessing of the data in order to find the different types of
% % rooms that exist in the dataset and use that knowledge for the dictionary
% % that we make in the next section
% 
% rooms=string.empty; % initialize a string named rooms
% counter=0;          % initialize a counter
% 
% for i=1:height(beacons_dataset)
%      
%    check=beacons_dataset.room(i); 
%    check=lower(check);  % make uppercase to lowercase            
%    check=regexprep(check,'[^a-z]',''); % delete any other character
%     if ~ismember(check,rooms) % if this room is not alreardy read
%        rooms=[rooms,check];   % place it to the rooms
%        counter=counter+1;
%     end
% end

%% Make the room labels as homegenous as possible
% make a dictionary with the basic room labels that we consider as correct
% and as they are found by the code in comments above
% Bed, Bath etc. are used to detect shortened variations 
% and they will also be changed

dictionary = ["Bedroom" "Bathroom" "Kitchen" "Livingroom" "Sitingroom" "Bed" "Bath" "Diningroom" "Dinner" "Entry" "Entrance" "Living"];

% The final table should have only one name for Bedroom, Bathroom, Kitchen, Livingroom, Diningroom, Entrance
% less common rooms are not changed as they do not present many variations
for i=1:height(beacons)
    
    check=beacons.room(i);
    check=lower(check);                 % make all uppercase to lowercase
    check=regexprep(check,'[^a-z]',''); % delete any character not contained 
                                        % within the range of a-z including 
                                        % characters like -
    min_distance = Inf;
    correct_spelling = '';

    for k = 1:length(dictionary)
    
        dict=lower(dictionary(k)); % make all words in the dictionary with lowercase
    
        distance = editDistance(check, dict); % find edit distance between 2 strings
    
        if distance < min_distance
            min_distance = distance;
            correct_spelling = dictionary(k);
        end
    end
    
    if min_distance <= 2
    % Change shortened variation
        if correct_spelling=="Bed"
            correct_spelling=dictionary(1);
        elseif correct_spelling=="Bath"
            correct_spelling=dictionary(2);
        elseif correct_spelling=="Sitingroom" 
            correct_spelling=dictionary(4);
        elseif correct_spelling=="Dinner"
            correct_spelling=dictionary(8);
        elseif correct_spelling=="Entry"
            correct_spelling=dictionary(11);
        elseif correct_spelling=="Living"
            correct_spelling=dictionary(4);    
        end
        beacons.room(i)=cellstr(correct_spelling);
    end
end

%% Generate features
 
total_time = duration(0,0,0);       % initialize the total time the patient
                                    % spent in all the rooms

kitchen_time = duration(0,0,0);     % initialize time spent in kitchen
bathroom_time = duration(0,0,0);    % initialize time spent in bathroom
bedroom_time = duration(0,0,0);     % initialize time spent in bedroom
livingroom_time = duration(0,0,0);  % initialize time spent in livingroom

new_beacons=sortrows(beacons);  % sort our dataset first according 
                                        % to the part_id, then ts_date,
                                        % then ts_time

unique_ids=unique(new_beacons.part_id); % returns the same values as in beacons 
                                        % dataset but with no repititions

new_features=zeros(length(unique_ids),5); %array for generated features
ids=0;

for i=1:height(new_beacons)-1
    id=new_beacons.part_id(i);

    % Detect change in patient
    if ~isequal(id,new_beacons.part_id(i+1))
        % Add generated features to new array, if no time can be calculated
        % we just put zeroes for the patient, this happens for only one
        % entry per patient per day
        ids=ids+1;   
        new_features(ids,1) = str2double(cell2mat(id));
        
        if total_time==0
            new_features(ids,5) = 0;
            new_features(ids,3) = 0;
            new_features(ids,2) = 0;
            new_features(ids,4) = 0;
        else
            new_features(ids,5) = kitchen_time/total_time * 100;
            new_features(ids,3) = bathroom_time/total_time * 100;
            new_features(ids,2) = bedroom_time/total_time * 100;
            new_features(ids,4) = livingroom_time/total_time * 100;
        end
        % Reset counters for the next patient and move on
        total_time = duration(0,0,0);
        kitchen_time = duration(0,0,0);
        bathroom_time = duration(0,0,0);
        bedroom_time = duration(0,0,0);
        livingroom_time = duration(0,0,0);
        continue;
    end

   % for the last entry of a day, we cant be sure of the time spent
   % in the room so we do not consider it
    if ~isequal(new_beacons.ts_date(i),new_beacons.ts_date(i+1))     
    continue;

% This commented part would add the total days passed between entries
% if we wanted to consider it in the calculations
%     date = num2str(new_beacons.ts_date(i));
%     day = str2double(date(end-1:end));
%     month = str2double(date(end-3:end-2));
%     year = str2double(date(1:end-4));
%     nextdate = num2str(new_beacons.ts_date(i+1));
%     nextday = str2double(nextdate(end-1:end));
%     nextmonth = str2double(nextdate(end-3:end-2));
%     nextyear = str2double(nextdate(1:end-4));
%     days = nextday-day + (nextmonth-month)*30 + (nextyear-year)*365;
    
    end
        
 % add the calculated time spent in the room to the total time and to the
 % coresponding counter for the room
     added_time = new_beacons.ts_time(i+1) - new_beacons.ts_time(i);
    
     total_time = total_time + added_time ;
     if new_beacons.room(i)=="Kitchen"
        kitchen_time = kitchen_time + added_time;
     elseif new_beacons.room(i)=="Bathroom"
        bathroom_time = bathroom_time + added_time;
     elseif new_beacons.room(i)=="Bedroom"
        bedroom_time = bedroom_time + added_time;
     elseif new_beacons.room(i)=="Livingroom"
        livingroom_time = livingroom_time + added_time;    
     end
end

% Final calculation for the last patient that could not be done in the loop
% for the last entry we cant measure the time so we dont add it
ids=ids+1;
if total_time==0
    new_features(ids,5) = 0;
    new_features(ids,3) = 0;
    new_features(ids,2) = 0;
    new_features(ids,4) = 0;
else
    new_features(ids,1) = str2double(cell2mat(id));
    new_features(ids,5) = kitchen_time/total_time * 100;
    new_features(ids,3) = bathroom_time/total_time * 100;
    new_features(ids,2) = bedroom_time/total_time * 100;
    new_features(ids,4) = livingroom_time/total_time * 100;
end

% turn final generated feature into a table
percentages=array2table(new_features,'VariableNames',{'part_id','Bedroom_time','Bathroom_time','Livingroom_time','Kitchen_time'});


%% Merging clinical and beacons dataset (the preprocessed ones)
% the merged dataset only contains patients that appeared in both datasets
merged_dataset=innerjoin(final_data,percentages);

save('final_beacons.mat','beacons');
save('merged_dataset.mat','merged_dataset');