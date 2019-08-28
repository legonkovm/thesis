function main
%главная функция программы
    m_InputData  = InputData;
    m_StatExperiment = StatExperiment(m_InputData);
    m_ExpGUI = ExpGUI(m_InputData,m_StatExperiment);
end