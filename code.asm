asect 0x00
dc 0xff #sets Stack Pointer at the address 0xFF

ldi r1, IO3 #loads address of IO-3, IO-4 and IO-5 into  
ldi r2, IO4 #registers r1, r2 and r3
ldi r3, IO5

ld r1, r1 #loads ball's velocity into r1  
ld r2, r2 #loads x coordinate of the ball into r2
ld r3, r3 #loads y coordinate of the ball into r3

push r3 #pushes the byte in r3 onto the stack 

shra r1 #since r1 stores the value of the two speeds vx 
shra r1 #and vy, we shift the number 3 bits to the
shra r1 #right to get the value in 3 bit representation

#converts 3-bit number to 8-bit
ldi r0, 0b00000100
if 
	and r1, r0
is nz
	ldi r0, 0b11111000
	or r0, r1
fi

#calculates (224 – x)/2
ldi r3, 224
sub r3, r2
shra r2
ldi r0, 0b01111111
and r0, r2

#calculates(224 – x)/2 × vy
ldi r3, 0 #zeroing the r3 to store the sum of the carry bits
if 
	tst r1
is mi

	#multiplication when vy = -4
	ldi r0, -4 
	if 
		cmp r0, r1
	is eq
		if 
			shla r2 #shifts the number to the left by one bit
		is cs	
			inc r3 	#if necessary, saves the carry bit
		fi
		
		if 
			shla r2
		is cs
			inc r3
		fi
	fi
	
	#multiplication when vy = -3
	ldi r0, -3 
	if 
		cmp r0, r1
	is eq
		#calculates (-3)*r2 as -(r2*r2 + r2)
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
	
	#multiplication when vy = -2
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
	
	#negativates result, if vy is negative
	if 
		neg r2
	is cs
		inc r3
	fi
	
else
	
	#multiplication when vy = 3
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
	
	#multiplication when vy = 2
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
	
	#multiplication when vy = 0
	if 
		tst r1
	is z
		ldi r2, 0
	fi    	
fi

pop r0 #pops y coordinate off the stack into r0

#calculates (224 – x)/2 × vy + y with storing carry bit
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

#by the number of carry bits defines how many times the 
#ball has touched the top or the bottom of the display
if
	shra r3 #if this number is odd negativates the result
is cs
	neg r2
fi


ldi r1, IO3 #loads address of IO-3 into r1
st r1, r2 	#stores r2 into IO-3

br 0x00 #makes an endless loop

#for input data
asect 0xf3 

Ports>
IO3: ds 1 #conatins ball's velocity and stores y coordinate of the right bat
IO4: ds 1 #contains x coordinate of the ball
IO5: ds 1 #contains y coordinate of the ball
EndPorts>

end