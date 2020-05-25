#NGUYEN THI THU HANG
#18120027
.data:
	fin: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/dethi.txt"
	fout: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/nguoichoi.txt"
	stt0: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/HANGMAN.txt"
	stt1: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/status1.txt"	
	stt2: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/status2.txt"
	stt3: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/status3.txt"
	stt4: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/status4.txt"
	stt5: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/status5.txt"
	stt6: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/status6.txt"
	stt7: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/status7.txt"
	stt8: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/YOU WIN.txt"
	stt9: .asciiz "C:/Users/skyho/Desktop/KTMT&HN/DOAN2/GAME OVER.txt"
	tb1: .asciiz "\nNhap ten nguoi choi: "
	tb2: .asciiz "\nKi tu khong ton tai trong chuoi \n"
	tb3a: .asciiz "\nCo "
	tb3b: .asciiz " ki tu ton tai trong chuoi \n"
	tb4: .asciiz "\nNhap ki tu doan: "
	tb5: .asciiz "Chuoi ki tu hien tai cua ban la: "
	tb6: .asciiz "Ban da nhap sai, vui long chon lai\n"
	tb9: .asciiz "\nNhap chuoi doan: "
	tb10: .asciiz "\nLEVEL: "
	tb11: .asciiz "Past Level\n_________________________________________________________\n"
	tb12: .asciiz "\nTen Nguoi Choi: "
	tb13: .asciiz "Diem: "
	tb14:.asciiz "\nSo luot chien thanh: "
	MENU: .asciiz "\n??? Doan ki tu chon 1, Doan chuoi chon 2 ??? {Exit game chon 3}"
	MENU_OFF:.asciiz "Ban co muon tiep tuc( Chon 1 neu dong y, nguoc lai chon 2 de thoat)"
	chon: .asciiz "\nChon: "
	fmt: .asciiz "-"
	fmt1: .asciiz "*"
	fmt2:.asciiz "\n"
	Top10: .asciiz "TOP 10"
	#int variable
	name.len: .word 0 #do dai ten nguoi choi(su dung de ghi file)
	len: .word 0 #do dai tu duoc chon 
	score: .word 0 #Thanh tich
	turn: .word 0 #diem
	WA: .word 0 #dap an sai
	chap:.word 0 #Lan choi 
	userLen:.word 0 #so phan tu mang user
	
	score_str.len:.word 0#do dai chuoi score_str
	turn_str.len: .word 0#do dai chuoi turn_str
	#array,string:
	name: .space 50 #the palyer name
	score_str: .space 50 #diem nguoi choi kieu chuoi (ghi file/ docfile can)
	turn_str: .space 50 #level nguoi choi kieu chuoi (ghi file/docfile can)
	str: .space 50 #tu duoc chon
	current_str:.space 50 #chuoi hiên tai
	tmp:.space 10000 #chuoi tam docfile
	chuoidoan:.space 50
	dd: .space 1000#mang danh dau so da random chua
	userScore:.word 0:100 #mang so diem cua nguoi dung
	userId:.word 0:100 #mang id cua nguoi dung
	Top10User: .space 100 
	TrangThai:.space 1000
.text
	.globl main
main:
	#initiation stack
	li $sp,0
	jal HANGMAN
	#Exit function
	li $v0,10
	syscall
#============================================== RemoveArray ==============================================
RemoveArr:
#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp) 
	addi $sp,$sp,-4
	sw $s0,($sp) 
	addi $sp,$sp,-4
	sw $s1,($sp) 
	addi $sp,$sp,-4
	sw $t0,($sp) 
	addi $sp,$sp,-4
	sw $t1,($sp) 
#than thu tuc
	move $s0,$a0 #array
	move $s1,$a1 #length
	beq $s1,0,RemoveArr.end
	li $t1,4
	mult $s1,$t1
	mflo $s1
	li $t0,0
RemoveArr.Loop:
	sb $zero,($s0)
	addi $s0,$s0,1
	addi $t0,$t0,1
	bne $t0,$s1, RemoveArr.Loop
RemoveArr.end:
	move $s1,$0
	lw $t1,($sp) 
	addi $sp,$sp,4
	lw $t0,($sp) 
	addi $sp,$sp,4
	lw $s1,($sp) 
	addi $sp,$sp,4
	lw $s0,($sp) 
	addi $sp,$sp,4
	lw $ra,($sp) 
	addi $sp,$sp,4
	jr $ra
#============================================== Define RemoveString ==============================================
RemoveString:
#begin
	addi $sp,$sp,-4
	sw $ra,($sp) #save address of fuction
	addi $sp,$sp,-4
	sw $s0,($sp) #address of string needs removing
	addi $sp,$sp,-4
	sw $t0,($sp) #temp
#content
	move $s0,$a0 #$a0 containt address of string which needs removing
RemoveString.Loop:
	lb $t0,($s0)
	sb $zero,($s0)
	addi $s0,$s0,1
	bne $t0,$zero, RemoveString.Loop
#end
	lw $t0,($sp) #temp
	addi $sp,$sp,4
	lw $s0,($sp) #address of string needs removing
	addi $sp,$sp,4
	lw $ra,($sp) #save address of fuction
	addi $sp,$sp,4
	jr $ra
#============================================ Enter the player name ================================================
EnterName:
#begin
	addi $sp,$sp,-4
	sw $ra,($sp) #save address of fuction
	addi $sp,$sp,-4
	sw $s0,($sp) #temp
	addi $sp,$sp,-4
	sw $t0,($sp) #length			
	addi $sp,$sp,-4
	sw $s1,($sp) #string
#content
	#Export notice
	li $v0,4
	la $a0,tb1
	syscall

	# Enter the player name
	li $v0,8
	la $a0,name
	la $a1,50
	syscall
	la $s1,name
	li $t0,0
EnterName.FindLengthofName:
	lb $s0,($s1)
	beq $s0,'\n',EnterName.end
	addi $t0,$t0,1
	addi $s1,$s1,1
	j EnterName.FindLengthofName
#end
EnterName.end:
	sw $t0,name.len

	lw $s1,($sp)	#string
	addi $sp,$sp,4
	lw $t0,($sp)	#length
	addi $sp,$sp,4
	lw $s0,($sp)	#temp
	addi $sp,$sp,4
	lw $ra,($sp)	#save address of fuction
	addi $sp,$sp,4
	jr $ra
#================================== RandomQuestion function =================================================
RandomQuestion:
#begin
	addi $sp,$sp,-4
	sw $ra,($sp)	#save address of fuction
	addi $sp,$sp,-4
	sw $s0,($sp) 	#address of dethi.txt
	addi $sp,$sp,-4
	sw $s1,($sp) 	# dd array
	addi $sp,$sp,-4
	sw $s2,($sp)   # string temp
	addi $sp,$sp,-4
	sw $s3,($sp)   #save id of word
	addi $sp,$sp,-4
	sw $t0,($sp)   #count
	addi $sp,$sp,-4
	sw $s4,($sp)  #variable temp
	addi $sp,$sp,-4
	sw $s5,($sp)  #string str USE for Game
	addi $sp,$sp,-4
	sw $t1,($sp)  #len
	addi $sp,$sp,-4
	sw $t2,($sp)  #chapter ~ chap
	#toi day em su dung tieng viet code cho nhanh :(
#content
	lw $t2,chap
	la $a0,str
	jal RemoveString
#random
RandomQuestion.Random:
	li $a1,5 
	li $v0,42
	syscall
	move $s3,$a0
	la $s1,dd
	li $s4,0
RandomQuestion.Check_DD:
	beq $t2,0,RandomQuestion.TiepTuc
	lw $s2,($s1)
	beq $s2,$s3,RandomQuestion.Random
	addi $s1,$s1,4
	addi $s4,$s4,1
	blt $s4,$t2,RandomQuestion.Check_DD
	j RandomQuestion.TiepTuc
RandomQuestion.TiepTuc:
	sw $s3,($s1)
	addi $t2,$t2,1
	
	#openfile
	li $v0,13
	la $a0,fin
	li $a1,0
	li $a2,0
	syscall
	#luu dia chi fin vao $s0
	move $s0,$v0
	#docfile ~ Luu nhung gi doc duoc vao chuoi tmp
	li $v0,14
	move $a0,$s0
	la $a1,tmp
	li $a2,10000
	syscall

	#close file
	li $v0,16
	move $a0,$s0
	syscall
	
	#Tim ra str tu chuoi tmp
	li $t0,0
	li $t1,0
	la $s5,str
	la $s0,tmp
RandomQuestion.Tim_str:
	lb $s4,($s0)
	beq $s4,$0,RandomQuestion.end
	beq $s4,'*',RandomQuestion.Tang_t0
	sb $s4,($s5)
	addi $t1,$t1,1
	addi $s5,$s5,1
RandomQuestion.TiepTucTim:
	addi $s0,$s0,1
	j RandomQuestion.Tim_str
RandomQuestion.Tang_t0:
	beq $t0,$s3,RandomQuestion.end
	addi $t0,$t0,1
	la $s5,str
	li $t1,0
	j RandomQuestion.TiepTucTim

	#cuoi thu tuc
RandomQuestion.end:
	sw $t2,chap
	sw $t1,len

	la $a0,tmp
	jal RemoveString

	lw $t2,($sp) #chap
	addi $sp,$sp,4
	lw $t1,($sp) #len
	addi $sp,$sp,4
	lw $s5,($sp) #str
	addi $sp,$sp,4
	lw $s4,($sp) #tmp
	addi $sp,$sp,4
	lw $t0,($sp) #bien dem lay chuoi
	addi $sp,$sp,4
	lw $s3,($sp) #luu thu tu de hop le
	addi $sp,$sp,4
	lw $s2,($sp) #tmp
	addi $sp,$sp,4
	lw $s1,($sp) # mang dd
	addi $sp,$sp,4
	lw $s0,($sp) # luu dia chi fin
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra	
#==========================================Ham doan ki tu=================================================
DoanKiTu:
	#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp)#str
	addi $sp,$sp,-4
	sw $s1,($sp)#ki tu doan
	addi $sp,$sp,-4
	sw $s2,($sp)#current_str
	addi $sp,$sp,-4
	sw $t0,($sp)#bien i
	addi $sp,$sp,-4
	sw $t1,($sp)#len
	addi $sp,$sp,-4
	sw $t3,($sp)#bien tmp
	addi $sp,$sp,-4
	sw $s3,($sp)#dem
	addi $sp,$sp,-4
	sw $s4,($sp)#WA
	addi $sp,$sp,-4
	sw $t2,($sp)#score
	#xuat thong bao
	li $v0,4
	la $a0,tb4
	syscall
	
	#Nhap ki tu can doan
	li $v0,12
	syscall
	move $s1,$v0

	#than thu tuc
	la $s0,str
	lw $s4,WA
	la $s2,current_str
	#khoi tao vong lap
	li $t0,0
	lw $t1,len
	li $s3,0
DoanKiTu.Duyet_str:
	lb $t3,($s0)
	beq $t3,$s1,DoanKiTu.TangDem
DoanKiTu.TiepTuc:
	addi $s2,$s2,1
	addi $s0,$s0,1
	addi $t0,$t0,1
	blt $t0,$t1,DoanKiTu.Duyet_str
	j DoanKiTu.TraKQ
	
DoanKiTu.TangDem:
	addi $s3,$s3,1
	sb $s1,($s2)
	j DoanKiTu.TiepTuc
	
DoanKiTu.TraKQ:
	#xet $s3 = 0, wrong 1, nguoc lai qua xuat
	lw $t2,score
	add $t2,$t2,$s3
	beq $s3,$0,DoanKiTu.Tang_Sai
	
	#xuat tb3a tb3b
	li $v0,4
	la $a0,tb3a
	syscall
	
	li $v0,1
	move $a0,$s3
	syscall
	
	li $v0,4
	la $a0,tb3b
	syscall

	j DoanKiTu.end
DoanKiTu.Tang_Sai:
	addi $s4,$s4,1
	li $v0,4
	la $a0,tb2
	syscall
	move $a0,$s4
	jal XuatTrangThai
DoanKiTu.end:
	#Xuat chuoi hien tai
	li $v0,4
	la $a0,tb5
	syscall  
	la $s2,current_str #lay lai dia chi current_str
	li $v0,4
	move $a0,$s2
	syscall
	li $v0,11
	la $a0,10
	syscall
	#cuoi thu tuc
	sw $s4,WA
	sw $t2,score
	lw $t2,($sp)#score
	addi $sp,$sp,4
	lw $s4,($sp)#WA
	addi $sp,$sp,4
	lw $s3,($sp)#dem
	addi $sp,$sp,4
	lw $t3,($sp)#bien tmp
	addi $sp,$sp,4
	lw $t1,($sp)#len
	addi $sp,$sp,4
	lw $t0,($sp)#bien i
	addi $sp,$sp,4
	lw $s2,($sp)#chuoi tmp
	addi $sp,$sp,4
	lw $s1,($sp)#ki tu doan
	addi $sp,$sp,4
	lw $s0,($sp)#str
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra	
#========================================Khoi tao================================================
KhoiTaoCurrent_str:
	#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp)
	addi $sp,$sp,-4
	sw $s1,($sp)
	addi $sp,$sp,-4
	sw $t0,($sp)
	addi $sp,$sp,-4
	sw $t1,($sp)
	
	#Khoi tao
	li $t0,0
	#Khoi tao current
	la $s1,current_str
	lw $t1,len
	
Loop:
	la $s0,'-'
	sb $s0,($s1)
	addi $t0,$t0,1
	addi $s1,$s1,1
	blt $t0,$t1,Loop
	
	#cuoi thu tuc

	lw $t1,($sp)
	addi $sp,$sp,4
	lw $t0,($sp)
	addi $sp,$sp,4
	lw $s1,($sp)
	addi $sp,$sp,4
	lw $s0,($sp)
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra

#=====================================Doan cau=============================================
DoanCau:
	#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp) #chuoi tam
	addi $sp,$sp,-4
	sw $s1,($sp) # chuoi str
	addi $sp,$sp,-4
	sw $s2,($sp) #phan tu chuoi tam
	addi $sp,$sp,-4
	sw $s3,($sp) #phan tu chuoi str
	addi $sp,$sp,-4
	sw $t0,($sp) # bien i
	addi $sp,$sp,-4 
	sw $t1,($sp) #len

	#Xuat thong bao
	li $v0,4
	la $a0,tb9
	syscall
	#Nhap chuoi doan
	li $v0,8
	la $a0,chuoidoan
	la $a1,50
	syscall

	la $s0,chuoidoan #$s0 chua dia chi chuoidoan
	la $s1,str # $s1 chua dia chi chuoi str
	#Khoi tao vong lap
	li $t0,1
	lw $t1,len
DoanCau.Duyet_str:
	lb $s2,($s0)
	lb $s3,($s1)
	bne $s2,$s3,DoanCau.Sai
	beq $s2,'\n',DoanCau.end
	beq $s3,'\n',DoanCau.end
	addi $s0,$s0,1
	addi $s1,$s1,1
	addi $t0,$t0,1
	beq $t0,$t1,DoanCau.Dung
	j DoanCau.Duyet_str

DoanCau.Sai:
	li $t0,7
	sw $t0,WA
	li $a0,7
	jal XuatTrangThai
	j DoanCau.end

DoanCau.Dung:
	sw $t1,score
	j DoanCau.end
DoanCau.end:
	#ket thuc thu tuc
	lw $t1,($sp)
	addi $sp,$sp,4
	lw $t0,($sp)
	addi $sp,$sp,4
	lw $s3,($sp)
	addi $sp,$sp,4
	lw $s2,($sp)
	addi $sp,$sp,4
	lw $s1,($sp)
	addi $sp,$sp,4
	lw $s0,($sp)
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
#=====================================Chuyen Int sang String======================================
ChuyenSangChuoi:
	#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp) #score
	addi $sp,$sp,-4
	sw $s1,($sp) #chua dia chi chuoi chua so nguyen
	addi $sp,$sp,-4
	sw $s2,($sp) #chua dia chi luu do dai chuoi da chuyen
	addi $sp,$sp,-4 
	sw $t0,($sp) # luu 10 vao thanh ghi $t0
	addi $sp,$sp,-4
	sw $t1,($sp) # $s0 mod 10=$t1
	addi $sp,$sp,-4
	sw $t2,($sp) #bien tam dem do dai chuoi
	#than thuc tuc
	move $s0,$a0 #chuyen gia tri vao $s0
	move $s1,$a1 #chuyen dia chi cuar _str vao $s1
	move $s2,$a2 #chuyen dia chuyen cua _str.len vao $s2
	beq $s0,0,ChuyenSangChuoi.zero #khong can xu li am vi khong tru diem, neu la 0 thi .zero
	li $t0,10  #khoi tao $t0=10
	li $t2,0   #khoi tao $t2=0
ChuyenSangChuoi.Push:
	div $s0,$t0
	mflo $s0 #nguyen
	mfhi $t1 #du
	addi $sp,$sp,-1
	addi $t1,$t1,48 #chuyen qua ki tu phai cong 48='0'
	sb $t1,($sp) #luu vao stack
	addi $t2,$t2,1 #dem do dai chuoi
	bne $s0,0,ChuyenSangChuoi.Push #neu $s0>0 lap tiep
	sw $t2,($s2) #luu gia tri dem vao _str.len
ChuyenSangChuoi.Pop:
	lb $t1,($sp) #lay tu stack ki tu
	addi $sp,$sp,1 
	sb $t1,($s1) #luu vao chuoi _str
	addi $s1,$s1,1 
	addi $t2,$t2,-1
	bne $t2,0,ChuyenSangChuoi.Pop
	j ChuyenSangChuoi.end
ChuyenSangChuoi.zero:
	li $t0,'0'
	sb $t0,($s1)
	li $t2,1
	sw $t2,($s2)
	j ChuyenSangChuoi.end
	#cuoi thu tuc
ChuyenSangChuoi.end:
	lw $t2,($sp)
	addi $sp,$sp,4
	lw $t1,($sp)
	addi $sp,$sp,4
	lw $t0,($sp)
	addi $sp,$sp,4
	lw $s2,($sp)
	addi $sp,$sp,4
	lw $s1,($sp)
	addi $sp,$sp,4
	lw $s0,($sp)
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
#=========================================GhiFile=================================================
Ghifile:
	#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp)
	addi $sp,$sp,-4
	sw $s1,($sp)
	addi $sp,$sp,-4
	sw $s2,($sp)
	#openfie
	li $v0,13
	la $a0,fout
	li $a1,9
	li $a2,0
	syscall
	move $s0,$v0

	#ghi ten nguoi choi vao file
	li $v0,15
	move $a0,$s0
	la $a1,name
	lw $a2,name.len
	syscall

	#ghi them '-'
	li $v0,15
	move $a0,$s0
	la $a1,fmt
	la $a2,1
	syscall

	#ghi so diem vao file
	lw $a0,score
	la $a1,score_str
	la $a2,score_str.len
	jal ChuyenSangChuoi #thuc hien chuyen doi Int sang String
	li $v0,15# ghi vao file
	move $a0,$s0
	la $a1,score_str
	lw $a2,score_str.len
	syscall

	#ghi them '-'
	li $v0,15
	move $a0,$s0
	la $a1,fmt
	la $a2,1
	syscall

	#ghi so ban thang vao file
	lw $a0,turn
	la $a1,turn_str
	la $a2,turn_str.len
	jal ChuyenSangChuoi #thuc hien chuyen Int sang String
	li $v0,15 #thuc hien ghi vao file
	move $a0,$s0
	la $a1,turn_str
	lw $a2,turn_str.len
	syscall

	#ghi them '*'
	li $v0,15
	move $a0,$s0
	la $a1,fmt1
	la $a2,1
	syscall
	
	#close file
	li $v0,16
	move $a0,$s0
	syscall
	#cuoi thu tuc
	lw $s2,($sp)
	addi $sp,$sp,4
	lw $s1,($sp)
	addi $sp,$sp,4
	lw $s0,($sp)
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
#=====================================Docfile===========================================
Docfile:
	#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp)    #dia chi tap tin can doc fout
	addi $sp,$sp,-4
	sw $s1,($sp)    # dia chi chuoi tmp doc toan file
	addi $sp,$sp,-4
	sw $s2,($sp)	#dia chi mang user.score
	addi $sp,$sp,-4
	sw $s3,($sp)	#dia chi mang user.id
	addi $sp,$sp,-4
	sw $t0,($sp)	#bien tmp, co nghi khi $t0=1 doc duoc chuoi score cho den khi gap '-'
	addi $sp,$sp,-4
	sw $t1,($sp)     #bien tmp, doc tmp[i]
	addi $sp,$sp,-4
	sw $t2,($sp)	#so 10
	addi $sp,$sp,-4
	sw $t3,($sp)    # bien int cuar score
	addi $sp,$sp,-4
	sw $t4,($sp)	#bien int cuar id

	#open file
	li $v0,13
	la $a0,fout
	li $a1,0
	li $a2,0
	syscall
	move $s0,$v0 # $s0 luu dia chi fout

	#docfile
	li $v0,14
	move $a0,$s0
	la $a1,tmp
	li $a2,10000
	syscall
	
	#close file
	li $v0,16
	move $a0,$s0
	syscall

#xu li loc du lieu
	la $s1,tmp
	la $s2,userScore
	la $s3,userId
	li $t0,0
	li $t2,10
	li $t3,0
	li $t4,0
Docfile.LocDuLieu:
	lb $t1,($s1)
	beq $t1,$zero,Docfile.end
	beq $t1,'*',Docfile.KhoiTao
	beq $t1,'-',Docfile.Tang_t0
	beq $t0,1,Docfile.User_Score
Docfile.TiepTuc:
	addi $s1,$s1,1
	j Docfile.LocDuLieu
Docfile.Tang_t0:
	addi $t0,$t0,1
	j Docfile.TiepTuc
Docfile.KhoiTao:
	addi $t4,$t4,1
	sw $t4,($s3)
	addi $s3,$s3,4
	sw $t3,($s2)
	addi $s2,$s2,4
	li $t0,0
	li $t3,0
	j Docfile.TiepTuc
Docfile.User_Score:
	addi $t1,$t1,-48
	mult $t3,$t2
	mflo $t3
	add $t3,$t3,$t1
	j Docfile.TiepTuc
Docfile.end:
	sw $t4,userLen
	la $a0,tmp
	jal RemoveString
	lw $t4,($sp)	#bien int cuar id
	addi $sp,$sp,4
	lw $t3,($sp)    # bien int cuar score
	addi $sp,$sp,4
	lw $t2,($sp)	#so 10
	addi $sp,$sp,4
	lw $t1,($sp)     #bien tmp, doc tmp[i]
	addi $sp,$sp,4
	lw $t0,($sp)	#bien tmp, co nghi khi $t0=1 doc duoc chuoi score cho den khi gap '-'
	addi $sp,$sp,4
	lw $s3,($sp)	#dia chi mang user.id
	addi $sp,$sp,4
	lw $s2,($sp)	#dia chi mang user.score
	addi $sp,$sp,4
	lw $s1,($sp)    # dia chi chuoi tmp doc toan file
	addi $sp,$sp,4
	lw $s0,($sp)    #dia chi tap tin can doc fout
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
#==================================================InsertionSort====================================================
_SapXep:
#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp) #user.len
	addi $sp,$sp,-4
	sw $s1,($sp) # user.score	
	addi $sp,$sp,-4
	sw $s2,($sp)#	user.score.tam
	addi $sp,$sp,-4
	sw $s3,($sp)# user.score[i]
	addi $sp,$sp,-4
	sw $s4,($sp)# user.score[j]
	addi $sp,$sp,-4
	sw $s5,($sp)# tmp
	addi $sp,$sp,-4
	sw $s6,($sp)#user.id
	addi $sp,$sp,-4
	sw $s7,($sp)#user.id tam
	addi $sp,$sp,-4
	sw $t0,($sp)# i
	addi $sp,$sp,-4
	sw $t1,($sp)# j
	addi $sp,$sp,-4
	sw $t2,($sp)#user.len-1
	addi $sp,$sp,-4
	sw $t3,($sp)# user.id[i]
	addi $sp,$sp,-4
	sw $t4,($sp)#user.id[j]
#than thu tuc
	#for (int i=0;i<n-1;i++)
		#for (int j=i+1;j<n;j++)
			#if (a[i]<a[j])
				#Swap(a[i],a[j])
	#Khoi tao vong lap
	lw $s0,userLen
	la $s1,userScore
	la $s6,userId
	li $t0,0
	addi $t2,$s0,-1
_SapXep.Lap:
	lw $s3,($s1)
	lw $t3,($s6)
	la $s2,($s1)
	la $s7,($s6)
	move $t1,$t0
_SapXep.Loop:
	addi $s2,$s2,4
	addi $s7,$s7,4
	addi $t1,$t1,1
	lw $s4,($s2)
	lw $t4,($s7)
	blt $s3,$s4,_SapXep.Swap
	j Tiep
_SapXep.Swap:
	move $s5,$s3
	move $s3,$s4
	move $s4,$s5
	sw $s3,($s1)
	sw $s4,($s2)
	move $s5,$t3
	move $t3,$t4
	move $t4,$s5
	sw $t3,($s6)
	sw $t4,($s7)
	j Tiep
Tiep:
	blt $t1,$t2,_SapXep.Loop
	#Gan tu gia tri i+1->n-1 tu $s2 vao $s1
	la $s2,($s1)
	la $s7,($s6)
	move $t1,$t0
Loop2:
	addi $s2,$s2,4
	addi $s1,$s1,4
	addi $s6,$s6,4
	addi $s7,$s7,4
	addi $t1,$t1,1
	lw $s4,($s2)
	sw $s4,($s1)
	lw $t4,($s7)
	sw $t4,($s6)
	blt $t1,$t2,Loop2
	#Tra $s1 lai vi tri dang duyet
	
Loop3:
	addi $s1,$s1,-4
	addi $s6,$s6,-4
	addi $t1,$t1,-1
	blt $t0,$t1,Loop3

	#tang gia tri duyet tiep
	addi $s1,$s1,4
	addi $s6,$s6,4
	addi $t0,$t0,1
	blt $t0,$t2,_SapXep.Lap
	j end
end:
	lw $t4,($sp)#user.id[j]
	addi $sp,$sp,4
	lw $t3,($sp)# user.id[i]
	addi $sp,$sp,4
	lw $t2,($sp)#user.len-1
	addi $sp,$sp,4
	lw $t1,($sp)# j
	addi $sp,$sp,4
	lw $t0,($sp)# i
	addi $sp,$sp,4
	lw $s7,($sp)#user.id tam
	addi $sp,$sp,4
	lw $s6,($sp)#user.id
	addi $sp,$sp,4
	lw $s5,($sp)# tmp
	addi $sp,$sp,4
	lw $s4,($sp)# user.score[j]
	addi $sp,$sp,4
	lw $s3,($sp)# user.score[i]
	addi $sp,$sp,4
	lw $s2,($sp)#	user.score.tam
	addi $sp,$sp,4
	lw $s1,($sp) # user.score	
	addi $sp,$sp,4
	lw $s0,($sp) #user.len
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
#==============================================Xuat Danh Sach======================================
XuatDanhSach:
	#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp)	#dia chi fout
	addi $sp,$sp,-4
	sw $s1,($sp)	#chuoi tmp1
	addi $sp,$sp,-4
	sw $s2,($sp)	#mang userId
	addi $sp,$sp,-4
	sw $s3,($sp)	#mang userId
	addi $sp,$sp,-4
	sw $t0,($sp)	#bien dem '*'
	addi $sp,$sp,-4
	sw $t1,($sp)	#userLen
	addi $sp,$sp,-4
	sw $t2,($sp)	#bien tam
	addi $sp,$sp,-4
	sw $t3,($sp)	#bien tam
	addi $sp,$sp,-4
	sw $t4,($sp)
	#open file
	li $v0,13
	la $a0,fout
	la $a1,0
	la $a2,0
	syscall
	move $s0,$v0
	#docfile
	li $v0,14
	move $a0,$s0
	la $a1,tmp
	la $a2,10000
	syscall
	#closefile
	li $v0,16
	move $a0,$s0
	syscall

	#khoi tao truy xuat tu chuoi tmp1
	li $t0,1 #dem '*'
	li $t4,0 #dem so lan xuat
	lw $t1,userLen
	la $s3,userId
XuatDanhSach.TruyXuat:
	beq $t4,10,XuatDanhSach.end
	beq $t4,$t1,XuatDanhSach.end
	addi $t4,$t4,1
	lw $t2,($s3) #lay ID
	la $s1,tmp
	addi $s3,$s3,4
	li $t0,1
	li $t5,0
	la $s2,Top10User
XuatDanhSach.Duyet_str:
	beq $t0,$t2,XuatDanhSach.LayChuoi
XuatDanhSach.TiepTuc:
	lb $t3,($s1)
	beq $t3,$zero,XuatDanhSach.TruyXuat
	addi $s1,$s1,1
	beq $t3,'*',XuatDanhSach_Tangt0
	j XuatDanhSach.TiepTuc
XuatDanhSach_Tangt0:
	addi $t0,$t0,1
	j XuatDanhSach.Duyet_str
XuatDanhSach.InThongTin: #in thong tin cuar user Id[i]
	li $t3,'\n'
	sb $t3,($s2)
	
	li $v0,4
	la $a0,Top10User
	syscall
	
	la $a0,Top10User
	jal RemoveString

	la $s2,Top10User
	j XuatDanhSach.TruyXuat
XuatDanhSach.LayChuoi:
	lb $t3,($s1)
	beq $t3,$zero,XuatDanhSach.end
	beq $t3,'*',XuatDanhSach.InThongTin
	sb $t3,($s2)
	addi $s2,$s2,1
	addi $s1,$s1,1
	addi $t5,$t5,1
	j XuatDanhSach.LayChuoi
XuatDanhSach.end:
	#cuoi thu tuc
	la $a0,tmp
	jal RemoveString
	lw $t4,($sp)
	addi $sp,$sp,4
	lw $t3,($sp)     
	addi $sp,$sp,4
	lw $t2,($sp)     
	addi $sp,$sp,4
	lw $t1,($sp)     
	addi $sp,$sp,4
	lw $t0,($sp)	
	addi $sp,$sp,4
	lw $s3,($sp)	
	addi $sp,$sp,4
	lw $s2,($sp)	
	addi $sp,$sp,4
	lw $s1,($sp)    
	addi $sp,$sp,4
	lw $s0,($sp)    
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
#=============================================Xuat Trang Thai===============================================
XuatTrangThai:
	#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp)
	addi $sp,$sp,-4
	sw $s1,($sp)

	#than thu tuc
	move $s0,$a0

	beq $s0,0,XuatTrangThai.HANGMAN
	beq $s0,1,XuatTrangThai.stt1
	beq $s0,2,XuatTrangThai.stt2
	beq $s0,3,XuatTrangThai.stt3
	beq $s0,4,XuatTrangThai.stt4
	beq $s0,5,XuatTrangThai.stt5
	beq $s0,6,XuatTrangThai.stt6
	beq $s0,7,XuatTrangThai.stt7
	beq $s0,8,XuatTrangThai.YOUWIN
	beq $s0,9,XuatTrangThai.GAMEOVER
	j XuatTrangThai.end
XuatTrangThai.HANGMAN:
	#mo file
	li $v0,13
	la $a0,stt0
	li $a1,0
	li $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	li $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end
XuatTrangThai.stt1:
	#mo file
	li $v0,13
	la $a0,stt1
	la $a1,0
	la $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	la $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end
XuatTrangThai.stt2:
	#mo file
	li $v0,13
	la $a0,stt2
	la $a1,0
	la $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	la $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end
XuatTrangThai.stt3:
	#mo file
	li $v0,13
	la $a0,stt3
	la $a1,0
	la $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	la $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end	
XuatTrangThai.stt4:
	#mo file
	li $v0,13
	la $a0,stt4
	la $a1,0
	la $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	la $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end
XuatTrangThai.stt5:
	#mo file
	li $v0,13
	la $a0,stt5
	la $a1,0
	la $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	la $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end	
XuatTrangThai.stt6:
	#mo file
	li $v0,13
	la $a0,stt6
	la $a1,0
	la $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	la $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end
XuatTrangThai.stt7:
	#mo file
	li $v0,13
	la $a0,stt7
	la $a1,0
	la $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	la $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end
XuatTrangThai.YOUWIN:
	#mo file
	li $v0,13
	la $a0,stt8
	la $a1,0
	la $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	la $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end
XuatTrangThai.GAMEOVER:
	#mo file
	li $v0,13
	la $a0,stt9
	la $a1,0
	la $a2,0
	syscall
	move $s1,$v0
	#docfile
	li $v0,14
	move $a0,$s1
	la $a1,TrangThai
	la $a2,1000
	syscall
	#in trang thai
	li $v0,4
	la $a0,TrangThai
	syscall
	li $v0,11
	la $a0,10
	syscall
	li $v0,16
	move $a0,$s1
	syscall
	j XuatTrangThai.end
XuatTrangThai.end:
	la $a0,TrangThai
	jal RemoveString
	
	lw $s1,($sp)	
	addi $sp,$sp,4
	lw $s0,($sp)
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
#==============================================Tro choi=================================================
TroChoi:
	#dau thu tuc
	addi $sp,$sp,-4
	sw $ra,($sp)
TroChoi.ChoiTiep:
	addi $sp,$sp,-4
	sw $s0,($sp)#Bien chon
	addi $sp,$sp,-4
	sw $t0,($sp)
	addi $sp,$sp,-4
	sw $s1,($sp)
	addi $sp,$sp,-4
	sw $s2,($sp)
	addi $sp,$sp,-4
	sw $t1,($sp)
	addi $sp,$sp,-4
	sw $t2,($sp)
	#than thu tuc
	#khoi tao current_str rong
	la $a0,current_str
	jal RemoveString
	#khoi tao str rong
	la $a0,str
	jal RemoveString

	lw $t2,score #Luu lai score cu
	lw $t1,turn # Luu gia tri turn cu
	#in ra level
	li $v0,4
	la $a0,tb10
	syscall
	li $v0,1
	move $a0,$t1
	syscall
	li $v0,11
	la $a0,10
	syscall

	#Khoi tao WA, score
	
	sw $0,WA
	sw $0,score
	#Goi ham Docfile  
	jal RandomQuestion#randomQuestion
	
	#Khoi tao Current_str va in ra chuoi ban dau
	li $v0,4
	la $a0,tb5
	syscall

	jal KhoiTaoCurrent_str #Khoi tao current_str
	
	li $v0,4
	la $a0,current_str
	syscall
TroChoi.Menu:
	#in menu
	li $v0,4
	la $a0,MENU
	syscall
	li $v0,4
	la $a0,chon
	syscall
	#Nhap Bien chon
	li $v0,5
	syscall
	move $s0,$v0
	
	beq $s0,1,TroChoi.DoanKiTu
	beq $s0,2,TroChoi.DoanCau
	beq $s0,3,TroChoi.Exit
	j TroChoi.NhapSai
TroChoi.TiepTuc:
	lw $s1,score
	lw $s2,len
	lw $t0,WA
	beq $t0,7,TroChoi.Thua
	beq $s1,$s2,TroChoi.QuaCua
	j TroChoi.Menu
TroChoi.DoanKiTu:
	jal DoanKiTu
	j TroChoi.TiepTuc
TroChoi.DoanCau:
	jal DoanCau
	j TroChoi.TiepTuc
TroChoi.NhapSai:
	j TroChoi.Menu
TroChoi.QuaCua:
	li $v0,4
	la $a0,tb11
	syscall
	add $t2,$t2,$s1
	sw $t2,score
	addi $t1,$t1,1
	sw $t1,turn
	beq $t1,5,TroChoi.Thang
	#Khoi phuc stack
	lw $t2,($sp)
	addi $sp,$sp,4
	lw $t1,($sp)
	addi $sp,$sp,4
	lw $s2,($sp)
	addi $sp,$sp,4
	lw $s1,($sp)
	addi $sp,$sp,4
	lw $t0,($sp)
	addi $sp,$sp,4
	lw $s0,($sp)
	addi $sp,$sp,4
	j TroChoi.ChoiTiep
TroChoi.Thang:
	li $a0,8
	jal XuatTrangThai
	
	li $v0,4
	la $a0,Top10
	syscall
	li $v0,11
	la $a0,10
	syscall

	jal Docfile
	jal _SapXep
	jal XuatDanhSach
	j TroChoi.end
TroChoi.Thua:
	li $a0,9
	jal XuatTrangThai

	lw $t1,turn
	add $t2,$t2,$s1
	#xuat ten nguoi choi
	li $v0,4
	la $a0,tb12
	syscall
	li $v0,4
	la $a0,name
	syscall
	#xuat diem nguoi choi
	li $v0,4
	la $a0,tb13
	syscall
	li $v0,1
	move $a0,$t2
	syscall
	#xuat luot thang
	li $v0,4
	la $a0,tb14
	syscall
	li $v0,1
	move $a0,$t1
	syscall
	li $v0,11
	la $a0,10
	syscall

	sw $t1,turn
	sw $t2,score
	jal Ghifile

	li $v0,4
	la $a0,Top10
	syscall
	li $v0,11
	la $a0,10
	syscall

	jal Docfile
	jal _SapXep
	jal XuatDanhSach
	j TroChoi.end
TroChoi.Exit:
	li $v0,10
	syscall
TroChoi.end:
	#cuoi thu tuc
	lw $t2,($sp)
	addi $sp,$sp,4
	lw $t1,($sp)
	addi $sp,$sp,4
	lw $s2,($sp)
	addi $sp,$sp,4
	lw $s1,($sp)
	addi $sp,$sp,4
	lw $t0,($sp)
	addi $sp,$sp,4
	lw $s0,($sp)
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
#=============================HANGMAN.exe====================================
HANGMAN:
#dau game
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $sp,$sp,-4
	sw $s0,($sp)
#than game
	li $a0,0
        jal XuatTrangThai
	#buoc 1: Nhap ten nguoi choi
	jal EnterName
	#buoc 2: Choi Tro choi
ChoiLai:
	#khoi tao tat ca cac bien	
	sw $0,score
	sw $0,score_str.len
	la $a0,score_str
	jal RemoveString
	
	sw $0,turn
	sw $0,turn_str.len
	la $a0,turn_str
	jal RemoveString
	# Tra lai gia tri ban dau cho mang dd va bien chap
	la $a0,dd
	lw $a1,chap
	jal RemoveArr
	sw $0,chap
	jal TroChoi
	#buoc 3: Hoi y kien muon choi lai khong
		#1.Co
		#2.Khong
	
	#xuat thong bao MENU_OFF:"Ban co muon tiep tuc( Chon 1 neu dong y, nguoc lai chon 2 de thoat)"
	li $v0,4
	la $a0,MENU_OFF
	syscall
	#xuat "\nChon: "
	li $v0,4
	la $a0,chon
	syscall
	#nhap chon
	li $v0,5
	syscall
	move $s0,$v0 #$s0 luu bien chon
	beq $s0,1,ChoiLai
	beq $s0,2,Exit
	j HANGMAN.end
Exit:
	li $v0,10
	syscall
HANGMAN.end:
	lw $s0,($sp)	
	addi $sp,$sp,4
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
