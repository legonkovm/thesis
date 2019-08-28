classdef InputData < handle
    properties
        Pfa %�������� ����������� ������ ������
        algName %��� ���������
        algNumber %����� ���������
        NumRot
        MedOn
        NumRLS
        Distance
        Azimut
        DistPd
        
        %��������� ��������� ����������
        %ca-cfar
        ca_grd
        ca_wnd
        
        %lo-�far
        lo_grd
        lo_wnd
        
        %go-cfar
        go_grd
        go_wnd
        
        %os-cfar
        k
        os_wnd
    end
    
    methods
        function obj = InputData
            if ~exist('inputData.mat','file')
                %�� ���������
                obj.Pfa = 1e-6; %�������� ����������� ������ ������

                
                obj.algNumber = 1;
                obj.algName = '������������ (�����������)';
                obj.Distance = 3000;
                obj.Azimut = 0;
                obj.DistPd = 1000;
                obj.NumRLS = 1;
                obj.NumRot = 1;
                obj.MedOn = 0;
                
                %ca-cfar
                obj.ca_grd = 2; %�������� ��������
                obj.ca_wnd = 8; %������ ��������
                
                %lo-�far
                obj.lo_grd = 2;
                obj.lo_wnd = 8;
                
                %go-cfar
                obj.go_grd = 2;
                obj.go_wnd = 8;
                
                %os-cfar
                obj.k = 27; %����� ������� � ������������ ����
                obj.os_wnd = 16;%����� ������������� ����
            else
                load inputData.mat obj;
                %todo �������� �� ���������� �������� ������
            end
            
        end
        function update(obj)
            save inputData obj;
        end
    end
end

