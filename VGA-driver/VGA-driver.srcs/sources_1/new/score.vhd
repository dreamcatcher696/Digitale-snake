----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2016 17:50:55
-- Design Name: 
-- Module Name: test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity score is
    Port ( 
            reset_sig : in STD_LOGIC;
            punt_sig : in STD_LOGIC;
            clk : in STD_LOGIC;
            seg : out STD_LOGIC_VECTOR (6 downto 0);
            an : out STD_LOGIC_VECTOR (3 downto 0)
          );
end score;

architecture Behavioral of score is

signal multiplex_teller: integer range 0 to 1000000:=0;
signal teller0: integer range 0 to 9 := 0;
signal teller1: integer range 0 to 9 := 0;

signal reset_enable: bit := '1';
signal punt_enable: bit := '1';

begin

    
    process (clk) begin
        if rising_edge (clk) then
            multiplex_teller <= multiplex_teller + 1;
            
            if (multiplex_teller = 500000) then
                
                an <= "1110";
                    case (teller0) is
                        when 0 => seg <= "1000000";
                        when 1 => seg <= "1111001";
                        when 2 => seg <= "0100100";
                        when 3 => seg <= "0110000";
                        when 4 => seg <= "0011001";
                        when 5 => seg <= "0010010";
                        when 6 => seg <= "0000010";
                        when 7 => seg <= "1011000";
                        when 8 => seg <= "0000000";
                        when 9 => seg <= "0010000";  
                        when others => seg <= "1111111";
                    end case;  
            elsif (multiplex_teller = 1000000) then
                --an <= "1111";
                an <= "1101";
                    case (teller1) is
                        when 0 => seg <= "1000000";
                        when 1 => seg <= "1111001";
                        when 2 => seg <= "0100100";
                        when 3 => seg <= "0110000";
                        when 4 => seg <= "0011001";
                        when 5 => seg <= "0010010";
                        when 6 => seg <= "0000010";
                        when 7 => seg <= "1011000";
                        when 8 => seg <= "0000000";
                        when 9 => seg <= "0010000";  
                        when others => seg <= "1111111";
                    end case; 
            end if;  
        end if;
                
    end process;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if (reset_sig = '1' and reset_enable = '1') then
                reset_enable <= '0';
                teller0 <= 0;
                teller1 <= 0;
            elsif (reset_sig = '0' and reset_enable = '0') then
                reset_enable <= '1';
            end if;
            if (punt_sig = '1' and punt_enable = '1') then
                punt_enable <= '0';
                teller0 <= teller0 + 1;
                if(teller0 = 9) then
                    teller0 <= 0;
                    teller1 <= teller1 + 1;
                    if (teller1 = 9 and teller0 = 9) then
                        teller1 <= 0;
                    end if;
                end if;
            elsif (punt_sig = '0' and punt_enable = '0') then
                punt_enable <= '1';
            end if;
        end if;
    end process;
end Behavioral;