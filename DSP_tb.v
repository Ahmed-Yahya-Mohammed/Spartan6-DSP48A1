module DSP_tb();
    reg CLK_tb,CARRYIN_tb,RSTA_tb,RSTB_tb,RSTM_tb,RSTP_tb,RSTC_tb,RSTD_tb,RSTCARRYIN_tb,RSTOPMODE_tb;
    reg CEA_tb,CEB_tb,CEM_tb,CEP_tb,CEC_tb,CED_tb,CECARRYIN_tb,CEOPMODE_tb;
    reg[7:0] OPMODE_tb;
    reg[17:0] A_tb,B_tb,D_tb,BCIN_tb;
    reg[47:0] C_tb,PCIN_tb;
    wire CARRYOUT_tb,CARRYOUTF_tb;
    wire [17:0] BCOUT_tb;
    wire [35:0] M_tb;
    wire [47:0] P_tb,PCOUT_tb;
    integer i,j;

    DSP DUT(A_tb,B_tb,C_tb,D_tb,CLK_tb,CARRYIN_tb,OPMODE_tb,BCIN_tb,
            RSTA_tb,RSTB_tb,RSTM_tb,RSTP_tb,RSTC_tb,RSTD_tb,RSTCARRYIN_tb,RSTOPMODE_tb,
            CEA_tb,CEB_tb,CEM_tb,CEP_tb,CEC_tb,CED_tb,CECARRYIN_tb,CEOPMODE_tb,
            PCIN_tb,BCOUT_tb,PCOUT_tb,P_tb,M_tb,CARRYOUT_tb,CARRYOUTF_tb);
    
    initial begin
    	CLK_tb=0;
        forever
        #1 CLK_tb=~CLK_tb;
    end
    initial begin
        OPMODE_tb=8'b00011101; // test default (D+B)*A+C
    //test clock enable
        CEA_tb=1;
        CEB_tb=1;
        CEC_tb=1;
        CED_tb=1;
        CECARRYIN_tb=1;
        CEM_tb=1;
        CEOPMODE_tb=1;
        CEP_tb=1;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;    
        end
        CEA_tb=0;
        CEB_tb=0;
        CEC_tb=0;
        CED_tb=0;
        CECARRYIN_tb=0;
        CEM_tb=0;
        CEOPMODE_tb=0;
        CEP_tb=0;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;    
        end
    //----------------------------------------------------------------------------------------------------------    
    //test Reset All
        RSTA_tb=1;
        RSTB_tb=1;
        RSTC_tb=1;
        RSTD_tb=1;
        RSTCARRYIN_tb=1;
        RSTM_tb=1;
        RSTOPMODE_tb=1;
        RSTP_tb=1;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;    
        end
    //----------------------------------------------------------------------------------------------------------
        CEA_tb=1;
        CEB_tb=1;
        CEC_tb=1;
        CED_tb=1;
        CECARRYIN_tb=1;
        CEM_tb=1;
        CEOPMODE_tb=1;
        CEP_tb=1;
    //test Reset A --> P=C
        RSTA_tb=1;
        RSTB_tb=0;
        RSTC_tb=0;
        RSTD_tb=0;
        RSTCARRYIN_tb=0;
        RSTM_tb=0;
        RSTOPMODE_tb=0;
        RSTP_tb=0;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;    
        end
    //---------------------------------------------------------------------------------------------------------------    
    //test Reset B --> P=C
        RSTA_tb=0;
        RSTB_tb=1;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;    
        end
    //----------------------------------------------------------------------------------------------------------------    
    //test Reset C --> P=(D+B)*A
        RSTB_tb=0;
        RSTC_tb=1;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;    
        end
    //-----------------------------------------------------------------------------------------------------------------    
    //test Reset D --> P=B*A+C
        RSTC_tb=0;
        RSTD_tb=1;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;    
        end
    //-----------------------------------------------------------------------------------------------------------------       
    //test Reset P -->P=0
        RSTD_tb=0;
        RSTP_tb=1;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;    
        end 
    //------------------------------------------------------------------------------------------------------------------ 
        RSTP_tb=0;  
    //test pre subtracter
        OPMODE_tb[6]=1;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;
        end
    //-------------------------------------------------------------------------------------------------------------------    
        OPMODE_tb[6]=0;
    //test bypass B instead of pre-adder out
        OPMODE_tb[4]=0;
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;
        end
    //------------------------------------------------------------------------------------------------------------------
        OPMODE_tb[4]=1;
        OPMODE_tb[3:2]=0;//to make P=X_mux only
    //test four cases of mux X 
    // 0-->0  1-->M  2-->PCOUT  3-->D:A:B
        for(j=0;j<4;j=j+1)begin
            OPMODE_tb[1:0]=j;
            for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            #10;
            end
        end

    //-----------------------------------------------------------------------------------------------------------------
        OPMODE_tb[1:0]=0; //to make P=Z_mux only
    //test four cases of mux Z 
    // 0-->0  1-->PCIN  2-->P  3-->C
        for(j=0;j<4;j=j+1)begin
            OPMODE_tb[3:2]=j;
            for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            PCIN_tb=$urandom_range(1,10);
            #10;
            end
        end 
    //-------------------------------------------------------------------------------------------------------------------
    //test both two muxs
        for(i=0;i<100;i=i+1)begin
            OPMODE_tb[3:0]=$random;
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(1,10);
            D_tb=$urandom_range(1,10);
            PCIN_tb=$urandom_range(1,10);
            #10;
        end
    //-----------------------------------------------------------------------------------------------------------------      
    // test post-subtracter  
        OPMODE_tb=8'b10011101; // test default (D+B)*A-C
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(20,50);
            D_tb=$urandom_range(1,10);
            #10;
            end
    //------------------------------------------------------------------------------------------------------------------ 
    // test carryin & carryout in Post-Adder/Subtracter
        OPMODE_tb=8'b00110100;  //OPMODE[5]=1 which means carryin equal 1 
        PCIN_tb={48{1'b1}};
        #10;  
        OPMODE_tb=8'b00111101; 
        for(i=0;i<10;i=i+1)begin
            A_tb=$urandom_range(1,10);
            B_tb=$urandom_range(1,10);
            C_tb=$urandom_range(20,50);
            D_tb=$urandom_range(1,10);
            #10;
        end
    $stop;
    end
endmodule

       