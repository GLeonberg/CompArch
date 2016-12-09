# PTX
# Gregory Leonberg

# assume base of array in r0

	add.s32 r0, 0, 6 # length in r0
	add.s32 r7, r0, -1 # len-1 for bubbleSort
	add.s32 r11, 0, 0
	add.s32 r2, 0, 0

	outBubble:

		cmp.eq.s32 r12, r11, r7
		@r12 bra endSort
		add.s32 r8, 0, 0
		add.s32 r2, 0, 0
		inBubble:
			cmp.eq.s32 r9, r8, r7
			@r9 bra endOut
			# pointers to values from arrays to check
			add.s32 r5, r0, r2
			add.s32 r6, r0, r2
			add.s32 r6, r6, 4
			# if arr[i] < arr[i+1], swap
			ld.global.b32  r3, [r5 + 0]
			ld.global.b32  r4, [r6 + 0]
			cmp.gt.s32 r10, r3, r4
			@r10 bra swapVals
			bra endIn
			swapVals :
				st.global.b32 r4, [r5 + 0] 
				st.global.b32 r3, [r6 + 0]
			endIn:
				add.s32 r8, r8, 1
				mul.s32 r2, r8, 4
				bra inBubble
	endOut:
		add.s32 r11, r11, 1
		bra outBubble
	endSort:
