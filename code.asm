asect 0x00
dc 0xff

ldi r1, IO3
ldi r2, IO4
ldi r3, IO5

ld r1, r1
ld r2, r2
ld r3, r3
push r3

shra r1
shra r1
shra r1

ldi r0, 0b00000100
if 
	and r1, r0
is nz
	ldi r0, 0b11111000
	or r0, r1
fi

#Вычисляем (224 – x)/vx
ldi r3, 224
sub r3, r2
shra r2
ldi r0, 0b01111111
and r0, r2

#Вычичисляем (224 – x)/vx × vy.
ldi r3, 0
if 
	tst r1
is mi
	ldi r0, -4  
	if 
		cmp r0, r1
	is eq
		if 
			shla r2
		is cs
			inc r3
		fi
		if 
			shla r2
		is cs
			inc r3
		fi
	fi
	
	ldi r0, -3
	if 
		cmp r0, r1
	is eq
		move r2, r0

		if 
			shla r2
		is cs
			inc r3
		fi
		
		if 
			add r0, r2
		is cs
			inc r3
		fi
	fi
	
	ldi r0, -2
	if 
		cmp r0, r1
	is eq
		if 
			shla r2
		is cs
			inc r3
		fi
	fi
	if 
		neg r2
	is cs
		inc r3
	fi
else
	ldi r0, 3
	if 
		cmp r0, r1
	is eq
		move r0, r2
		if 
			shla r2
		is cs
			inc r3
		fi
		if 
			add r0, r2
		is cs
			inc r3
		fi
	fi
	
	ldi r0, 2
	if 
		cmp r0, r1
	is eq
		if 
			shla r2
		is cs
			inc r3
		fi
	fi
	
	if 
		tst r1
	is z
		ldi r2, 0
	fi    	
fi

pop r0
if 
	tst r1
is mi
	if
		add r0, r2
	is cc
		inc r3
	fi
else
	if
		add r0, r2
	is cs
		inc r3
	fi
fi

if
	shra r3
is cs
	neg r2
fi

ldi r1, IO3
st r1, r2
br 0x00

#Test>
#vxy: dc 0b00101010
#ballX: dc 135
#ballY: dc 50
#EndTest> 

asect 0xf3
Ports>
IO3: ds 1
IO4: ds 1
IO5: ds 1
EndPorts>

end