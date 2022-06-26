----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.06.2022 15:19:21
-- Design Name: 
-- Module Name: signal_internal - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
-- use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity signal_internal is
	generic (
        C_S_AXI_ADDR_WIDTH    : integer    := 4
    );
	port(
		S_AXI_ACLK: in std_logic;
		slv_reg_wren: in std_logic;
		axi_awaddr: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_WDATA: in std_logic_vector(31 downto 0);
		S_AXI_ARESETN: in std_logic;
		clk_i: in std_logic;
		dac_out: out std_logic_vector(15 downto 0)
	);
end;

architecture signal_internal_tb of signal_internal is
    signal sgn_div_int: std_logic_vector(31 downto 0);
    signal sgn_ampl_int: std_logic_vector(31 downto 0);
    signal dac_out_en: std_logic;
begin

	process(S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				dac_out_en <= '0';
			elsif slv_reg_wren = '1' then
			     dac_out_en <= '1';
			     if axi_awaddr = "0000" then
				    sgn_div_int <= S_AXI_WDATA;
				 elsif axi_awaddr = "0001" then
		            sgn_ampl_int <= S_AXI_WDATA;
                 end if;
			end if;
		end if;
	end process;
	
	process(clk_i)
       constant despl: natural := 11;
       variable cont: integer;
       variable repe: integer;
       variable x: integer;
       variable y: integer;
       variable dac_value: integer;
    begin
        if rising_edge(clk_i) then
            if (repe <0) then
                  repe := 0;
            end if;
            if (cont<0) then
                  cont := 0;
            end if;
            if (repe < to_integer(unsigned(sgn_div_int))) then
               repe := repe + 1;
            else
                repe := 0;
                if (cont = 0) then
                      x := 16#7FFFFFFF#;
                      y := 0;
                elsif (cont < 3216) then
                    x := x - to_integer(shift_right(to_unsigned(y, 32), despl));
                    y := y + to_integer(shift_right(to_unsigned(x, 32), despl));
                elsif (cont < 6429) then
                    x := x + to_integer(shift_right(to_unsigned(y, 32), despl));
                    y := y - to_integer(shift_right(to_unsigned(x, 32), despl));
                elsif (cont < 9642) then
                    x := x - to_integer(shift_right(to_unsigned(y, 32), despl));
                    y := y + to_integer(shift_right(to_unsigned(x, 32), despl));
                elsif (cont < 12854) then
                    x := x + to_integer(shift_right(to_unsigned(y, 32), despl));
                    y := y - to_integer(shift_right(to_unsigned(x, 32), despl));
                end if; 
                dac_value := to_integer(shift_right(to_unsigned(y, 31), 16));
                if (cont >= 6429) then
                     dac_value := 16#8000# - dac_value;
                else
                     dac_value := dac_value + 16#8000#;
                end if;
                dac_value := to_integer(shift_right(to_unsigned(dac_value * to_integer(unsigned(sgn_ampl_int)), 32), 16));
                --dac_value := dac_value *32768;
                --dac_value := to_integer(shift_right(to_unsigned(dac_value, 32), 16));  -- e.g. div by 65536
                cont := cont +1;
                if (cont >= 12854) then
                    cont := 0;
                end if;
            end if;
            if (dac_out_en = '1') then
                 dac_out  <= std_logic_vector(to_unsigned(dac_value, 16));
            else
                 dac_out  <= (others => '1');
            end if;
		end if;
	end process;	
end;
