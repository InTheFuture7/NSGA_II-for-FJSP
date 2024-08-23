%{ 
���룺
    p_chromosome,m_chromosome Ϊ����patro�⼯�ź������Ⱥ���򡢻�������
    pool_size�����������ĳ��Σ�tour_size ÿ���������Ĳ���ѡ�ָ���
�㷨��
    ��Ϊ�趨 pop_f=100������ʼ��Ⱥ��Ϊ 200�����Խ���100�ֱ�����ÿ�������Ƚϡ�
    ÿ�����ѡ���������壬����ѡ������ȼ��ߵĸ��塣
    �������ȼ�һ��������ѡ��ӵ���ȴ�ĸ��壬���ӵ������ͬ��ѡ���С����һ��
    
    ������ע�⣺���������ѡ���������壬���ܻᱻ�ظ�ѡ��
�����
    p_parent_chromosome��m_parent_chromosome ��¼��ʤ�߸��壬���ݸ�����p_chromosome��m_chromosome
%} 
function [p_parent_chromosome,m_parent_chromosome] = tournament_selection(p_chromosome,m_chromosome ,pool_size, tour_size)
    [pop, variables] = size(p_chromosome);  % �����Ⱥ�ĸ��������;��߱������� pop��Ⱥ���� 
    rank = variables - 1;  % ��������������ֵ����λ��
    distance = variables;  % ����������ӵ��������λ��
    for i = 1 : pool_size
        for j = 1 : tour_size
            candidate(j) = round(pop*rand(1));  % ���ѡ��������壬��candidate�洢
            if candidate(j) == 0  % ����round()ѡ����0
                candidate(j) = 1;
            end
            if j > 1
                while ~isempty(find(candidate(1 : j - 1) == candidate(j)))  % ��ֹ��������������ͬһ��
                    % ��������������Ϊͬһ������ִ�����´��롣����ѭ����ֱ���������岻ͬ
                    candidate(j) = round(pop*rand(1));  % ����ѡ���������
                    if candidate(j) == 0  % ����round()ѡ����0
                        candidate(j) = 1;
                    end
                end
            end
        end

        for j = 1 : tour_size  % ��¼ÿ�������ߵ�����ȼ���ӵ����
            c_obj_rank(j) = p_chromosome(candidate(j), rank);
            c_obj_distance(j) = p_chromosome(candidate(j),distance);
        end
        % ѡ������ȼ���С�Ĳ����ߣ������ظò������ڲ����߼����е�������
        min_candidate = find(c_obj_rank == min(c_obj_rank));
        if length(min_candidate) ~= 1  % ������������ߵ�����ȼ���ȣ�������ѡ��ӵ���ȴ�ĸ���
            % ѡ��ӵ������ϴ�Ĳ����ߣ������ظò������ڲ����߼����е�������
            max_candidate = find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
            if length(max_candidate) ~= 1  % �������ӵ������Ҳ��ȣ���ôѡ���±�С��
                max_candidate = max_candidate(1);
            end
            p_parent_chromosome(i,:) = p_chromosome(candidate(min_candidate(max_candidate)),:);
            m_parent_chromosome(i,:) = m_chromosome(candidate(min_candidate(max_candidate)),:);   
        else  % ������������ߵ�����ȼ�����ȣ���ѡ��ȼ���ǰ��
            p_parent_chromosome(i,:) = p_chromosome(candidate(min_candidate(1)),:);
            m_parent_chromosome(i,:) = m_chromosome(candidate(min_candidate(1)),:);
        end
end