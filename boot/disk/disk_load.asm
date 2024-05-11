;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; load DH sectors to ES:BX from drive DL
; assumes ES:BX contains the place to read to
; assumes DH is the number of sectors to read
; assumes DL contains the drive to read from
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disk_load:

; store dx on stack so later we can recall how many sectors were
; requested to be read, even if it is altered in the meantime
push dx

mov ah, 0x02		; BIOS read sector function

mov al, dh		; how many sectors to read

mov ch, 0x00		; cyclinder
mov cl, 0x02		; start reading from this sector
mov dh, 0x00		; the head to use
;mov dl, 0x80		; the drive to read from, BIOS puts the boot drive in dl for us though

; bios interrupt
int 0x13

; pop dx now that we are done using it in the dh for the head. we will
; compare to make sure al is the number expected we wanted to read
pop dx

; return to calling function
ret

; should never get here unless an error message is printed
jmp $
