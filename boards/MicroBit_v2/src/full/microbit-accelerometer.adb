------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2018-2019, AdaCore                      --
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
with MicroBit.I2C;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Generic_Elementary_Functions;
package body MicroBit.Accelerometer is

   Acc  : LSM303AGR.LSM303AGR_Accelerometer (MicroBit.I2C.Controller);

   procedure Initialize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      if not MicroBit.I2C.Initialized then
         MicroBit.I2C.Initialize;
      end if;

      Acc.Configure (LSM303AGR.Freq_400, LSM303AGR.Freq_100, LSM303AGR.Continuous_Mode);
   end Initialize;

   ----------
   -- Data --
   ----------

   function AccelDataRaw return LSM303AGR.All_Axes_Data_Raw
   is (Acc.Read_Accelerometer_Raw);

   function AccelData return LSM303AGR.All_Axes_Data
   is (Acc.Read_Accelerometer);

   function MagData return LSM303AGR.All_Axes_Data
   is (Acc.Read_Magnetometer);

   --Based on https://rosettacode.org/wiki/Map_range#Ada
   function Map ( Value : Float;
                  A1 : Float; -- Range Min (from)
                  A2 : Float; -- Range Max (from)
                  B1 : Float; -- Range Min (to)
                  B2 : Float -- Range Max (to)
                ) return Float is
   begin
      return B1 + (Value - A1) * (B2 - B1) / (A2 - A1);
   end Map;

   function Heading return LSM303AGR.Angle is
      package test is new Generic_Elementary_Functions (Float_Type => Float);
      Data : LSM303AGR.All_Axes_Data;
      Result: Float;
      X : Float;
      Y : Float;
      Z : Float;
      Angle : Integer;
   begin
      --get raw sensor data
      Data := MagData;
      X := Float (Data.X);
      Y := Float (Data.Y);
      Z := Float (Data.Z);

      --map to known ranges using calibrated values (or 0 for using factory default)
      --it is up to the programmer to call calibrate first (although recommended)
      X := Map(X, MagMinX, MagMaxX, -1023.0, 1023.0);
      Y := Map(Y, MagMinY, MagMaxY, -1023.0, 1023.0);
      Z := Map(Z, MagMinZ, MagMaxZ, 0.0, 1023.0);

      --calc angle
      Result := (Test.Arctan(Y, X) * 180.0) / Pi;
      Result := Result + 90.0;

      --normalize such we can cast to Angle.
      Angle := Integer(Result) mod 360;

      return LSM303AGR.Angle(Angle);
   end Heading;

begin
   Initialize;
end MicroBit.Accelerometer;
