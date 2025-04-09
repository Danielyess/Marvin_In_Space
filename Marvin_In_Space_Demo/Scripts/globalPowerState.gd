class_name Pwr
enum PowerState{ON, OFF}

#Functions for the logic gates

static func NOT(A : PowerState) -> PowerState:
	if A == PowerState.ON:
		return PowerState.OFF
	else:
		return PowerState.ON

static func OR(A : PowerState, B : PowerState) -> PowerState:
	if A == PowerState.ON or B == PowerState.ON:
		return PowerState.ON
	else:
		return PowerState.OFF

static func AND(A : PowerState, B : PowerState) -> PowerState:
	if A == PowerState.ON and B == PowerState.ON:
		return PowerState.ON
	else:
		return PowerState.OFF

static func XOR(A : PowerState, B : PowerState) -> PowerState:
	if ((A == PowerState.ON and B == PowerState.OFF)  
	or (B == PowerState.ON and A == PowerState.OFF)):
		return PowerState.ON
	else:
		return PowerState.OFF

static func NOR(A : PowerState, B : PowerState) -> PowerState:
	if A == PowerState.ON or B == PowerState.ON:
		return PowerState.OFF
	else:
		return PowerState.ON

static func NAND(A : PowerState, B : PowerState) -> PowerState:
	if A == PowerState.ON and B == PowerState.ON:
		return PowerState.OFF
	else:
		return PowerState.ON
