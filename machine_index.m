% 基于P,M,生成N
% M为调度方案的基于机器编码的染色体  N为所选设备在对应可选设备集中的序列号
% 思路：根据工序、机器编码和序列号在索引上的关联性，先确定工件i的工序索引位置pi_index；
%       然后，根据M中的机器编号，得到可选设备集中的序列号，最后赋值给N
function N = machine_index(J,P,M)
    N=zeros(1,size(P,2));
    for i=1:size(J,2)
        pi_index=find(P==i);  % 工件i的所有工序，在编码P中的索引位置
        for j=1:size(pi_index,2)  % 第i个工件有 size(pi_index,2) 个工序
             var=find(J(i).m{j}==M(pi_index(j)));  % find 用来找出在 J(i).m{j} 这个 cell 数组中等于 M(pi_index(j)) 的元素的索引。
             N(pi_index(j))=var;
        end
    end
end