class_name Pwr
enum PowerState{ON, OFF}


static func OR(one : PowerState, two : PowerState) -> PowerState:
	if one == PowerState.ON or two == PowerState.ON:
		return PowerState.ON
	else:
		return PowerState.OFF

static func XOR(one : PowerState, two : PowerState) -> PowerState:
	if ((one == PowerState.ON and two == PowerState.OFF)  
	or (two == PowerState.ON and one == PowerState.OFF)):
		return PowerState.ON
	else:
		return PowerState.OFF

static func NOR(one : PowerState, two : PowerState) -> PowerState:
	if one == PowerState.ON or two == PowerState.ON:
		return PowerState.OFF
	else:
		return PowerState.ON

static func AND(one : PowerState, two : PowerState) -> PowerState:
	if one == PowerState.ON and two == PowerState.ON:
		return PowerState.ON
	else:
		return PowerState.OFF

static func NAND(one : PowerState, two : PowerState) -> PowerState:
	if one == PowerState.ON and two == PowerState.ON:
		return PowerState.OFF
	else:
		return PowerState.ON

static func NOT(one : PowerState) -> PowerState:
	if one == PowerState.ON:
		return PowerState.OFF
	else:
		return PowerState.ON

static func BUFFER(one : PowerState) -> PowerState:
	return one
