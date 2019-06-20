w_length = 100;%滑窗大小
interval = 90;%滑窗间隔
alpha = 0.1;%阈值更新权重系数
false_positive_interval = 4;%至少间隔多少个滑窗在进行报警
threshold_multiple =  3;%阈值倍数

sequence = first_pca;
sequence = medfilt1(sequence,40);%中值滤波
threshold = var(sequence(1:w_length));%方差阈值

plot(sequence)
hold on;

window = zeros(w_length);
var_array_length = fix((length(sequence)-w_length) / interval)+1;
var_array = zeros(var_array_length,1);
threshold_array = zeros(var_array_length,1);
is_abnormal_array = zeros(var_array_length,1);
ismember_result = 0;

%开始进行遍历检测
iterations_num = 1;
for i=1:interval:length(sequence)-w_length
    window = sequence(i : i + w_length - 1);
    var_array(iterations_num) = var(window);
    
    %更新阈值
    threshold = (1-alpha) * threshold + alpha * var(window);
    threshold_array(iterations_num) = threshold;
    
    %判断是否是异常点
    if( var(window) > threshold_multiple * threshold )
        ismember_result = ismember(1,is_abnormal_array(iterations_num - false_positive_interval:iterations_num));
        
        if (ismember_result)
            continue;
        end
        is_abnormal_array(iterations_num) = 1;
        plot([i,i],[-40,40],'r')
    end
     
    %更新迭代次数
    iterations_num = iterations_num+1;
end

hold off;