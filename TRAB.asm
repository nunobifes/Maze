 ;|------------------------------------------------------------|
;| TRABALHO PRATICO TECNOLOGIAS E ARQUITETURA DE COMPUTADORES |
;|                                                            |
;|                             2016/2017                      |
;|                                                            |
;| Nuno Rocha - 21240505                                      |
;| Vanessa Rodrigues - 21260322                               |
;|------------------------------------------------------------|
.8086
.model	small
.stack	2048

dseg   	segment para public 'data'

menuJogar db '###############################################################################',13,10
          db '#                                                                             #',13,10
          db '#                                                                             #',13,10
          db '#             _____  _   _  _____   __   __   ___   ______ _____              #',13,10
          db '#            (_   _)| | | ||  ___) |  \ /  | / _ \ (___  /|  ___)             #',13,10
          db '#              | |  | |_| || |_    |   v   || |_| |   / / | |_                #',13,10
          db '#              | |  |  _  ||  _)   | |\_/| ||  _  |  / /  |  _)               #',13,10
          db '#              | |  | | | || |___  | |   | || | | | / /__ | |___              #',13,10
          db '#              |_|  |_| |_||_____) |_|   |_||_| |_|/_____)|_____)             #',13,10
          db '#                                                                             #',13,10
          db '#                                                                             #',13,10
          db '#                                                                             #',13,10
          db '# Nuno Rocha - 21240505                          Vanessa Rodrigues - 21260322 #',13,10
          db '###############################################################################',13,10
          db '#                                                                             #',13,10
          db '#                                                                             #',13,10
          db '#                                                                             #',13,10
          db '#                               1 - Jogar Normal                              #',13,10
          db '#                               2 - Jogar Bonus                               #',13,10
          db '#                               3 - Voltar                                    #',13,10
          db '#                                                                             #',13,10
          db '#                                                                             #',13,10
          db '#                                                                             #',13,10
          db '###############################################################################',13,10,'$'


			    ;Imprimir ficheiro
			    Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
			    Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
			Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
			maze         	  db      'fich/maze.txt',0
      mazeB         	db      'fich/mazeB.txt',0
      menu1_txt       db      'fich/menu.txt',0
      menu_conf       db      'fich/menuconf.txt',0
      ganhou_txt      db      'fich/ganhou.txt',0
      perdeu_txt      db      'fich/perdeu.txt',0
      top10_txt       db      'fich/top10.txt',0
			HandleFich      dw      0
			car_fich        db      ?

; avatar

Car		db	32	; Guarda um caracter do Ecran
Cor		db	7	; Guarda os atributos de cor do caracter
POSy		db	3	; a linha pode ir de [1 .. 25]
POSx		db	9	; POSx pode ir [1..80]
POSya		db	3	; Posi��o anterior de y
POSxa		db	9	; Posi��o anterior de x
POSyn   db	3	; Posiçao de teste para fazer verificações
POSxn		db	9	; Posiçao de teste para fazer verificações
POSyO   db  3 ; Posiçao original
POSxO   db  9
Carn		db	32
corn    db  7 ; asdadw

  ; cria maze

      CPOSy   db  5
      CPOSx   db  10
      CCar    db  32

      ; buffer

      buff        db  51        ;MAX NUMBER OF CHARACTERS ALLOWED (50).
                  db  ?         ;NUMBER OF CHARACTERS ENTERED BY USER.
                  db  51 dup(0) ;CHARACTERS ENTERED BY USER.

                  ganhouVar db 0
                  perdeuVar db 0


                  delaytime db 5



dseg    	ends

cseg		segment para public 'code'
		assume  cs:cseg, ds:dseg

    ;########################################################################
    goto_xy	macro		POSx,POSy
        mov		ah,02h
        mov		bh,0		; numero da pagina
        mov		dl,POSx
        mov		dh,POSy
        int		10h
    endm

    ;########################################################################
main		proc
		mov     ax, dseg
		mov     ds, ax
    mov     ax, 0b800h
    mov     es, ax



;   MMMMMMMM               MMMMMMMM    EEEEEEEEEEEEEEEEEEEEEE    NNNNNNNN        NNNNNNNN    UUUUUUUU     UUUUUUUU
;   M:::::::M             M:::::::M    E::::::::::::::::::::E    N:::::::N       N::::::N    U::::::U     U::::::U
;   M::::::::M           M::::::::M    E::::::::::::::::::::E    N::::::::N      N::::::N    U::::::U     U::::::U
;   M:::::::::M         M:::::::::M    EE::::::EEEEEEEEE::::E    N:::::::::N     N::::::N    UU:::::U     U:::::UU
;   M::::::::::M       M::::::::::M      E:::::E       EEEEEE    N::::::::::N    N::::::N     U:::::U     U:::::U
;   M:::::::::::M     M:::::::::::M      E:::::E                 N:::::::::::N   N::::::N     U:::::D     D:::::U
;   M:::::::M::::M   M::::M:::::::M      E::::::EEEEEEEEEE       N:::::::N::::N  N::::::N     U:::::D     D:::::U
;   M::::::M M::::M M::::M M::::::M      E:::::::::::::::E       N::::::N N::::N N::::::N     U:::::D     D:::::U
;   M::::::M  M::::M::::M  M::::::M      E:::::::::::::::E       N::::::N  N::::N:::::::N     U:::::D     D:::::U
;   M::::::M   M:::::::M   M::::::M      E::::::EEEEEEEEEE       N::::::N   N:::::::::::N     U:::::D     D:::::U
;   M::::::M    M:::::M    M::::::M      E:::::E                 N::::::N    N::::::::::N     U:::::D     D:::::U
;   M::::::M     MMMMM     M::::::M      E:::::E       EEEEEE    N::::::N     N:::::::::N     U::::::U   U::::::U
;   M::::::M               M::::::M    EE::::::EEEEEEEE:::::E    N::::::N      N::::::::N     U:::::::UUU:::::::U
;   M::::::M               M::::::M    E::::::::::::::::::::E    N::::::N       N:::::::N      UU:::::::::::::UU
;   M::::::M               M::::::M    E::::::::::::::::::::E    N::::::N        N::::::N        UU:::::::::UU
;   MMMMMMMM               MMMMMMMM    EEEEEEEEEEEEEEEEEEEEEE    NNNNNNNN         NNNNNNN          UUUUUUUUU





menu1:
  call clear_screen
  lea  dx, menu1_txt
  call display_fich



  mov  ah, 07h ;WAIT FOR ANY KEY.
  int  21h
  cmp  al, '1'
  je   jogo_menu
  cmp  al, '2'
  je   top10
  cmp  al, '3'
  je   config
  cmp  al, '4'
  je  sair
  jmp menu1


;            JJJJJJJJJJJ        OOOOOOOOO                GGGGGGGGGGGGG        OOOOOOOOO
;            J:::::::::J      OO:::::::::OO           GGG::::::::::::G      OO:::::::::OO
;            J:::::::::J    OO:::::::::::::OO       GG:::::::::::::::G    OO:::::::::::::OO
;            JJ:::::::JJ   O:::::::OOO:::::::O     G:::::GGGGGGGG::::G   O:::::::OOO:::::::O
;              J:::::J     O::::::O   O::::::O    G:::::G       GGGGGG   O::::::O   O::::::O
;              J:::::J     O:::::O     O:::::O   G:::::G                 O:::::O     O:::::O
;              J:::::J     O:::::O     O:::::O   G:::::G                 O:::::O     O:::::O
;              J:::::j     O:::::O     O:::::O   G:::::G    GGGGGGGGGG   O:::::O     O:::::O
;              J:::::J     O:::::O     O:::::O   G:::::G    G::::::::G   O:::::O     O:::::O
;  JJJJJJJ     J:::::J     O:::::O     O:::::O   G:::::G    GGGGG::::G   O:::::O     O:::::O
;  J:::::J     J:::::J     O:::::O     O:::::O   G:::::G        G::::G   O:::::O     O:::::O
;  J::::::J   J::::::J     O::::::O   O::::::O    G:::::G       G::::G   O::::::O   O::::::O
;  J:::::::JJJ:::::::J     O:::::::OOO:::::::O     G:::::GGGGGGGG::::G   O:::::::OOO:::::::O
;   JJ:::::::::::::JJ       OO:::::::::::::OO       GG:::::::::::::::G    OO:::::::::::::OO
;     JJ:::::::::JJ           OO:::::::::OO           GGG::::::GGG:::G      OO:::::::::OO
;       JJJJJJJJJ               OOOOOOOOO                GGGGGG   GGGG        OOOOOOOOO

  jogo_menu:
      call clear_screen
      call display_menuJogar

      mov  ah, 07h ;WAIT FOR ANY KEY.
      int  21h
      cmp  al, '1'
      je   jogo
      cmp  al, '2'
      je   jogob
      cmp  al, '3'
      je   voltar_jogo


  jogo:
      call clear_screen
      lea  dx, maze
      call display_fich


      goto_xy	POSx,POSy	; Vai para nova possi��o
  		mov 	ah, 08h	; Guarda o Caracter que est� na posi��o do Cursor
  		mov		bh,0		; numero da p�gina
  		int		10h
  		mov		Car, al	; Guarda o Caracter que est� na posi��o do Cursor
  		mov		Cor, ah	; Guarda a cor que est� na posi��o do Cursor


      CICLO:
          goto_xy	POSxa,POSya	; Vai para a posi��o anterior do cursor
  		    mov		ah, 02h
  		    mov		dl, Car	; Repoe Caracter guardado
  		    int		21H

  		    goto_xy	POSx,POSy	; Vai para nova possi��o
  		    mov 	ah, 08h
  		    mov		bh,0		; numero da p�gina
  		    int		10h
  		    mov		Car, al 	; Guarda o Caracter que est� na posi��o do Cursor
  		    mov		Cor, ah	; Guarda a cor que est� na posi��o do Cursor

  		    goto_xy	77,1		; Mostra o caractr que estava na posi��o do AVATAR
  		    mov		ah, 02h	; IMPRIME caracter da posi��o no canto
  		    mov		dl, Car
  		    int		21H

  		    goto_xy	POSx,POSy	; Vai para posi��o do cursor
          IMPRIME:
              mov		ah, 02h
  		        mov		dl, 185	; Coloca AVATAR
  		        int		21H
  		        goto_xy	POSx,POSy	; Vai para posi��o do cursor

  		        mov		al, POSx	; Guarda a posi��o do cursor
  		        mov		POSxa, al
  		        mov		al, POSy	; Guarda a posi��o do cursor
  		        mov 	POSya, al

          LER_SETA:
              call 	LE_TECLA
  		        cmp		ah, 1
  		        je		CIMA
  		        cmp 	al, 'q'	; ESCAPE
  		        je		voltar_jogo
  		        jmp		LER_SETA

          CIMA:
              cmp 	al,48h
  		        jne		BAIXO
              call  decY
              cmp   ganhouVar,1
              je    ganhou
              jmp		CICLO

          BAIXO:
              cmp		al,50h
  		        jne		ESQUERDA
              call   incY
              cmp   ganhouVar,1
              je    ganhou
              jmp		CICLO

          ESQUERDA:
  		        cmp		al,4bh
  		        jne		DIREITA
              call   decX
              cmp   ganhouVar,1
              je    ganhou
              jmp		CICLO

          DIREITA:
  		        cmp		al,4dh
  		        jne		LER_SETA
              call   incX
              cmp   ganhouVar,1
              je    ganhou
              jmp		CICLO


          ganhou:
              call clear_screen
              lea dx, ganhou_txt
              call display_fich
              mov  al, POSyO
              mov  POSy, al
              mov  al, POSxO
              mov  POSx, al

              goto_xy	POSx,POSy	; Vai para nova possi��o

              mov  ah, 07h ;WAIT FOR ANY KEY.
              int  21h
              jmp  voltar_jogo
          voltar_jogo:
              jmp  menu1




 ;            JJJJJJJJJJJ     OOOOOOOOO             GGGGGGGGGGGGG     OOOOOOOOO          BBBBBBBBBBBBBBBBB
 ;            J:::::::::J   OO:::::::::OO        GGG::::::::::::G   OO:::::::::OO        B::::::::::::::::B
 ;            J:::::::::J OO:::::::::::::OO    GG:::::::::::::::G OO:::::::::::::OO      B::::::BBBBBB:::::B
 ;            JJ:::::::JJO:::::::OOO:::::::O  G:::::GGGGGGGG::::GO:::::::OOO:::::::O     BB:::::B     B:::::B
 ;              J:::::J  O::::::O   O::::::O G:::::G       GGGGGGO::::::O   O::::::O       B::::B     B:::::B
 ;              J:::::J  O:::::O     O:::::OG:::::G              O:::::O     O:::::O       B::::B     B:::::B
 ;              J:::::J  O:::::O     O:::::OG:::::G              O:::::O     O:::::O       B::::BBBBBB:::::B
 ;              J:::::j  O:::::O     O:::::OG:::::G    GGGGGGGGGGO:::::O     O:::::O       B:::::::::::::BB
 ;              J:::::J  O:::::O     O:::::OG:::::G    G::::::::GO:::::O     O:::::O       B::::BBBBBB:::::B
 ;  JJJJJJJ     J:::::J  O:::::O     O:::::OG:::::G    GGGGG::::GO:::::O     O:::::O       B::::B     B:::::B
 ;  J:::::J     J:::::J  O:::::O     O:::::OG:::::G        G::::GO:::::O     O:::::O       B::::B     B:::::B
 ;  J::::::J   J::::::J  O::::::O   O::::::O G:::::G       G::::GO::::::O   O::::::O       B::::B     B:::::B
 ;  J:::::::JJJ:::::::J  O:::::::OOO:::::::O  G:::::GGGGGGGG::::GO:::::::OOO:::::::O     BB:::::BBBBBB::::::B
 ;   JJ:::::::::::::JJ    OO:::::::::::::OO    GG:::::::::::::::G OO:::::::::::::OO      B:::::::::::::::::B
 ;     JJ:::::::::JJ        OO:::::::::OO        GGG::::::GGG:::G   OO:::::::::OO        B::::::::::::::::B
 ;       JJJJJJJJJ            OOOOOOOOO             GGGGGG   GGGG     OOOOOOOOO          BBBBBBBBBBBBBBBBB

             jogob:

             call clear_screen
             lea  dx, mazeB
             call display_fich
             mov delaytime, 5
             call bonus_string
             mov si, 2
             goto_xy	POSx,POSy	; Vai para nova possi��o
             mov 	ah, 08h	; Guarda o Caracter que est� na posi��o do Cursor
             mov		bh,0		; numero da p�gina
             int		10h
             mov		Car, al	; Guarda o Caracter que est� na posi��o do Cursor
             mov		Cor, ah	; Guarda a cor que est� na posi��o do Cursor


             CICLOb:

             call clear_screen
             lea  dx, mazeB
             call display_fich
                 goto_xy	POSxa,POSya	; Vai para a posi��o anterior do cursor
                 mov		ah, 02h
                 mov		dl, Car	; Repoe Caracter guardado
                 int		21H

                 goto_xy	POSx,POSy	; Vai para nova possi��o
                 mov 	ah, 08h
                 mov		bh,0		; numero da p�gina
                 int		10htr
                 mov		Car, al 	; Guarda o Caracter que est� na posi��o do Cursor
                 mov		Cor, ah	; Guarda a cor que est� na posi��o do Cursor

                 goto_xy	77,1		; Mostra o caractr que estava na posi��o do AVATAR
                 mov		ah, 02h	; IMPRIME caracter da posi��o no canto
                 mov		dl, Car
                 int		21H

                 goto_xy	POSx,POSy	; Vai para posi��o do cursor
                 IMPRIMEb:
                     mov		ah, 02h
                     mov		dl, 185	; Coloca AVATAR
                     int		21H
                     goto_xy	POSx,POSy	; Vai para posi��o do cursor

                     mov		al, POSx	; Guarda a posi��o do cursor
                     mov		POSxa, al
                     mov		al, POSy	; Guarda a posi��o do cursor
                     mov 	POSya, al


                 COMP_CHAR:

                     call delay
                     mov al,buff[si]
                     cmp   ganhouVar, 1
                     je    ganhoub
                     cmp al, '$'
                     jne tec0
                     cmp al, '$'
                     je perdeu
                     jmp CICLOb

                     tec0:
                       cmp al, '0'
                       jne tec1
                       call decY
                       inc si
                       jmp CICLOb
                     tec1:
                       cmp al, '1'
                       jne tec2
                       call decY
                       call decY
                       inc si
                       jmp CICLOb
                     tec2:
                       cmp al, '2'
                       jne tec3
                       call decY
                       call decY
                       call decY
                       inc si
                       jmp CICLOb
                     tec3:
                       cmp al, '3'
                       jne tec4
                       call decY
                       call decY
                       call decY
                       call decY
                       inc si
                       jmp CICLOb
                     tec4:
                       cmp al, '4'
                     jne tec5
                     call incY
                     inc si
                     jmp CICLOb
                     tec5:
                     cmp al, '5'
                     jne tec6
                     call incY
                     call incY
                     inc si
                     jmp CICLOb
                     tec6:
                     cmp al, '6'
                     jne tec7
                     call incY
                     call incY
                     call incY
                     inc si
                     jmp CICLOb
                     tec7:
                     cmp al, '7'
                     jne tec8
                     call incY
                     call incY
                     call incY
                     call incY
                     je    perdeu
                     inc si
                     jmp CICLOb
                     tec8:
                     cmp al, '8'
                     jne tec9
                     call incX
                     inc si
                     jmp CICLOb
                     tec9:
                     cmp al, '9'
                     jne tecA
                     call incX
                     call incX

                     inc si
                     jmp CICLOb
                     tecA:
                     cmp al, 'a'
                     jne tecB
                     call incX
                     call incX
                     call incX
                     inc si
                     jmp CICLOb
                     tecB:
                     cmp al, 'b'
                     jne tecC
                     call incX
                     call incX
                     call incX
                     call incX
                     inc si
                     jmp CICLOb
                     tecC:
                     cmp al, 'c'
                     jne tecD
                     call decX
                     inc si
                     jmp CICLOb
                     tecD:
                     cmp al, 'd'
                     jne tecE
                     call decX
                     call decX
                     inc si
                     jmp CICLOb
                     tecE:
                     cmp al, 'e'
                     jne tecF
                     call decX
                     call decX
                     call decX
                     inc si
                     jmp CICLOb
                     tecF:
                     cmp al, 'f'
                     jne COMP_CHAR
                     call decX
                     call decX
                     call decX
                     call decX
                     inc si
                     jmp CICLOb


                         ganhoub:
                             mov ax, 0003H
                             int 10H
                             mov delaytime, 100
                             mov dx, 0000H
                             call clear_screen
                             lea dx, ganhou_txt
                             call display_fich
                             mov  al, POSyO
                             mov  POSy, al
                             mov  al, POSxO
                             mov  POSx, al
                             mov ganhouVar, 0
                             goto_xy	POSx,POSy	; Vai para nova possi��o

                             mov  ah, 07h ;WAIT FOR ANY KEY.
                             int  21h
                             jmp saib


                             perdeu:

                             mov ax, 0003H
                             int 10H
                             mov delaytime, 100
                             mov dx, 0000H
                             call clear_screen
                             lea dx, perdeu_txt
                             call display_fich
                             mov  al, POSyO
                             mov  POSy, al
                             mov  al, POSxO
                             mov  POSx, al
                             goto_xy	POSx,POSy	; Vai para nova possi��o

                             mov  ah, 07h ;WAIT FOR ANY KEY.
                             int  21h
                             jmp saib

                             saib:
                             jmp jogo_menu


;  TTTTTTTTTTTTTTTTTTTTTTT        OOOOOOOOO        PPPPPPPPPPPPPPPPP             1111111           000000000
;  T:::::::::::::::::::::T      OO:::::::::OO      P::::::::::::::::P           1::::::1         00:::::::::00
;  T:::::::::::::::::::::T    OO:::::::::::::OO    P::::::PPPPPP:::::P         1:::::::1       00:::::::::::::00
;  T:::::TT:::::::TT:::::T   O:::::::OOO:::::::O   PP:::::P     P:::::P        111:::::1      0:::::::000:::::::0
;  TTTTTT  T:::::T  TTTTTT   O::::::O   O::::::O     P::::P     P:::::P           1::::1      0::::::0   0::::::0
;          T:::::T           O:::::O     O:::::O     P::::P     P:::::P           1::::1      0:::::0     0:::::0
;          T:::::T           O:::::O     O:::::O     P::::PPPPPP:::::P            1::::1      0:::::0     0:::::0
;          T:::::T           O:::::O     O:::::O     P:::::::::::::PP             1::::l      0:::::0 000 0:::::0
;          T:::::T           O:::::O     O:::::O     P::::PPPPPPPPP               1::::l      0:::::0 000 0:::::0
;          T:::::T           O:::::O     O:::::O     P::::P                       1::::l      0:::::0     0:::::0
;          T:::::T           O:::::O     O:::::O     P::::P                       1::::l      0:::::0     0:::::0
;          T:::::T           O::::::O   O::::::O     P::::P                       1::::l      0::::::0   0::::::0
;        TT:::::::TT         O:::::::OOO:::::::O   PP::::::PP                  111::::::111   0:::::::000:::::::0
;        T:::::::::T          OO:::::::::::::OO    P::::::::P                  1::::::::::1    00:::::::::::::00
;        T:::::::::T            OO:::::::::OO      P::::::::P                  1::::::::::1      00:::::::::00
;        TTTTTTTTTTT              OOOOOOOOO        PPPPPPPPPP                  111111111111        000000000

    top10:
      call clear_screen
      lea  dx, top10_txt
      call display_fich
      mov  ah, 07h ;WAIT FOR ANY KEY.
      int  21h
      jmp  menu1


;           CCCCCCCCCCCCC        OOOOOOOOO        NNNNNNNN        NNNNNNNN   FFFFFFFFFFFFFFFFFFFFFF   IIIIIIIIII         GGGGGGGGGGGGG
;        CCC::::::::::::C      OO:::::::::OO      N:::::::N       N::::::N   F::::::::::::::::::::F   I::::::::I      GGG::::::::::::G
;      CC:::::::::::::::C    OO:::::::::::::OO    N::::::::N      N::::::N   F::::::::::::::::::::F   I::::::::I    GG:::::::::::::::G
;     C:::::CCCCCCCC::::C   O:::::::OOO:::::::O   N:::::::::N     N::::::N   FF::::::FFFFFFFFF::::F   II::::::II   G:::::GGGGGGGG::::G
;    C:::::C       CCCCCC   O::::::O   O::::::O   N::::::::::N    N::::::N     F:::::F       FFFFFF     I::::I    G:::::G       GGGGGG
;   C:::::C                 O:::::O     O:::::O   N:::::::::::N   N::::::N     F:::::F                  I::::I   G:::::G
;   C:::::C                 O:::::O     O:::::O   N:::::::N::::N  N::::::N     F::::::FFFFFFFFFF        I::::I   G:::::G
;   C:::::C                 O:::::O     O:::::O   N::::::N N::::N N::::::N     F:::::::::::::::F        I::::I   G:::::G    GGGGGGGGGG
;   C:::::C                 O:::::O     O:::::O   N::::::N  N::::N:::::::N     F:::::::::::::::F        I::::I   G:::::G    G::::::::G
;   C:::::C                 O:::::O     O:::::O   N::::::N   N:::::::::::N     F::::::FFFFFFFFFF        I::::I   G:::::G    GGGGG::::G
;   C:::::C                 O:::::O     O:::::O   N::::::N    N::::::::::N     F:::::F                  I::::I   G:::::G        G::::G
;    C:::::C       CCCCCC   O::::::O   O::::::O   N::::::N     N:::::::::N     F:::::F                  I::::I    G:::::G       G::::G
;     C:::::CCCCCCCC::::C   O:::::::OOO:::::::O   N::::::N      N::::::::N   FF:::::::FF              II::::::II   G:::::GGGGGGGG::::G
;      CC:::::::::::::::C    OO:::::::::::::OO    N::::::N       N:::::::N   F::::::::FF              I::::::::I    GG:::::::::::::::G
;        CCC::::::::::::C      OO:::::::::OO      N::::::N        N::::::N   F::::::::FF              I::::::::I      GGG::::::GGG:::G
;           CCCCCCCCCCCCC        OOOOOOOOO        NNNNNNNN         NNNNNNN   FFFFFFFFFFF              IIIIIIIIII         GGGGGG   GGGG
  config:
      call clear_screen
      lea  dx, menu_conf
      call display_fich

      xor ax, ax
      mov  ah, 1
      int  21h
      cmp  al, '1'
      je   labiBase
      cmp  al, '2'
      je   carreLabi
      cmp  al, '3'
      je   criaLabi
      cmp  al, '4'
      je   ediLabi
      cmp al, '5'
      je  voltar
      jmp config

      labiBase:
      jmp Config
      carreLabi:
      jmp Config
      criaLabi:
      call cria_maze
      jmp config
      ediLabi:
      jmp Config
      voltar:
          jmp  menu1



  sair:
      ;FINISH PROGRAM.
      mov  ax, 4c00h
      int  21h

main		endp



; PPPPPPPPPPPPPPPPP        RRRRRRRRRRRRRRRRR             OOOOOOOOO                  CCCCCCCCCCCCC        SSSSSSSSSSSSSSS
; P::::::::::::::::P       R::::::::::::::::R          OO:::::::::OO             CCC::::::::::::C      SS:::::::::::::::S
; P::::::PPPPPP:::::P      R::::::RRRRRR:::::R       OO:::::::::::::OO         CC:::::::::::::::C     S:::::SSSSSS::::::S
; PP:::::P     P:::::P     RR:::::R     R:::::R     O:::::::OOO:::::::O       C:::::CCCCCCCC::::C     S:::::S     SSSSSSS
;   P::::P     P:::::P       R::::R     R:::::R     O::::::O   O::::::O      C:::::C       CCCCCC     S:::::S
;   P::::P     P:::::P       R::::R     R:::::R     O:::::O     O:::::O     C:::::C                   S:::::S
;   P::::PPPPPP:::::P        R::::RRRRRR:::::R      O:::::O     O:::::O     C:::::C                    S::::SSSS
;   P:::::::::::::PP         R:::::::::::::RR       O:::::O     O:::::O     C:::::C                     SS::::::SSSSS
;   P::::PPPPPPPPP           R::::RRRRRR:::::R      O:::::O     O:::::O     C:::::C                       SSS::::::::SS
;   P::::P                   R::::R     R:::::R     O:::::O     O:::::O     C:::::C                          SSSSSS::::S
;   P::::P                   R::::R     R:::::R     O:::::O     O:::::O     C:::::C                               S:::::S
;   P::::P                   R::::R     R:::::R     O::::::O   O::::::O      C:::::C       CCCCCC                 S:::::S
; PP::::::PP               RR:::::R     R:::::R     O:::::::OOO:::::::O       C:::::CCCCCCCC::::C     SSSSSSS     S:::::S
; P::::::::P               R::::::R     R:::::R      OO:::::::::::::OO         CC:::::::::::::::C     S::::::SSSSSS:::::S
; P::::::::P               R::::::R     R:::::R        OO:::::::::OO             CCC::::::::::::C     S:::::::::::::::SS
; PPPPPPPPPP               RRRRRRRR     RRRRRRR          OOOOOOOOO                  CCCCCCCCCCCCC      SSSSSSSSSSSSSSS


display_menuJogar proc
  mov  dx, offset menuJogar
  mov  ah, 9
  int  21h
  ret
display_menuJogar endp







;                              ______  __       __  _______    ________  ______   ______   __    __
;                             /      |/  \     /  |/       \  /        |/      | /      \ /  |  /  |
;                             $$$$$$/ $$  \   /$$ |$$$$$$$  | $$$$$$$$/ $$$$$$/ /$$$$$$  |$$ |  $$ |
;                               $$ |  $$$  \ /$$$ |$$ |__$$ | $$ |__      $$ |  $$ |  $$/ $$ |__$$ |
;                               $$ |  $$$$  /$$$$ |$$    $$/  $$    |     $$ |  $$ |      $$    $$ |
;                               $$ |  $$ $$ $$/$$ |$$$$$$$/   $$$$$/      $$ |  $$ |   __ $$$$$$$$ |
;                              _$$ |_ $$ |$$$/ $$ |$$ |       $$ |       _$$ |_ $$ \__/  |$$ |  $$ |
;                             / $$   |$$ | $/  $$ |$$ |______ $$ |      / $$   |$$    $$/ $$ |  $$ |
;                             $$$$$$/ $$/      $$/ $$//      |$$/       $$$$$$/  $$$$$$/  $$/   $$/
;                                                     $$$$$$/

display_fich  proc

mov     ah,3dh			; vamos abrir ficheiro para leitura
mov     al,0			; tipo de ficheiro
int     21h			; abre para leitura
jc      erro_abrir		; pode aconter erro a abrir o ficheiro
mov     HandleFich,ax		; ax devolve o Handle para o ficheiro
jmp     ler_ciclo		; depois de abero vamos ler o ficheiro

erro_abrir:
mov     ah,09h
lea     dx,Erro_Open
int     21h
jmp     sai

ler_ciclo:
mov     ah,3fh			; indica que vai ser lido um ficheiro
mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto
mov     cx,1			; numero de bytes a ler
lea     dx,car_fich		; vai ler para o local de memoria apontado por dx (car_fich)
int     21h				; faz efectivamente a leitura
jc	    erro_ler		; se carry é porque aconteceu um erro
cmp	    ax,0			;EOF?	verifica se já estamos no fim do ficheiro
je	    fecha_ficheiro	; se EOF fecha o ficheiro
mov     ah,02h			; coloca o caracter no ecran
mov	    dl,car_fich		; este é o caracter a enviar para o ecran
int	    21h				; imprime no ecran
jmp	    ler_ciclo		; continua a ler o ficheiro

erro_ler:
mov     ah,09h
lea     dx,Erro_Ler_Msg
int     21h

fecha_ficheiro:					; vamos fechar o ficheiro
mov     ah,3eh
mov     bx,HandleFich
int     21h
jnc     sai

        mov     ah,09h			; o ficheiro pode não fechar correctamente
        lea     dx,Erro_Close
        Int     21h
sai:
        ret


display_fich  endp


;                        ______   __        ________   ______   _______          ______    ______   _______   ________  ________  __    __
;                       /      \ /  |      /        | /      \ /       \        /      \  /      \ /       \ /        |/        |/  \  /  |
;                      /$$$$$$  |$$ |      $$$$$$$$/ /$$$$$$  |$$$$$$$  |      /$$$$$$  |/$$$$$$  |$$$$$$$  |$$$$$$$$/ $$$$$$$$/ $$  \ $$ |
;                      $$ |  $$/ $$ |      $$ |__    $$ |__$$ |$$ |__$$ |      $$ \__$$/ $$ |  $$/ $$ |__$$ |$$ |__    $$ |__    $$$  \$$ |
;                      $$ |      $$ |      $$    |   $$    $$ |$$    $$<       $$      \ $$ |      $$    $$< $$    |   $$    |   $$$$  $$ |
;                      $$ |   __ $$ |      $$$$$/    $$$$$$$$ |$$$$$$$  |       $$$$$$  |$$ |   __ $$$$$$$  |$$$$$/    $$$$$/    $$ $$ $$ |
;                      $$ \__/  |$$ |_____ $$ |_____ $$ |  $$ |$$ |  $$ |      /  \__$$ |$$ \__/  |$$ |  $$ |$$ |_____ $$ |_____ $$ |$$$$ |
;                      $$    $$/ $$       |$$       |$$ |  $$ |$$ |  $$ |______$$    $$/ $$    $$/ $$ |  $$ |$$       |$$       |$$ | $$$ |
;                       $$$$$$/  $$$$$$$$/ $$$$$$$$/ $$/   $$/ $$/   $$//      |$$$$$$/   $$$$$$/  $$/   $$/ $$$$$$$$/ $$$$$$$$/ $$/   $$/
;                                                                       $$$$$$/

    clear_screen proc
      mov  ah, 0
      mov  al, 3
      int  10H
      ret
    clear_screen endp

;                                      __        ________  _______       ________  ________   ______   __         ______
;                                     /  |      /        |/       \     /        |/        | /      \ /  |       /      \
;                                     $$ |      $$$$$$$$/ $$$$$$$  |    $$$$$$$$/ $$$$$$$$/ /$$$$$$  |$$ |      /$$$$$$  |
;                                     $$ |      $$ |__    $$ |__$$ |       $$ |   $$ |__    $$ |  $$/ $$ |      $$ |__$$ |
;                                     $$ |      $$    |   $$    $$<        $$ |   $$    |   $$ |      $$ |      $$    $$ |
;                                     $$ |      $$$$$/    $$$$$$$  |       $$ |   $$$$$/    $$ |   __ $$ |      $$$$$$$$ |
;                                     $$ |_____ $$ |_____ $$ |  $$ |       $$ |   $$ |_____ $$ \__/  |$$ |_____ $$ |  $$ |
;                                     $$       |$$       |$$ |  $$ |______ $$ |   $$       |$$    $$/ $$       |$$ |  $$ |
;                                     $$$$$$$$/ $$$$$$$$/ $$/   $$//      |$$/    $$$$$$$$/  $$$$$$/  $$$$$$$$/ $$/   $$/
;                                                                  $$$$$$/

    LE_TECLA	PROC

    		mov		ah,07h
    		int		21h
    		mov		ah,0
    		cmp		al,0
    		jne		SAI_TECLA
    		mov		ah, 07h
    		int		21h
    		mov		ah,1
    SAI_TECLA:	RET
    LE_TECLA	endp

;                                    ______   _______   ______   ______          __       __   ______   ________  ________
;                                   /      \ /       \ /      | /      \        /  \     /  | /      \ /        |/        |
;                                  /$$$$$$  |$$$$$$$  |$$$$$$/ /$$$$$$  |       $$  \   /$$ |/$$$$$$  |$$$$$$$$/ $$$$$$$$/
;                                  $$ |  $$/ $$ |__$$ |  $$ |  $$ |__$$ |       $$$  \ /$$$ |$$ |__$$ |    /$$/  $$ |__
;                                  $$ |      $$    $$<   $$ |  $$    $$ |       $$$$  /$$$$ |$$    $$ |   /$$/   $$    |
;                                  $$ |   __ $$$$$$$  |  $$ |  $$$$$$$$ |       $$ $$ $$/$$ |$$$$$$$$ |  /$$/    $$$$$/
;                                  $$ \__/  |$$ |  $$ | _$$ |_ $$ |  $$ |       $$ |$$$/ $$ |$$ |  $$ | /$$/____ $$ |_____
;                                  $$    $$/ $$ |  $$ |/ $$   |$$ |  $$ |______ $$ | $/  $$ |$$ |  $$ |/$$      |$$       |
;                                   $$$$$$/  $$/   $$/ $$$$$$/ $$/   $$//      |$$/      $$/ $$/   $$/ $$$$$$$$/ $$$$$$$$/
;                                                                       $$$$$$/

    cria_maze proc
      call		clear_screen

		  ;Obter a posi��o
		  dec		CPOSy		; linha = linha -1
		  dec		CPOSx		; POSx = POSx -1

      CICLO:
        goto_xy	CPOSx,CPOSy
        IMPRIME:
          mov		ah, 02h
		      mov		dl, CCar
		      int		21H
		      goto_xy	CPOSx,CPOSy

		      call 		LE_TECLA
		      cmp		ah, 1
		      je		ESTEND
		      cmp 		al, 'q'		; ESCAPE
		      je		FIM

        ZERO:
          cmp 		al, 48		; Tecla 0
		      jne		UM
		      mov		CCar, 32		;ESPA�O
		      jmp		CICLO

        UM:
          cmp 		al, 49		; Tecla 1
		      jne		DOIS
		      mov		CCar, 219		;Caracter CHEIO
		      jmp		CICLO

        DOIS:
          cmp 		al, 50		; Tecla 2
		      jne		TRES
		      mov		CCar, 177		;CINZA 177
		      jmp		CICLO

        TRES:
          cmp 		al, 51		; Tecla 3
		      jne		QUATRO
		      mov		CCar, 178		;CINZA 178
		      jmp		CICLO

        QUATRO:
          cmp 		al, 52		; Tecla 4
		      jne		NOVE
		      mov		CCar, 176		;CINZA 176
		      jmp		CICLO

        NOVE:
          jmp		CICLO

        ESTEND:
          cmp 		al,48h
		      jne		BAIXO
		      dec		CPOSy		;cima
		      jmp		CICLO

        BAIXO:
          cmp		al,50h
		      jne		ESQUERDA
		      inc 		CPOSy		;Baixo
		      jmp		CICLO

        ESQUERDA:
		      cmp		al,4Bh
		      jne		DIREITA
		      dec		CPOSx		;Esquerda
		      jmp		CICLO

        DIREITA:
		      cmp		al,4Dh
		      jne		CICLO
		      inc		CPOSx		;Direita
		      jmp		CICLO

        fim:
		      ret
    cria_maze endp



; ######################################################################################################################################
; ######################################################################################################################################
; ######################################################################################################################################
; ######################################################################################################################################


delay proc

    ;this procedure uses 1A interrupt, more info can be found on
    ;http://www.computing.dcu.ie/~ray/teaching/CA296/notes/8086_bios_and_dos_interrupts.html
    mov ah, 00
    int 1Ah
    mov bx, dx

jmp_delay:
    int 1Ah
    sub dx, bx
    ;there are about 18 ticks in a second, 10 ticks are about enough
    cmp dl, delaytime
    jl jmp_delay
    ret

delay endp



decY proc
    mov al, POSy
    mov POSyn, al
    dec POSyn
    goto_xy	POSx,POSyn
    mov 	ah, 08h
    mov		bh,0		; numero da p�gina
    int		10h
    mov		Carn, al	; Guarda o Caracter que est� na posi��o do Curso
      cmp carn, '*'
    je return
    cmp carn, '-'
    je return
    cmp carn, '|'
    je return
    cmp carn, '+'
    je return
    cmp   Carn, 'F'
    je    ganhouProc
    mov   al, POSyn
    mov   POSy,al
    mov   al, POSya
    mov   POSyn,al
    jmp return
    ganhouProc:
    mov al,1
    mov ganhouVar, al
    jmp return
    return:
    ret
decY endp

incY proc
    mov al, POSy
    mov POSyn, al
    inc POSyn
    goto_xy	POSx,POSyn
    mov 	ah, 08h
    mov		bh,0		; numero da p�gina
    int		10h
    mov		Carn, al	; Guarda o Caracter que est� na posi��o do Cursor
    cmp carn, '*'
    je return
    cmp carn, '-'
    je return
    cmp carn, '|'
    je return
    cmp carn, '+'
    je return
    cmp   Carn, 'F'
    je    ganhouProc
    mov   al, POSyn
    mov   POSy,al
    mov   al, POSya
    mov   POSyn,al
    jmp return
    ganhouProc:
    mov al,1
    mov ganhouVar, al
    jmp return
    return:
    ret
incY endp


incX proc
    mov al, POSx
    mov POSxn, al
    inc POSxn
    goto_xy	POSxn,POSy
    mov 	ah, 08h
    mov		bh,0		; numero da p�gina
    int		10h
    mov		Carn, al	; Guarda o Caracter que est� na posi��o do Cursor
    cmp carn, '*'
    je return
    cmp carn, '-'
    je return
    cmp carn, '|'
    je return
    cmp carn, '+'
    je return
    cmp   Carn, 'F'
    je    ganhouProc
    mov   al, POSxn
    mov   POSx,al
    mov   al, POSxa
    mov   POSxn,al
    jmp return
    ganhouProc:
    mov al,1
    mov ganhouVar, al
    jmp return
    return:
    ret
incX endp

decX proc
    mov al, POSx
    mov POSxn, al
    dec POSxn
    goto_xy	POSxn,POSy
    mov 	ah, 08h
    mov		bh,0		; numero da p�gina
    int		10h
    mov		Carn, al	; Guarda o Caracter que est� na posi��o do Cursor
    cmp carn, '*'
    je return
    cmp carn, '-'
    je return
    cmp carn, '|'
    je return
    cmp carn, '+'
    je return
    cmp   Carn, 'F'
    je    ganhouProc
    mov   al, POSxn
    mov   POSx,al
    mov   al, POSxa
    mov   POSxn,al
    jmp return

    ganhouProc:
    mov al,1
    mov ganhouVar, al
    jmp return
    return:
    ret
decX endp

bonus_string proc
;CAPTURE STRING FROM KEYBOARD.
            mov dl,0
            xor si,si
            xor di,di

            mov ah, 0Ah ;SERVICE TO CAPTURE STRING FROM KEYBOARD.
            mov dx, offset buff
            int 21h
            call clear_screen
;CHANGE CHR(13) BY '$'.
            mov si, offset buff + 1 ;NUMBER OF CHARACTERS ENTERED.
            mov cl, [ si ] ;MOVE LENGTH TO CL.
            mov ch, 0      ;CLEAR CH TO USE CX.
            inc cx ;TO REACH CHR(13).
            add si, cx ;NOW SI POINTS TO CHR(13).
            mov al, '$'
            mov [ si ], al ;REPLACE CHR(13) BY '$'.
            ret
bonus_string endp

cseg    	ends
end     	Main
