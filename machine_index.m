% ����P,M,����N
% MΪ���ȷ����Ļ��ڻ��������Ⱦɫ��  NΪ��ѡ�豸�ڶ�Ӧ��ѡ�豸���е����к�
% ˼·�����ݹ��򡢻�����������к��������ϵĹ����ԣ���ȷ������i�Ĺ�������λ��pi_index��
%       Ȼ�󣬸���M�еĻ�����ţ��õ���ѡ�豸���е����кţ����ֵ��N
function N = machine_index(J,P,M)
    N=zeros(1,size(P,2));
    for i=1:size(J,2)
        pi_index=find(P==i);  % ����i�����й����ڱ���P�е�����λ��
        for j=1:size(pi_index,2)  % ��i�������� size(pi_index,2) ������
             var=find(J(i).m{j}==M(pi_index(j)));  % find �����ҳ��� J(i).m{j} ��� cell �����е��� M(pi_index(j)) ��Ԫ�ص�������
             N(pi_index(j))=var;
        end
    end
end