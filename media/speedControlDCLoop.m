function speedControlDCLoop(CCS_Obj,handles)
%speedControlDCLoop controls host-side RTDX processing for
%  speed control DC motor demo:
% The loop receives messages from RTDX and updates graphs with fresh data

% $Revision: 1.1.6.1 $ $Date: 2006/05/31 02:57:50 $
% Copyright 2006 The MathWorks, Inc.


guidata(handles.output, handles);
x_axis = 0:0.1:4.9;
r = CCS_Obj.rtdx;
try
    while (isrunning(CCS_Obj))
        if (get(handles.pushbutton6,'UserData'))
            new_speed = get(handles.slider1, 'Value');
            r.writemsg('ichan1',int32(new_speed));
            set(handles.pushbutton6,'UserData',0);
        end

        numMsgsOchan1 = r.msgcount('ochan1');
        if (numMsgsOchan1 > 1),
            % flush frames as necessary to maintain real-time display
            r.flush('ochan1', numMsgsOchan1-1);
        end
        if (numMsgsOchan1)
            speed = r.readmsg('ochan1', 'int32');
        end

        numMsgsOchan2 = r.msgcount('ochan2');
        if (numMsgsOchan2 > 1),
            % flush frames as necessary to maintain real-time display
            r.flush('ochan2', numMsgsOchan2-1);
        end
        if (numMsgsOchan2)
            pid = r.readmsg('ochan2', 'int32');
        end
        if ((numMsgsOchan1 ~=0) && (numMsgsOchan2 ~= 0))
            axes(handles.axes3);
            plot(handles.axes3,x_axis, speed);
            title(handles.axes3,'Measured speed of the DC motor');
            xlabel(handles.axes3,'t (s)');
            ylabel(handles.axes3,'Speed (RPM)');
            grid(handles.axes3,'on');
            axis(handles.axes3,[0 5 1 5000]);

            axes(handles.axes4);
            cycle = (double(pid).*100./4000);
            plot(handles.axes4,x_axis, cycle);
            title(handles.axes4,'Duty cycle of the PWM waveform');
            xlabel(handles.axes4,'t (s)');
            ylabel(handles.axes4,'Duty Cycle (%) ');
            grid(handles.axes4,'on');
            axis(handles.axes4,[0 5 1 100]);
        end
        if (get(handles.pushbutton7,'UserData'))
            break
        end
        pause (0.2);
    end
catch
    errordlg(lasterr);
end

