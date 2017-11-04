%% initial condition
% ���ո�� (�C�ե]�tvariable_number, minterm, dont_care)

% variable_number = 4;
% minterm = [0, 2, 4, 5, 6, 9, 10];
% dont_care = [7, 11, 12, 13, 14, 15];
% minterm = [0, 1, 5, 8, 10 ,13, 15];
% dont_care = [];
% minterm = [4, 8, 10, 11, 12, 15];
% dont_care = [9, 14];
% minterm = [4, 6, 9, 10, 11, 13];
% dont_care = [2, 12, 15];
% minterm = [1, 3, 5, 8, 9, 11, 15];
% dont_care = [2, 13];

% variable_number = 5;
% minterm = [ 4, 6, 9 ,10, 11, 13, 18, 20, 22];
% dont_care = [ 2, 12, 15, 21];
% minterm = [0, 1, 2, 4, 5, 6, 10, 13, 14, 18, 21, 22, 24, 26, 29, 30, 31];
% dont_care = [];
% minterm = [ 1, 5, 7, 13, 14, 15, 17, 18, 21, 22, 25, 29 ];
% dont_care = [ 6, 9, 19, 23, 30 ];

variable_number = 6;
% minterm = [ 4, 6, 7, 8,13, 15, 20, 21, 22, 23, 29, 30, 33, 37, 38, 39, 40, 49, 53, 55];
% dont_care = [ 5, 10, 18, 26, 31, 36, 42, 52, 54, 60, 61];
minterm = [ 2, 8, 10,18, 24, 26, 34, 37, 42, 45, 50, 53, 58, 61 ];
dont_care = [];

%% �B�J�@: �Nmd�̷�1���ƥؤ�����n+1��group�A 
md = sort([minterm, dont_care]); % ��minterm�Mdon't care�X�b�@�_�Ƨǫإߦ�md 
group = cell(variable_number+1); % row�Ogroup�ơAcolumn�O�n������`�B��
group_binary = cell(variable_number+1); % ����group������G�i��(�r��)
group_PI_flag = cell(variable_number+1); % ����group���U�P�_�O�_��PI
PI = {}; %����PI

for i = 1:length(md)
    binary_value = dec2bin(md(i), variable_number);% ���omd���G�i��(�r��)
    temp1 = []; % �Ȯ��x�smd���G�i��
    temp2 = linspace(0, 0, variable_number); % 0���G�i��(�}�C)
    for j = 1:variable_number % �Nmd���G�i��q�r���ন�}�C
        temp1 = [temp1, str2num(binary_value(j))];
    end
    which_group = pdist([temp1;temp2],'hamming') * variable_number + 1; % �u�����}�C�A�p��P0��hamming distance = n (ie.��n��1)
    group{which_group,1} = [group{which_group,1}; md(i)]; % �N��md�[�J��n+1��group
    group_binary{which_group,1} = [group_binary{which_group,1}; binary_value]; % ������md���G�i��
end

%% �B�J�G:����۾F��group�A�Yhamming distance�u�t1�h�X��

% �`�@������B�ƬOvariable_number��
for i = 1:variable_number 
    final_group_number = variable_number+1-i; % �������ѤU��group��    
    % ���]�wPI_flag�A�Y�P�Ҧ�j+1��group��element������S�o�{hamming distance = 1�A�h�P�w��PI
    for j = 1:final_group_number+1
        [row_j, col_j] = size(group{j,i});
        for k = 1:row_j            
            group_PI_flag{j,i}(k,1) = 1;
        end
    end    
    % �b��i�B�A�`�@��variable_number+1-i��group�n�i����
    for j = 1:final_group_number
        % �b��i�B�A��j��group�`�@����group���׭Ӥ����n�P�U��group�i����
        [row_j, col_j] = size(group{j,i});
        for k = 1:row_j
            % �b��i�B�A��j��group����k��element���G�i��
            temp1 = [];
            for b = 1:variable_number % �N��k��element���G�i��q�r���ন�}�C
                temp1 = [temp1, str2num(group_binary{j,i}(k,b))];
            end
            % �b��i�B�A��j��group����k��element�n�Pj+1��group����m��element�i����
            [row_k, col_k] = size(group{j+1,i});
            for m = 1:row_k
                temp2 = [];
                for b = 1:variable_number % �N��m��element���G�i��q�r���ন�}�C
                    temp2 = [temp2, str2num(group_binary{j+1,i}(m,b))];
                end
                % �Y�g�����T�{hamming distance = 1
                if (pdist([temp1;temp2],'hamming') * variable_number == 1)
                    group_PI_flag{j,i}(k,1) = 0; % �]�w��j��group����k��element�ëDPI
                    group_PI_flag{j+1,i}(m,1) = 0; % �]�w��j+1��group����m��element�ëDPI
                    % �X�ֲ�j��group����k��element�Mj+1��group����m��element�ñƧ�
                    next_step_element = sort([group{j,i}(k,:), group{j+1,i}(m,:)]);
                    next_step_binary = '';
                    % �N���ƪ��G�i��אּ'9'(�ҥ���'-')
                    for n = 1:variable_number
                        if temp1(n) ~= temp2(n)
                            next_step_binary(n) = '9';
                        else
                            next_step_binary(n) = num2str(temp1(n));
                        end
                    end
                    % �ˬd�O�_�w�g����(ie. hamming distance = 0)�A���h�˱�A�Y�L�h��J��i+1�B����j��group
                    quit = 0;
                    [row_m, col_m] = size(group{j,i+1});
                    for n = 1:row_m
                        if (pdist([next_step_element;group{j,i+1}(n,:)],'hamming') == 0)
                            quit = 1;
                        end
                    end
                    if (quit==0)
                        group{j,i+1} = [group{j,i+1}; next_step_element];
                        group_binary{j,i+1} = [group_binary{j,i+1}; next_step_binary];
                    end
                end
            end
        end
    end
    % �b��i�B�A�N��j��group����k��element������L��element��iPI
    for j = 1:final_group_number+1
        [row_j, col_j] = size(group{j,i});
        for k = 1:row_j
            if(group_PI_flag{j,i}(k,1) == 1)
                [row_p, col_p] = size(PI);
                PI{row_p+1,1} = group{j,i}(k,:);
                PI{row_p+1,2} = group_binary{j,i}(k,:);
            end
        end
    end
end

%% �B�J�T:�إ�PI chart
[row_p, col_p] = size(PI);
PI_chart = zeros([row_p, length(minterm)]);
% ���C�@��PI
for i = 1:row_p
    % �̭���element
    for j = 1:length(PI{i,1})
        % �p�G�ŦXminterm����
        for k = 1:length(minterm)
            if (PI{i,1}(1,j) == minterm(k))
                % �]��1
                PI_chart(i,k) = 1;
            end
        end
    end
end
essential_PI = {};
row_epi_record = []; % �קK���Ƨ��P�@��essential_PI
% �x�sessential PI
for i = 1:length(minterm)
    [row_e, col_e] = find(PI_chart(:,i));
    if (length(row_e) == 1)
        [row_pass, col_pass] = find(row_epi_record,row_e);
        if (isempty(row_pass))
            row_epi_record = [row_epi_record; row_e];
            [row_ep, col_ep] = size(essential_PI);
            essential_PI{row_ep+1,1} = PI{row_e,1};
            essential_PI{row_ep+1,2} = PI{row_e,2};
        end
    end
end
% ��essential PI����element����C�]��0
[row_ep, col_ep] = size(essential_PI);
for i = 1:row_ep
    for j = 1:length(essential_PI{i,1})
        delete = find(minterm==essential_PI{i,1}(1,j));
        if (length(delete)==1)
            PI_chart(:,delete) = 0;
        end
    end
end
% �P�_PI_chart �O�_���šA�_�h�~���Messential_PI
[row_pi, col_pi] = find(PI_chart);
while (~isempty(row_pi))
    % �M�w�Qdominant��PI
    [row_pid, col_pid] = size(PI);
    PI_be_dominant = linspace(0,0,row_pid);
    for i = 1:length(unique(row_pi))
        for j = 1:length(unique(row_pi))
            if (i~=j)
                row_pi_sort = unique(row_pi);
                be_dominant = find((PI_chart(row_pi_sort(i),:) > PI_chart(row_pi_sort(j),:)) == (PI_chart(row_pi_sort(i),:) ~= PI_chart(row_pi_sort(j),:)));
                if (length(be_dominant)==length(minterm))
                    PI_be_dominant(row_pi_sort(j)) = 1;
                end
            end
        end
    end
    % ��Qdominant��PI����
    if (~isempty(find(PI_be_dominant,1)))
        temp = find(PI_be_dominant,1);
        for i = 1:length(temp)
            PI_chart(temp(i),:) = 0;
        end
    end
    row_epi_record = []; % �קK���Ƨ��P�@��essential_PI
    % �x�sessential PI
    for i = 1:length(minterm)
        [row_e, col_e] = find(PI_chart(:,i));
        if (length(row_e) == 1)
            [row_pass, col_pass] = find(row_epi_record,row_e);
            if (isempty(row_pass))
                row_epi_record = [row_epi_record; row_e];
                [row_ep, col_ep] = size(essential_PI);
                essential_PI{row_ep+1,1} = PI{row_e,1};
                essential_PI{row_ep+1,2} = PI{row_e,2};
            end
        end
    end
    % ��essential PI����element����C�]��0
    [row_ep, col_ep] = size(essential_PI);
    for i = 1:row_ep
        for j = 1:length(essential_PI{i,1})
            delete = find(minterm==essential_PI{i,1}(1,j));
            if (length(delete)==1)
                PI_chart(:,delete) = 0;
            end
        end
    end
    % ��essential PI����element����C�]��0
    [row_ep, col_ep] = size(essential_PI);
    for i = 1:row_ep
        for j = 1:length(essential_PI{i,1})
            delete = find(minterm==essential_PI{i,1}(1,j));
            if (length(delete)==1)
                PI_chart(:,delete) = 0;
            end
        end
    end
    % ���s�P�_PI_chart �O�_����
    [row_pi, col_pi] = find(PI_chart);
end

%% �B�J�|:�L�X���G
english_alphabet = 'abcdefghijklmnopqrstuvwxyz';
fprintf('f(');
for i = 1:variable_number
    fprintf(english_alphabet(i));
    if (i~=variable_number)
        fprintf(', ');
    end
end
fprintf(') = ');
[row_epi, col_epi] = size(essential_PI);
for i = 1:row_epi
    for j = 1:variable_number
        if (essential_PI{i,2}(j) == '1')
            fprintf(english_alphabet(j));
        elseif (essential_PI{i,2}(j) == '0')
            fprintf(english_alphabet(j));
            fprintf('*');
        end
    end
    if (i~=row_epi)
        fprintf(' + ');
    else
        fprintf('\n');
    end
end