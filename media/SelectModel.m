%/////////////////////////////////////////////////////////////////////////////          this function handles changing model and does:       ////////////////////////////////
%1. halts the current model
%2. loads the current model
%inputs:
%m - 3 levels flag that tells which model to load.
%CCS_Obj - the target object
function SelectModel(m,CCS_Obj)
CCS_Obj.halt;
switch m
    case 1
    model='Periodogram';
    case 2
        model='Burg';
    case 3
        model= 'MCov_AR';
end         
CodegenDir = fullfile(pwd, [model '_c6000_rtw']);
OutFile = fullfile(CodegenDir, [model '.out']);
CCS_Obj.load(OutFile,20);
CCS_Obj.run;         
