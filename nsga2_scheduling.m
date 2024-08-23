%������
function nsga2_scheduling
    clear all;
    clc;
    pop = 200;  % ��Ⱥ����
    gen = 30;  % ��������
    pop_f=150;  % ������Ⱥ����
    data_mac;  % ���복���豸��Ϣ
    data_pro;  % ������ӹ�������Ϣ
    pro_matrix=[];  % ��������Ŀ�꺯��ֵ�þ��߾���
    mac_matrix=[];  % �����豸Ⱦɫ����Ϣ�ľ��߾���

    for i=1:pop_f  %���ɳ�ʼ��Ⱥ
        [P,M,N]=initPop(J);
        [part_t, mac_t, ~]=decode(J,P,M,N);  % part_tΪ��Ӧ����������ӹ�ʱ����Ϣ  mac_tΪ��Ӧ�豸������ӹ�ʱ����Ϣ
        
        % 2��Ŀ�꺯������ԽСԽ��
        c_time=cal_comp_time(part_t);  % ��������깤ʱ�� part_t Ϊ���ȷ�������Ӧ�ļӹ�ʱ����Ϣ
        % d_time=cal_def_time(J,part_t);  % ����������ʱ����ɾ��
        t_load=cal_equ_load(part_t);  % �����豸�ܸ���
        % t_cons=cal_ene_consu(Mac,mac_t,P,M,c_time);  % ������ȷ��������ܺ� TimeΪ����깤ʱ�䣬ɾ��

        pro_matrix(i,:)=[P, c_time, t_load];
        mac_matrix(i,:)=M;
    end
    
    for i = 1 : gen  % gen ��������
        pool = round(pop/2);  % round() ��������ȡ�� ����ش�С
        tour = 2;  % ������  ����ѡ�ָ���
        % ����ÿ�������Ӧ������ֵ��ӵ�����룬��һ�����еľ���
        [p_matrix, m_matrix]= non_domination_sort_mod(pro_matrix, mac_matrix);  % ��Ⱥ���з�֧����������ӵ���ȼ���
        clear pro_matrix;
        clear mac_matrix;
        [p_parent_chromosome, m_parent_chromosome] = tournament_selection(p_matrix, m_matrix, pool, tour);  % ������ѡ���ʺϷ�ֳ�ĸ���

        % ������������Ӵ���Ⱥ
        [p_child_matrix, m_child_matrix]=genetic_operator(J, p_parent_chromosome, m_parent_chromosome);

        % ���ݸ������������Ⱥ�����з�֧���������ѡȡ����һ���ĸ�����Ⱥ
        for j=1:size(p_child_matrix,1)
            P=p_child_matrix(j,:);
            M=m_child_matrix(j,:);
            N=machine_index(J,P,M);
            [part_t,mac_t, ~]=decode(J,P,M,N);

            c_time=cal_comp_time(part_t);
            % d_time=cal_def_time(J,part_t);
            t_load=cal_equ_load(part_t);
            % t_cons=cal_ene_consu(Mac,mac_t,P,M,c_time);
        
            pro_matrix(j,:)=[P, c_time, t_load];
            mac_matrix(j,:)=M;
        end
        n_p_m=size(pro_matrix,1);
        pro_matrix(n_p_m+1:n_p_m+10, :)=p_matrix(1:10, 1:size(pro_matrix,2));  % ����10����ӢȾɫ�嵽�Ӵ���Ⱥ��
        mac_matrix(n_p_m+1:n_p_m+10, :)=m_matrix(1:10, :);
    end

    [p_matrix,m_matrix]= non_domination_sort_mod(pro_matrix,mac_matrix);
    num_of_level_1=length(find(p_matrix(:, size(p_matrix,2)-1)==1));  % �ҳ�֧��ȵȼ�Ϊ1���и���
    target_p_matrix = p_matrix(1:num_of_level_1,:);  % ȡ��֧��ȵȼ�Ϊ 1 ���У��������
    target_m_matrix = m_matrix(1:num_of_level_1,:);
    % best_p = target_p_matrix(1,:);  % ѡȡ��һ����Ϊ���Ž⣬�ɸ�������ѡ��AHP����Ȩ����ģ�����߷���ѡ�����Ž�
    % best_m = target_m_matrix(1,:);

    % ʹ�� ��Ȩ��������ʱ��ά�ȵģ� ѡ�����Ž�
    %disp(target_p_matrix)  % ѡȡ�� 51��52
    optimal_index = entropy_weight_method(target_p_matrix(:, [51, 52]));
    save target_p_matrix target_p_matrix;

    best_p = target_p_matrix(optimal_index,:);
    best_m = target_m_matrix(optimal_index,:);

    P = best_p(1:length(best_p)-4);  % ȡ�����Ž��28��������룬ע�⣬����޸�Ŀ�꺯���������޸������4
    M = best_m;
    N = machine_index(J,P,M);
    [part_t, mac_t, t_span]=decode(J,P,M,N);
    % save P P;
    save M M;
    % save N N;
    % save mac_t mac_t;
    % save part_t part_t;
    save best_p;
    ganttChart1(J, best_p, M, mac_t);
    % disp(best_p)
end

