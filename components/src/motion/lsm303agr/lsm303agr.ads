------------------------------------------------------------------------------
--                                                                          --
--                       Copyright (C) 2020, AdaCore                        --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------
with HAL;     use HAL;
with HAL.I2C; use HAL.I2C;

private with Ada.Unchecked_Conversion;

package LSM303AGR is
    -- TODO: support other power modes HiRes/LoPower,
    -- Specifically allowing them in configure procedure
    -- and adjusting conversions after reading the
    -- accelerometer sensor.

   type Register_Address is new UInt8;
   type Device_Identifier is new UInt8;
   type Data_Rate is
     (PowerDown, Freq_1, Freq_10, Freq_25, Freq_50, Freq_100, Freq_200,
      Freq_400, Low_Power, Hi_Res_1k6_Low_power_5k3);

   type Data_Rate_Mag is
     (Freq_10, Freq_20, Freq_50, Freq_100);

   type System_Mode_Mag is
   (Continuous_Mode, Single_Mode, Idle_Mode);

   type Axis_Data is range -2**9 .. 2**9 - 1 with Size => 10; -- we decimate from 16 (the output of the accel device) to 10 bits? Why?
                                                              -- Does this mean that the actual range is -512 .. 511?

   type Angle is range 0 .. 360;
   type Axis_Data_Raw is record
      Low : UInt8;
      High : UInt8;
   end record;

   type All_Axes_Data is record
      X, Y, Z : Axis_Data;
   end record;

      type All_Axes_Data_Raw is record
      X, Y, Z : Axis_Data_Raw;
   end record;

   type LSM303AGR_Accelerometer (Port : not null Any_I2C_Port) is
     tagged limited private;

   function Check_Accelerometer_Device_Id
     (This : LSM303AGR_Accelerometer) return Boolean;

   function Check_Magnetometer_Device_Id
     (This : LSM303AGR_Accelerometer) return Boolean;

   procedure Configure (This : LSM303AGR_Accelerometer;
                        DR : Data_Rate;
                        DR_Mag : Data_Rate_Mag;
                        SM_Mag : System_Mode_Mag);

   function Read_Accelerometer
     (This : LSM303AGR_Accelerometer) return All_Axes_Data;

   function Read_Accelerometer_Raw
     (This : LSM303AGR_Accelerometer) return All_Axes_Data_Raw;


   function Read_Magnetometer
     (This : LSM303AGR_Accelerometer) return All_Axes_Data;

   function Convert (Low, High : UInt8) return Axis_Data;


private
   type LSM303AGR_Accelerometer (Port : not null Any_I2C_Port)
   is tagged limited null record;

   for Data_Rate use
     (PowerDown => 0, Freq_1 => 1, Freq_10 => 2, Freq_25 => 3, Freq_50 => 4,
      Freq_100 => 5, Freq_200 => 6, Freq_400 => 7, Low_Power => 8,
      Hi_Res_1k6_Low_power_5k3 => 9);

   for Data_Rate_Mag use
     (Freq_10 => 0, Freq_20 => 1, Freq_50 => 2, Freq_100 => 3);

   for System_Mode_Mag use
      (Continuous_Mode => 0, Single_Mode => 1, Idle_Mode=> 2);

   Accelerometer_Address   : constant I2C_Address       := 16#32#;
   Accelerometer_Device_Id : constant Device_Identifier := 2#0011_0011#;

   Magnetometer_Address   : constant I2C_Address       := 16#3C#;
   Magnetometer_Device_Id : constant Device_Identifier := 2#0100_0000#;

   WHO_AM_I_A : constant Register_Address := 16#0F#;
   WHO_AM_I_M : constant Register_Address := 16#4F#;

   CTRL_REG1_A : constant Register_Address := 16#20#;
   CTRL_REG2_A : constant Register_Address := 16#21#;
   CTRL_REG3_A : constant Register_Address := 16#22#;
   CTRL_REG4_A : constant Register_Address := 16#23#;
   CTRL_REG5_A : constant Register_Address := 16#24#;
   CTRL_REG6_A : constant Register_Address := 16#25#;


   CFG_REG_A_M : constant Register_Address := 16#60#;


   DATACAPTURE_A : constant Register_Address := 16#26#;
   STATUS_REG_A  : constant Register_Address := 16#27#;
   OUT_X_L_A     : constant Register_Address := 16#28#;
   OUT_X_H_A     : constant Register_Address := 16#29#;
   OUT_Y_L_A     : constant Register_Address := 16#2A#;
   OUT_Y_H_A     : constant Register_Address := 16#2B#;
   OUT_Z_L_A     : constant Register_Address := 16#2C#;
   OUT_Z_H_A     : constant Register_Address := 16#2D#;

   OUT_X_L_REG_M : constant Register_Address := 16#68#;
   OUT_X_H_REG_M : constant Register_Address := 16#69#;
   OUT_Y_L_REG_M : constant Register_Address := 16#6A#;
   OUT_Y_H_REG_M : constant Register_Address := 16#6B#;
   OUT_Z_L_REG_M : constant Register_Address := 16#2C#;
   OUT_Z_H_REG_M : constant Register_Address := 16#2D#;

   MULTI_BYTE_READ : constant := 2#1000_0000#;

   NORMAL_MODE_DIVISOR : constant := 6;

   type CTRL_REG1_A_Register is record
      Xen  : Bit   := 0;
      Yen  : Bit   := 0;
      Zen  : Bit   := 0;
      LPen : Bit   := 0;
      ODR  : UInt4 := 0;
   end record;

   for CTRL_REG1_A_Register use record
      Xen  at 0 range 0 .. 0;
      Yen  at 0 range 1 .. 1;
      Zen  at 0 range 2 .. 2;
      LPen at 0 range 3 .. 3;
      ODR  at 0 range 4 .. 7;
   end record;

   function To_UInt8 is new Ada.Unchecked_Conversion
     (CTRL_REG1_A_Register, UInt8);
   function To_Reg is new Ada.Unchecked_Conversion
     (UInt8, CTRL_REG1_A_Register);

   type STATUS_REG_A_Register is record
      ZYXOVR : Bit := 0;
      ZOVR   : Bit := 0;
      YOVR   : Bit := 0;
      XOVR   : Bit := 0;
      ZYXDA  : Bit := 0;
      ZDA    : Bit := 0;
      YDA    : Bit := 0;
      XDA    : Bit := 0;
   end record;

   for STATUS_REG_A_Register use record
      XDA at 0 range 0 .. 0;
      YDA at 0 range 1 .. 1;
      ZDA at 0 range 2 .. 2;

      ZYXDA at 0 range 3 .. 3;

      XOVR at 0 range 4 .. 4;
      YOVR at 0 range 5 .. 5;
      ZOVR at 0 range 6 .. 6;

      ZYXOVR at 0 range 7 .. 7;
   end record;

   function To_UInt8 is new Ada.Unchecked_Conversion
     (STATUS_REG_A_Register, UInt8);
   function To_Reg is new Ada.Unchecked_Conversion
     (UInt8, STATUS_REG_A_Register);


   ----Magnetometer
   type CFG_REG_A_M_Register is record
      MD           : UInt2 := 0;
      ODR          : UInt2 := 0;
      LP           : Bit   := 0;
      SOFT_RST     : Bit   := 0;
      REBOOT       : Bit   := 0;
      COMP_TEMP_EN : Bit   := 0;
   end record;

   for CFG_REG_A_M_Register use record
      MD            at 0 range 0 .. 1;
      ODR           at 0 range 2 .. 3;
      LP            at 0 range 4 .. 4;
      SOFT_RST      at 0 range 5 .. 5;
      REBOOT        at 0 range 6 .. 6;
      COMP_TEMP_EN  at 0 range 7 .. 7;
   end record;

     function To_UInt8 is new Ada.Unchecked_Conversion
     (CFG_REG_A_M_Register, UInt8);
   function To_Reg is new Ada.Unchecked_Conversion
     (UInt8, CFG_REG_A_M_Register);

end LSM303AGR;
