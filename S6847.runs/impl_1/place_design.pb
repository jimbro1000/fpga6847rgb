
?
Command: %s
53*	vivadotcl2
place_designZ4-113h px� 

@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
Implementation2	
xc7a15tZ17-347h px� 
o
0Got license for feature '%s' and/or device '%s'
310*common2
Implementation2	
xc7a15tZ17-349h px� 
H
Releasing license: %s
83*common2
ImplementationZ17-83h px� 
>
Running DRC with %s threads
24*drc2
2Z23-27h px� 
D
DRC finished with %s
79*	vivadotcl2

0 ErrorsZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
^
,Running DRC as a precondition to command %s
22*	vivadotcl2
place_designZ4-22h px� 
>
Running DRC with %s threads
24*drc2
2Z23-27h px� 
�
�Combinatorial Loop Alert: 1 LUT cells form a combinatorial loop. This can create a race condition. Timing analysis may not be accurate. The preferred resolution is to modify the design to remove combinatorial logic loops. If the loop is known and understood, this DRC can be bypassed by acknowledging the condition and setting the following XDC constraint on any one of the nets in the loop: 'set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets <myHier/myNet>]'. One net in the loop is %s. Please evaluate your design. The cells in the loop are: %s.%s*DRC2
 "

a0a02,
 "(
da0_OBUF_inst_i_7	da0_OBUF_inst_i_721
 +DRC|Netlist|Design Level|Combinatorial Loop8ZLUTLP-1h px� 
Y
DRC finished with %s
79*	vivadotcl2
0 Errors, 1 Critical WarningsZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
k
BMultithreading enabled for place_design using a maximum of %s CPUs12*	placeflow2
2Z30-611h px� 
C

Starting %s Task
103*constraints2
PlacerZ18-103h px� 
R

Phase %s%s
101*constraints2
1 2
Placer InitializationZ18-101h px� 
d

Phase %s%s
101*constraints2
1.1 2'
%Placer Initialization Netlist SortingZ18-101h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0012

1696.9412
0.000Z17-268h px� 
a
%s*common2H
FPhase 1.1 Placer Initialization Netlist Sorting | Checksum: 1098f612e
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.002 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002

00:00:002

1696.9412
0.000Z17-268h px� 
q

Phase %s%s
101*constraints2
1.2 24
2IO Placement/ Clock Placement/ Build Placer DeviceZ18-101h px� 
�
[Partially locked IO Bus is found. Following components of the IO Bus %s are not locked: %s
87*place2
data2G
0 '<MSGMETA::BEGIN::BLOCK>data[1]<MSGMETA::END>' "
data[1]2 ':' 8Z30-87h px� 
�
�A LUT '%s' is driving clock pin of %s registers. This could lead to large hold time violations. First few involved registers are:
%s524*place24
2sync_state_machine/FSM_sequential_new_state[4]_i_42
92�
�	sync_state_machine/FSM_sequential_new_state_reg[3] {FDRE}
	sync_state_machine/FSM_sequential_new_state_reg[2] {FDRE}
	sync_state_machine/FSM_sequential_new_state_reg[1] {FDRE}
	sync_state_machine/FSM_sequential_new_state_reg[4] {FDRE}
	sync_state_machine/FSM_sequential_new_state_reg[0] {FDRE}
Z30-568h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
n
%s*common2U
SPhase 1.2 IO Placement/ Clock Placement/ Build Placer Device | Checksum: 19a8c0da2
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.134 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
Y

Phase %s%s
101*constraints2
1.3 2
Build Placer Netlist ModelZ18-101h px� 
V
%s*common2=
;Phase 1.3 Build Placer Netlist Model | Checksum: 19f5a5eed
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.193 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
V

Phase %s%s
101*constraints2
1.4 2
Constrain Clocks/MacrosZ18-101h px� 
S
%s*common2:
8Phase 1.4 Constrain Clocks/Macros | Checksum: 19f5a5eed
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.196 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
O
%s*common26
4Phase 1 Placer Initialization | Checksum: 19f5a5eed
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.202 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
M

Phase %s%s
101*constraints2
2 2
Global PlacementZ18-101h px� 
L

Phase %s%s
101*constraints2
2.1 2
FloorplanningZ18-101h px� 
I
%s*common20
.Phase 2.1 Floorplanning | Checksum: 19f5a5eed
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.207 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
`

Phase %s%s
101*constraints2
2.2 2#
!Update Timing before SLR Path OptZ18-101h px� 
]
%s*common2D
BPhase 2.2 Update Timing before SLR Path Opt | Checksum: 19f5a5eed
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.208 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
_

Phase %s%s
101*constraints2
2.3 2"
 Post-Processing in FloorplanningZ18-101h px� 
\
%s*common2C
APhase 2.3 Post-Processing in Floorplanning | Checksum: 19f5a5eed
h px� 
�

%s
*constraints2a
_Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.208 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
R

Phase %s%s
101*constraints2
2.4 2
Global Place Phase1Z18-101h px� 
O
%s*common26
4Phase 2.4 Global Place Phase1 | Checksum: 239dfa68c
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
R

Phase %s%s
101*constraints2
2.5 2
Global Place Phase2Z18-101h px� 
�
dTiming had been disabled during Placer and, therefore, physical synthesis in Placer will be skipped.29*	placeflowZ46-29h px� 
O
%s*common26
4Phase 2.5 Global Place Phase2 | Checksum: 1c0966042
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
J
%s*common21
/Phase 2 Global Placement | Checksum: 1c0966042
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
M

Phase %s%s
101*constraints2
3 2
Detail PlacementZ18-101h px� 
Y

Phase %s%s
101*constraints2
3.1 2
Commit Multi Column MacrosZ18-101h px� 
V
%s*common2=
;Phase 3.1 Commit Multi Column Macros | Checksum: 1c0966042
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
[

Phase %s%s
101*constraints2
3.2 2
Commit Most Macros & LUTRAMsZ18-101h px� 
X
%s*common2?
=Phase 3.2 Commit Most Macros & LUTRAMs | Checksum: 1a6d06736
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
U

Phase %s%s
101*constraints2
3.3 2
Area Swap OptimizationZ18-101h px� 
R
%s*common29
7Phase 3.3 Area Swap Optimization | Checksum: 19be86136
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
]

Phase %s%s
101*constraints2
3.4 2 
Pipeline Register OptimizationZ18-101h px� 
Z
%s*common2A
?Phase 3.4 Pipeline Register Optimization | Checksum: 19be86136
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:01 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
[

Phase %s%s
101*constraints2
3.5 2
Small Shape Detail PlacementZ18-101h px� 
X
%s*common2?
=Phase 3.5 Small Shape Detail Placement | Checksum: 22690d684
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
Q

Phase %s%s
101*constraints2
3.6 2
Re-assign LUT pinsZ18-101h px� 
N
%s*common25
3Phase 3.6 Re-assign LUT pins | Checksum: 22690d684
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
]

Phase %s%s
101*constraints2
3.7 2 
Pipeline Register OptimizationZ18-101h px� 
Z
%s*common2A
?Phase 3.7 Pipeline Register Optimization | Checksum: 22690d684
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
J
%s*common21
/Phase 3 Detail Placement | Checksum: 22690d684
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
e

Phase %s%s
101*constraints2
4 2*
(Post Placement Optimization and Clean-UpZ18-101h px� 
W

Phase %s%s
101*constraints2
4.1 2
Post Commit OptimizationZ18-101h px� 
T
%s*common2;
9Phase 4.1 Post Commit Optimization | Checksum: 22690d684
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
U

Phase %s%s
101*constraints2
4.2 2
Post Placement CleanupZ18-101h px� 
R
%s*common29
7Phase 4.2 Post Placement Cleanup | Checksum: 22690d684
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
O

Phase %s%s
101*constraints2
4.3 2
Placer ReportingZ18-101h px� 
[

Phase %s%s
101*constraints2
4.3.1 2
Print Estimated CongestionZ18-101h px� 
�
'Post-Placement Estimated Congestion %s
38*	placeflow2�
�
 ____________________________________________________
|           | Global Congestion | Short Congestion  |
| Direction | Region Size       | Region Size       |
|___________|___________________|___________________|
|      North|                1x1|                1x1|
|___________|___________________|___________________|
|      South|                1x1|                1x1|
|___________|___________________|___________________|
|       East|                1x1|                1x1|
|___________|___________________|___________________|
|       West|                1x1|                1x1|
|___________|___________________|___________________|
Z30-612h px� 
X
%s*common2?
=Phase 4.3.1 Print Estimated Congestion | Checksum: 22690d684
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
L
%s*common23
1Phase 4.3 Placer Reporting | Checksum: 22690d684
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
V

Phase %s%s
101*constraints2
4.4 2
Final Placement CleanupZ18-101h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002

00:00:002

1696.9412
0.000Z17-268h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
b
%s*common2I
GPhase 4 Post Placement Optimization and Clean-Up | Checksum: 1b93c5f84
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 
D
%s*common2+
)Ending Placer Task | Checksum: 12d9e5c39
h px� 
}

%s
*constraints2]
[Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 1696.941 ; gain = 0.000h px� 

G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
462
32
212
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
place_designZ4-42h px� 
�
)Running report commands "%s" in parallel.56334*	planAhead24
2report_control_sets, report_io, report_utilizationZ12-24838h px� 
Y
+Running report generation with %s threads.
56333*	planAhead2
2Z12-24831h px� 
�
Executing command : %s
56330*	planAhead2S
Qreport_utilization -file vdg_utilization_placed.rpt -pb vdg_utilization_placed.pbZ12-24828h px� 
e
Executing command : %s
56330*	planAhead2#
!report_io -file vdg_io_placed.rptZ12-24828h px� 
�
kreport_io: Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.089 . Memory (MB): peak = 1696.941 ; gain = 0.000
*commonh px� 
�
Executing command : %s
56330*	planAhead2@
>report_control_sets -verbose -file vdg_control_sets_placed.rptZ12-24828h px� 
�
ureport_control_sets: Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.002 . Memory (MB): peak = 1696.941 ; gain = 0.000
*commonh px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write ShapeDB Complete: 2

00:00:002
00:00:00.0032

1696.9412
0.000Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote PlaceDB: 2

00:00:002
00:00:00.0652

1696.9612
0.020Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote PulsedLatchDB: 2

00:00:002

00:00:002

1696.9612
0.000Z17-268h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote RouteStorage: 2

00:00:002
00:00:00.0172

1696.9612
0.000Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote Netlist Cache: 2

00:00:002
00:00:00.0012

1696.9612
0.000Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Wrote Device Cache: 2

00:00:002
00:00:00.0072

1696.9612
0.000Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write Physdb Complete: 2

00:00:002
00:00:00.0992

1696.9612
0.020Z17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint22
0D:/Vivado/S6847/S6847.runs/impl_1/vdg_placed.dcpZ17-1381h px� 


End Record