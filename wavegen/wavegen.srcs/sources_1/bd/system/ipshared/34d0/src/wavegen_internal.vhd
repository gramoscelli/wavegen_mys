----------------------------------------------------------------
-- Module Name: lab3_user_logic
-----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity wavegen_internal is
	generic (
        C_S_AXI_DATA_WIDTH    : integer    := 32;
        C_S_AXI_ADDR_WIDTH    : integer    := 4
    );
	port(
		S_AXI_ACLK: in std_logic;
		slv_reg_wren: in std_logic;
		axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_ARESETN: in std_logic;
		clk_i: in std_logic;
		dac_out: out std_logic_vector(15 downto 0)
	);
end;

architecture wavegen_internal_tb of wavegen_internal is
begin

	process(S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then
			if S_AXI_ARESETN = '0' then
				dac_out <= (others => '0');
			elsif slv_reg_wren = '1' and axi_awaddr = "00" then
                dac_out <= S_AXI_WDATA;			
            elsif slv_reg_wren = '1' and axi_awaddr = "01" then
                dac_out <= not S_AXI_WDATA;
			end if;
		end if;
	end process;

end;