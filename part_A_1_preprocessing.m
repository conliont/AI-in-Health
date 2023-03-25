%% Import the clinical dataset to a table 
clinical_dataset = readtable("clinical_dataset.csv");

%% Use an array to store the numerical version of the dataset
numeric=readmatrix("clinical_dataset.csv");

%% Convertion from nominal/categorical to numerical

% columns that contain numerical data to be used later
Numerical=[4 5 6 11 12 14 15 20 21 22 23 24 25 26 27 30 31 32 34 36 37 38 39 40 43 44 47 50 51 52 53 54 55];

for i=1:height(clinical_dataset)
% Fried
    if clinical_dataset.fried(i)== "Non frail"
        numeric(i,2)=0;
    elseif clinical_dataset.fried(i)== "Pre-frail"
        numeric(i,2)=1;
    elseif clinical_dataset.fried(i)=="Frail"
        numeric(i,2)=2;
    else
        numeric(i,2)=NaN;
    end

% Gender
    if clinical_dataset.gender(i)== "F"
        numeric(i,3)=1;
    elseif clinical_dataset.gender(i)== "M"
        numeric(i,3)=2;
    else 
        numeric(i,3)=NaN;
    end

% Ortho hypotension
    if clinical_dataset.ortho_hypotension(i)== "No"
        numeric(i,7)=0;
    elseif clinical_dataset.ortho_hypotension(i)== "Yes"
        numeric(i,7)=1;
    else
        numeric(i,7)=NaN;
    end

% Vision
    if clinical_dataset.vision(i)== "Sees poorly"
        numeric(i,8)=0;
    elseif clinical_dataset.vision(i)== "Sees moderately"
        numeric(i,8)=1;
    elseif clinical_dataset.vision(i)=="Sees well"
        numeric(i,8)=2;
    else
        numeric(i,8)=NaN;
    end

% Audition
    if clinical_dataset.audition(i)== "Hears poorly"
        numeric(i,9)=0;
    elseif clinical_dataset.audition(i)== "Hears moderately"
        numeric(i,9)=1;
    elseif clinical_dataset.audition(i)=="Hears well"
        numeric(i,9)=2;
    else
        numeric(i,9)=NaN;
    end

% weight loss 
    if clinical_dataset.weight_loss(i)== "No"
        numeric(i,10)=0;
    elseif clinical_dataset.weight_loss(i)== "Yes"
        numeric(i,10)=1;
    else
        numeric(i,10)=NaN;
    end

% Balance_single
    if clinical_dataset.balance_single(i)== "<5 sec"
        numeric(i,13)=1;
    elseif clinical_dataset.balance_single(i)== ">5 sec"
        numeric(i,13)=2;
    else
        numeric(i,13)=NaN;
    end

% Gait_optional_binary
    if clinical_dataset.gait_optional_binary(i)== "FALSE"
        numeric(i,16)=0;
    elseif clinical_dataset.gait_optional_binary(i)== "TRUE"
        numeric(i,16)=1;
    else
        numeric(i,16)=NaN;
    end

% Gait_speed_slower
    if clinical_dataset.gait_speed_slower(i)== "No"
        numeric(i,17)=0;
    elseif clinical_dataset.gait_speed_slower(i)== "Yes"
        numeric(i,17)=1;
    else
        numeric(i,17)=NaN;
    end

% Grip_strength_abnormal
    if clinical_dataset.grip_strength_abnormal(i)== "No"
        numeric(i,18)=0;
    elseif clinical_dataset.grip_strength_abnormal(i)== "Yes"
        numeric(i,18)=1;
    else
        numeric(i,18)=NaN;
    end

% Low_physical_activity
    if clinical_dataset.low_physical_activity(i)== "No"
        numeric(i,19)=0;
    elseif clinical_dataset.low_physical_activity(i)== "Yes"
        numeric(i,19)=1;
    else
        numeric(i,19)=NaN;
    end

% Memory_complain
    if clinical_dataset.memory_complain(i)== "No"
        numeric(i,28)=0;
    elseif clinical_dataset.memory_complain(i)== "Yes"
        numeric(i,28)=1;
    else
        numeric(i,28)=NaN;
    end

% Sleep
    if clinical_dataset.sleep(i)== "No sleep problem"
        numeric(i,29)=0;
    elseif clinical_dataset.sleep(i)== "Occasional sleep problem"
        numeric(i,29)=1;
    elseif clinical_dataset.sleep(i)=="Permanent sleep problem"
        numeric(i,29)=2;
    else
        numeric(i,29)=NaN;
    end

% Living_alone
    if clinical_dataset.living_alone(i)== "No"
        numeric(i,33)=0;
    elseif clinical_dataset.living_alone(i)== "Yes"
        numeric(i,33)=1;
    else
        numeric(i,33)=NaN;
    end

% Leisure_club
    if clinical_dataset.leisure_club(i)== "No"
        numeric(i,35)=0;
    elseif clinical_dataset.leisure_club(i)== "Yes"
        numeric(i,35)=1;
    else
        numeric(i,35)=NaN;
    end

% House_suitable_participant
    if clinical_dataset.house_suitable_participant(i)== "No"
        numeric(i,41)=0;
    elseif clinical_dataset.house_suitable_participant(i)== "Yes"
        numeric(i,41)=1;
    else
        numeric(i,41)=NaN;
    end

% House_suitable_professional
    if clinical_dataset.house_suitable_professional(i)== "No"
        numeric(i,42)=0;
    elseif clinical_dataset.house_suitable_professional(i)== "Yes"
        numeric(i,42)=1;
    else
        numeric(i,42)=NaN;
    end

% Health_rate
    if clinical_dataset.health_rate(i)== "5 - Excellent"
        numeric(i,45)=5;
    elseif clinical_dataset.health_rate(i)== "4 - Good"
        numeric(i,45)=4;
    elseif clinical_dataset.health_rate(i)=="3 - Medium"
        numeric(i,45)=3;
    elseif clinical_dataset.health_rate(i)== "2 - Bad"
        numeric(i,45)=2;
    elseif clinical_dataset.health_rate(i)=="1 - Very bad"
        numeric(i,45)=1;
    else
        numeric(i,45)=NaN;
    end

% Health_rate_comparison
    if clinical_dataset.health_rate_comparison(i)== "5 - A lot better"
        numeric(i,46)=5;
    elseif clinical_dataset.health_rate_comparison(i)== "4 - A little better"
        numeric(i,46)=4;
    elseif clinical_dataset.health_rate_comparison(i)=="3 - About the same"
        numeric(i,46)=3;
    elseif clinical_dataset.health_rate_comparison(i)== "2 - A little worse"
        numeric(i,46)=2;
    elseif clinical_dataset.health_rate_comparison(i)=="1 - A lot worse"
        numeric(i,46)=1;
    else
        numeric(i,46)=NaN;
    end

% Activity_regular
    if clinical_dataset.activity_regular(i)== "No"
        numeric(i,48)=0;
    elseif clinical_dataset.activity_regular(i)== "< 2 h per week"
        numeric(i,48)=1;
    elseif clinical_dataset.activity_regular(i)=="> 2 h and < 5 h per week"
        numeric(i,48)=2;
    elseif clinical_dataset.activity_regular(i)== "> 5 h per week"
        numeric(i,48)=3;
    else
        numeric(i,48)=NaN;
    end

% Smoking
    if clinical_dataset.smoking(i)== "Never smoked"
        numeric(i,49)=0;
    elseif clinical_dataset.smoking(i)== "Past smoker (stopped at least 6 months)"
        numeric(i,49)=1;
    elseif clinical_dataset.smoking(i)=="Current smoker"
        numeric(i,49)=2;
    else
        numeric(i,49)=NaN;
    end
end 

%% Removing erroneous values

% here we delete all the values equal to 999 and we implement zscore which 
% measures the distance between a data point and the mean using standard 
% deviations in order to erase all other wrong values

for i=Numerical
    [S,M]=std(numeric(:,i),"omitnan");
    for j=1:height(numeric)
           z_score=(numeric(j,i)-M)/S;        
           if z_score>10 || z_score<-10 || numeric(j,i)==999 
            numeric(j,i)=NaN; % each value that does not fit with our 
           end                % ristrictions is set to be NaN
    end
end

% array and originally numerical variables that will be created after 
% deleting variables and patients
new=numeric;
new_num=Numerical;

%number of rows and cols, that will be decreased when one is erased, used to
%adjust the index for the following code that deletes wrong values
rows=540;
cols=55;
cols_del=[];

% we delete the features that have more than 1/5 of the values empty and
% do not take them under consideration for the classification
for i=1:55
    if sum(isnan(numeric(:,i)))>=540/5
        del_name=convertCharsToStrings(clinical_dataset.Properties.VariableNames{i});
        cols_del = [cols_del; del_name];
        output=sprintf('variable deleted: %s', cols_del(end));
        disp(output)                    
        new(:,i-55+cols)=[];           
        new_num(new_num==i-55+cols)=[];        
        cols=cols-1;         
    end
end

% we delete the patients that have more than 1/5 of the values empty and
% do not take them under consideration for the classification
for i=1:540
    if sum(isnan(numeric(i,:)))>=10    
        row_id = clinical_dataset.part_id(i);
        output=sprintf('patient deleted: %d', row_id);
        disp(output)                         
        new(i-540+rows,:)=[];         
        rows=rows-1;                   
    end
end


%% Handling missing values
% calculate 3 average values for each variable(column) accordind to fried 
% if the variable is categorical round them to nearest integer(category)
% depending on fried value of each patiend 
% use the corresponding average to fill the array
for j=1:cols
    sum0=0;
    sum1=0;
    sum2=0;
    for i=1:rows
        if ~isnan(new(i,j))
            if new(i,2)==0
                sum0=new(i,j)+sum0;
            elseif new(i,2)==1
                sum1=new(i,j)+sum1;
            else  
                sum2=new(i,j)+sum2;
        
            end
        end
    end
    m0=sum0/sum(new(:,2)==0,"omitnan");
    m1=sum1/sum(new(:,2)==1,"omitnan");
    m2=sum2/sum(new(:,2)==2,"omitnan");
    if ~ismember(j,new_num)
          m0=round(m0);
          m1=round(m1);
          m2=round(m2);
    end
    for i=1:rows
        if isnan(new(i,j))
            if new(i,2)==0
                new(i,j)=m0;
            elseif new(i,2)==1
                new(i,j)=m1;
            else  
                new(i,j)=m2;
            end
        end
    end
end

% Create final table after changes and set variable names excluding deleted
final_data=array2table(new);
names = clinical_dataset.Properties.VariableNames;
%remove names that are deleted from the table
for i = 55:-1:1
    if ismember(names(i),cols_del)
        names(i)=[];
    end
end
final_data.Properties.VariableNames=names;

save('final_data.mat','final_data');
