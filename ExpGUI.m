classdef ExpGUI < handle
    properties
        m_GUI               %����������� ���������
        m_InputData         %������ �� �������� ������
        m_StatExperiment    %������ �� ������ �����������
    end
    
    methods
        function obj = ExpGUI(m_InputData_arg,m_StatExperiment_arg)
            obj.m_InputData = m_InputData_arg;
            obj.m_StatExperiment = m_StatExperiment_arg;
            obj.m_GUI = kursgui(obj);
        end        
    end
end
