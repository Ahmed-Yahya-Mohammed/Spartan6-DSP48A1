module DSP(A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
          CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
    parameter A0REG=0;
    parameter B0REG=0;
    parameter CREG=1;
    parameter DREG=1;
    parameter A1REG=1;
    parameter B1REG=1;
    parameter MREG=1;
    parameter PREG=1;
    parameter CARRYINREG=1;
    parameter CARRYOUTREG=1;
    parameter OPMODEREG=1;
    parameter CARRYINSEL="OPMODE5";
    parameter B_INPUT="DIRECT";
    parameter RSTTYPE="SYNC"; 
    input CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
    input CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
    input[7:0] OPMODE;
    input[17:0] A,B,D,BCIN;
    input[47:0] C,PCIN;
    output CARRYOUT,CARRYOUTF;
    output [17:0] BCOUT;
    output [35:0] M;
    output [47:0] P,PCOUT;
    reg[17:0] A_stag1,B_stag1,D_stag1,add_wire1,add_mux,A_stag2,B_stag2;
    reg[47:0] C_stag1;
    reg[7:0] OPMODE_stag1;
    wire[17:0] B_mux0,D_mux1,B_mux1,A_mux1,B_mux2,A_mux2;
    wire[47:0] C_mux1;
    wire[7:0] OPMODE_mux1;
    wire[35:0] mult_wire,M_mux;
    reg[35:0] M_stag1;
    wire CIN_mux,CIN;
    reg CYI_stag1,cout,CYO_stag1;
    reg[47:0] X_mux,Z_mux,add_wire2,P_stag1;

    // first level one mux for signal B
    generate
    	if(B_INPUT=="DIRECT")
      	  assign B_mux0=B;
    	else if(B_INPUT=="CASCADE")
    	  assign B_mux0=BCIN;
    	else 
    	  assign B_mux0=0;    
    endgenerate

    // second level 5 all flip flops 
    generate
    	if(RSTTYPE=="SYNC")begin
    	// Synchronous reset signals
    		always @(posedge CLK) begin
    			if (RSTA) begin //check A0REG & A1REG
                    A_stag1<=0;
                    A_stag2<=0;
                end
                else if(CEA) begin
                    A_stag1<=A;
                    A_stag2<=A_mux1;
                end 
                if (RSTB) begin  //check B0REG & B1REG
                    B_stag1<=0;
                    B_stag2<=0;
                end
                else if(CEB) begin
                    B_stag1<=B_mux0;
                    B_stag2<=add_mux;
                end
                if (RSTC)  //check CREG 
                    C_stag1<=0;
                else if(CEC)
                    C_stag1<=C;    
                if (RSTD)  //check DREG 
                    D_stag1<=0;
                else if(CED)
                    D_stag1<=D;
                if (RSTOPMODE)  //check OPMODE
                    OPMODE_stag1<=0;
                else if(CEOPMODE)
                    OPMODE_stag1<=OPMODE;
                if(RSTM)
                    M_stag1<=0;
                else if(CEM)
                    M_stag1<=mult_wire;
                if(RSTCARRYIN)begin
                    CYI_stag1<=0;
                    CYO_stag1<=0;
                end
                else if(CECARRYIN) begin  
                    CYI_stag1<=CIN_mux;
                    CYO_stag1<=cout;
                end
                if(RSTP)
                    P_stag1<=0;
                else if(CEP) 
                    P_stag1<=add_wire2;
            end
        end
        else if (RSTTYPE=="ASYNC") begin
        // Asynchronous reset signals
            always @(posedge CLK or posedge RSTA or posedge RSTB or posedge RSTM
                          or posedge RSTP or posedge RSTC or posedge RSTD 
                          or posedge RSTCARRYIN or posedge RSTOPMODE ) begin
                if (RSTA) begin //check A0REG & A1REG
                    A_stag1<=0;
                    A_stag2<=0;
                end
                else if(CEA) begin
                    A_stag1<=A;
                    A_stag2<=A_mux1;
                end 
                if (RSTB) begin  //check B0REG & B1REG
                    B_stag1<=0;
                    B_stag2<=0;
                end
                else if(CEB) begin
                    B_stag1<=B_mux0;
                    B_stag2<=add_mux;
                end
                if (RSTC)  //check CREG 
                    C_stag1<=0;
                else if(CEC)
                    C_stag1<=C;    
                if (RSTD)  //check DREG 
                    D_stag1<=0;
                else if(CED)
                    D_stag1<=D;
                if (RSTOPMODE)  //check OPMODE
                    OPMODE_stag1<=0;
                else if(CEOPMODE)
                    OPMODE_stag1<=OPMODE;
                if(RSTM)
                    M_stag1<=0;
                else if(CEM)
                    M_stag1<=mult_wire;
                if(RSTCARRYIN)begin
                    CYI_stag1<=0;
                    CYO_stag1<=0;
                end
                else if(CECARRYIN) begin  
                    CYI_stag1<=CIN_mux;
                    CYO_stag1<=cout;
                end
                if(RSTP)
                    P_stag1<=0;
                else if(CEP) 
                    P_stag1<=add_wire2;
            end
        end
    endgenerate

    // third level 5 muxs for A,B,C,D,opmode
    generate
    	if(DREG)
    	  assign D_mux1=D_stag1;
    	else 
    	  assign D_mux1=D;
    	if(B0REG)
    	  assign B_mux1=B_stag1;
    	else 
    	  assign B_mux1=B_mux0;
    	if(A0REG)
    	  assign A_mux1=A_stag1;
    	else 
    	  assign A_mux1=A;
    	if(CREG)
    	  assign C_mux1=C_stag1;
    	else
    	  assign C_mux1=C;
    	if(OPMODEREG)
    	  assign OPMODE_mux1=OPMODE_stag1;
    	else 
    	  assign OPMODE_mux1=OPMODE;        	
    endgenerate
    //fourth level pre-adder/subtractor
    always @(*) begin
    	if(!OPMODE_mux1[6])
    	  add_wire1=D_mux1+B_mux1;
    	else 
    	  add_wire1=D_mux1-B_mux1; 
        if(OPMODE_mux1[4])
          add_mux=add_wire1;
        else 
          add_mux=B_mux1;  
    end
    //fifth level 2 muxs
    generate
    	if(B1REG)
    	  assign B_mux2=B_stag2;
    	else
    	  assign B_mux2=add_mux;
        assign BCOUT=B_mux2;
    	if(A1REG)
    	  assign A_mux2=A_stag2;
    	else 
    	  assign A_mux2=A_mux1;
    endgenerate

    //sixth level multiplier
    assign mult_wire=B_mux2*A_mux2;
    //seventh level MREG mux
    generate
      if(MREG)
        assign M_mux=M_stag1;
      else 
        assign M_mux=mult_wire;   
      assign M=M_mux; 
    endgenerate
    //Carry in
    generate
       if(CARRYINSEL=="OPMODE5")
         assign CIN_mux=OPMODE_mux1[5];
       else if(CARRYINSEL=="CARRYIN")
         assign CIN_mux=CARRYIN;
       else 
         assign CIN_mux=0;
       if(CARRYINREG)
         assign CIN=CYI_stag1;
       else 
         assign CIN=CIN_mux;      
    endgenerate
    // eighth level X & Z muxs
    always @(*) begin
        case(OPMODE_mux1[1:0])
        0: X_mux=0;
        1: X_mux={{12{M_mux[35]}},M_mux};
        2: X_mux=PCOUT;
        3: X_mux={D_mux1[11:0],A_mux2,B_mux2};
        endcase
        case(OPMODE_mux1[3:2])
        0: Z_mux=0;
        1: Z_mux=PCIN;
        2: Z_mux=P;
        3: Z_mux=C_mux1;
        endcase
    end
    
    //nineth level post-adder/subtractor
    always @(*) begin
        if(!OPMODE_mux1[7])
          {cout,add_wire2}=X_mux+Z_mux+CIN;
        else 
          {cout,add_wire2}=Z_mux-(X_mux+CIN);   
    end
    //Carryout
    generate
       if(CARRYOUTREG)
          assign CARRYOUT=CYO_stag1;
       else 
          assign CARRYOUT=cout;
       assign CARRYOUTF=CARRYOUT;
    endgenerate
    //tenth level PREG mux
    generate
        if(PREG)
          assign P=P_stag1;
        else 
          assign p=add_wire2; 
        assign PCOUT=P; 
    endgenerate
endmodule