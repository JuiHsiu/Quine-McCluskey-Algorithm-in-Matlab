%% initial condition
% 測試資料 (每組包含variable_number, minterm, dont_care)

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

%% 步驟一: 將md依照1的數目分類成n+1個group， 
md = sort([minterm, dont_care]); % 把minterm和don't care合在一起排序建立成md 
group = cell(variable_number+1); % row是group數，column是要比較的總步數
group_binary = cell(variable_number+1); % 對應group紀錄其二進位(字串)
group_PI_flag = cell(variable_number+1); % 對應group輔助判斷是否為PI
PI = {}; %紀錄PI

for i = 1:length(md)
    binary_value = dec2bin(md(i), variable_number);% 取得md的二進位(字串)
    temp1 = []; % 暫時儲存md的二進位
    temp2 = linspace(0, 0, variable_number); % 0的二進位(陣列)
    for j = 1:variable_number % 將md的二進位從字串轉成陣列
        temp1 = [temp1, str2num(binary_value(j))];
    end
    which_group = pdist([temp1;temp2],'hamming') * variable_number + 1; % 只能比較陣列，計算與0的hamming distance = n (ie.有n個1)
    group{which_group,1} = [group{which_group,1}; md(i)]; % 將該md加入第n+1個group
    group_binary{which_group,1} = [group_binary{which_group,1}; binary_value]; % 紀錄該md的二進位
end

%% 步驟二:比較相鄰的group，若hamming distance只差1則合併

% 總共比較的步數是variable_number次
for i = 1:variable_number 
    final_group_number = variable_number+1-i; % 比較完後剩下的group數    
    % 先設定PI_flag，若與所有j+1個group的element比較都沒發現hamming distance = 1，則判定為PI
    for j = 1:final_group_number+1
        [row_j, col_j] = size(group{j,i});
        for k = 1:row_j            
            group_PI_flag{j,i}(k,1) = 1;
        end
    end    
    % 在第i步，總共有variable_number+1-i個group要進行比較
    for j = 1:final_group_number
        % 在第i步，第j個group總共有該group長度個元素要與下個group進行比較
        [row_j, col_j] = size(group{j,i});
        for k = 1:row_j
            % 在第i步，第j個group的第k個element的二進位
            temp1 = [];
            for b = 1:variable_number % 將第k個element的二進位從字串轉成陣列
                temp1 = [temp1, str2num(group_binary{j,i}(k,b))];
            end
            % 在第i步，第j個group的第k個element要與j+1個group的第m個element進行比較
            [row_k, col_k] = size(group{j+1,i});
            for m = 1:row_k
                temp2 = [];
                for b = 1:variable_number % 將第m個element的二進位從字串轉成陣列
                    temp2 = [temp2, str2num(group_binary{j+1,i}(m,b))];
                end
                % 若經比較後確認hamming distance = 1
                if (pdist([temp1;temp2],'hamming') * variable_number == 1)
                    group_PI_flag{j,i}(k,1) = 0; % 設定第j個group的第k個element並非PI
                    group_PI_flag{j+1,i}(m,1) = 0; % 設定第j+1個group的第m個element並非PI
                    % 合併第j個group的第k個element和j+1個group的第m個element並排序
                    next_step_element = sort([group{j,i}(k,:), group{j+1,i}(m,:)]);
                    next_step_binary = '';
                    % 將重複的二進位改為'9'(課本為'-')
                    for n = 1:variable_number
                        if temp1(n) ~= temp2(n)
                            next_step_binary(n) = '9';
                        else
                            next_step_binary(n) = num2str(temp1(n));
                        end
                    end
                    % 檢查是否已經重複(ie. hamming distance = 0)，有則捨棄，若無則放入第i+1步的第j個group
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
    % 在第i步，將第j個group的第k個element未比較過的element放進PI
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

%% 步驟三:建立PI chart
[row_p, col_p] = size(PI);
PI_chart = zeros([row_p, length(minterm)]);
% 對於每一個PI
for i = 1:row_p
    % 裡面的element
    for j = 1:length(PI{i,1})
        % 如果符合minterm的值
        for k = 1:length(minterm)
            if (PI{i,1}(1,j) == minterm(k))
                % 設為1
                PI_chart(i,k) = 1;
            end
        end
    end
end
essential_PI = {};
row_epi_record = []; % 避免重複抓到同一個essential_PI
% 儲存essential PI
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
% 把essential PI有的element整行整列設為0
[row_ep, col_ep] = size(essential_PI);
for i = 1:row_ep
    for j = 1:length(essential_PI{i,1})
        delete = find(minterm==essential_PI{i,1}(1,j));
        if (length(delete)==1)
            PI_chart(:,delete) = 0;
        end
    end
end
% 判斷PI_chart 是否為空，否則繼續找尋essential_PI
[row_pi, col_pi] = find(PI_chart);
while (~isempty(row_pi))
    % 決定被dominant的PI
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
    % 把被dominant的PI消掉
    if (~isempty(find(PI_be_dominant,1)))
        temp = find(PI_be_dominant,1);
        for i = 1:length(temp)
            PI_chart(temp(i),:) = 0;
        end
    end
    row_epi_record = []; % 避免重複抓到同一個essential_PI
    % 儲存essential PI
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
    % 把essential PI有的element整行整列設為0
    [row_ep, col_ep] = size(essential_PI);
    for i = 1:row_ep
        for j = 1:length(essential_PI{i,1})
            delete = find(minterm==essential_PI{i,1}(1,j));
            if (length(delete)==1)
                PI_chart(:,delete) = 0;
            end
        end
    end
    % 把essential PI有的element整行整列設為0
    [row_ep, col_ep] = size(essential_PI);
    for i = 1:row_ep
        for j = 1:length(essential_PI{i,1})
            delete = find(minterm==essential_PI{i,1}(1,j));
            if (length(delete)==1)
                PI_chart(:,delete) = 0;
            end
        end
    end
    % 重新判斷PI_chart 是否為空
    [row_pi, col_pi] = find(PI_chart);
end

%% 步驟四:印出結果
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