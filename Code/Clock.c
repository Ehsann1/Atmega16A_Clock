/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 7/21/2021
Author  : 
Company : 
Comments: 


Chip type               : ATmega16A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16a.h>
#include <delay.h>
#include <i2c.h>
#include <ds1307.h>
#include <alcd.h>
#include <stdio.h>


// Variables:
#define H1 PORTC.5
#define H2 PORTC.4
#define M1 PORTC.3
#define M2 PORTC.2

#define _7seg PORTD

#define selectKey PINA.6
#define ValueKey PINA.7

char select=0,
     r_h, r_m, r_s, 
     ti=0, temp, 
     r_D, r_M, r_Y ,r_wd;
     
unsigned char text[32], edit_mode[6]; // H:M:S | Y/M/D                                      
flash char Display[10] = { 0XC0 , 0XF9 , 0XA4 , 0X30 , 0X99 , 0X92 , 0X82 , 0XF8 , 0X80 , 0X90 };
// Variables/


interrupt [TIM0_OVF] void timer0_ovf_isr(void){
      TCNT0=0x83;
      // Timer Codes  
                         
      if(ti==0){      
       M2=1;H2=0;M1=0;H1=0;
        _7seg = Display[r_m%10];
        }  
      if(ti==1){  
        M1=1;H2=0;M2=0;H1=0;
        _7seg = Display[r_m/10]; 
        }
      if(ti==2){
        H2=1;M2=0;M1=0;H1=0;
        _7seg = Display[r_h%10];
        }
      if(ti==3){  
        H1=1;H2=0;M1=0;M2=0;
        _7seg = Display[r_h/10];       
        } 
        ti++;
        if(ti==4){ti=0;}

}

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input){
      ADMUX=adc_input | ADC_VREF_TYPE;
      delay_us(10);
      ADCSRA|=(1<<ADSC);
      while ((ADCSRA & (1<<ADIF))==0);
      ADCSRA|=(1<<ADIF);
      return ADCW;
}


void change_select_po(void){
switch (select){
                case 0:lcd_gotoxy(1,0);_lcd_write_data(0xF);break;
                case 1:lcd_gotoxy(4,0);_lcd_write_data(0xF);break;
                case 2:lcd_gotoxy(7,0);_lcd_write_data(0xF);break;
                case 3:lcd_gotoxy(10,0);_lcd_write_data(0xF);break;
                case 4:lcd_gotoxy(3,1);_lcd_write_data(0xF);break;
                case 5:lcd_gotoxy(6,1);_lcd_write_data(0xF);break;
                case 6:lcd_gotoxy(9,1);_lcd_write_data(0xF);break;
                case 7:lcd_gotoxy(13,1);_lcd_write_data(0xF);break;
            }
}


void change_select_va(void){
switch (select){
                case 0:edit_mode[0]++;if(edit_mode[0]==25)edit_mode[0]=0;break;
                case 1:edit_mode[1]++;if(edit_mode[1]==61)edit_mode[1]=0;break;
                case 2:edit_mode[2]++;if(edit_mode[2]==61)edit_mode[2]=0;break;
                case 4:edit_mode[3]++;break;
                case 5:edit_mode[4]++;if(edit_mode[4]==13)edit_mode[4]=0;break;
                case 6:edit_mode[5]++;if(edit_mode[5]==32)edit_mode[5]=0;break;
            }               
            lcd_clear();
            sprintf(text,"%02d:%02d:%02d  Cancel14%02d/%02d/%02d   Ok",
                 edit_mode[0],edit_mode[1],edit_mode[2],
                 edit_mode[3],edit_mode[4],edit_mode[5]
                );
            lcd_puts(text); 
            change_select_po();
}



void saving_page(void){
    lcd_clear();
    
lcd_gotoxy(0,1) ;lcd_puts("Norouzi|Siahrang");  
    
lcd_gotoxy(0,0);lcd_puts("   Saving   ");
delay_ms(500);
lcd_gotoxy(0,0);lcd_puts("   Saving.  ");
delay_ms(500);
lcd_gotoxy(0,0);lcd_puts("   Saving.. ");
delay_ms(500);
lcd_gotoxy(0,0);lcd_puts("   Saving... ");
delay_ms(500);    
  
delay_ms(300);
}

void save_data(void){

    rtc_set_time(edit_mode[0],edit_mode[1],edit_mode[2]); 
    rtc_set_date(7,edit_mode[5],edit_mode[4],edit_mode[3]);   
    saving_page();
}
void canceling_page(void){
    lcd_clear();
    
lcd_gotoxy(0,1) ;lcd_puts("Norouzi|Siahrang");  
    
lcd_gotoxy(0,0);lcd_puts("   canceling   ");
delay_ms(500);
lcd_gotoxy(0,0);lcd_puts("   canceling.  ");
delay_ms(500);
lcd_gotoxy(0,0);lcd_puts("   canceling.. ");
delay_ms(500);
lcd_gotoxy(0,0);lcd_puts("   canceling... ");
delay_ms(500);    
  
delay_ms(300);
}


void main(void)
{


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 1 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x83;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);


DDRA = 0X00;

// ADC:
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// DS1307:
i2c_init();
rtc_init(0,0,0);

// LCD: 
lcd_init(16);
#asm("sei")



// Ports configur:
DDRD = 0XFF;
DDRA = 0X00;

// Pull Up:
PORTA.6=1;
PORTA.7=1;

// 7Seg shifter pins:
DDRC.2 = 1;
DDRC.3 = 1;
DDRC.4 = 1;
DDRC.5 = 1;



 rtc_get_time(&r_h, &r_m, &r_s);

//rtc_set_time(23,59,50);
//rtc_set_date(7,30,4,00);


lcd_clear();

lcd_gotoxy(0,1) ;lcd_puts("Norouzi|Siahrang");  
    
lcd_gotoxy(0,0);lcd_puts("   Starting   ");
delay_ms(500);
lcd_gotoxy(0,0);lcd_puts("   Starting.  ");
delay_ms(500);
lcd_gotoxy(0,0);lcd_puts("   Starting.. ");
delay_ms(500);
lcd_gotoxy(0,0);lcd_puts("   Starting... ");
delay_ms(500);    
  
delay_ms(300);

lcd_clear();

while (1)
      {  
        // Get time and date   
        rtc_get_time(&r_h, &r_m, &r_s);
        rtc_get_date(&r_wd,&r_D, &r_M,&r_Y ); 
            
        // Print template:                      
        temp = ((read_adc(0)/1024.0)*5000)/10 ;
        lcd_gotoxy(0,0); 
        sprintf(text,"%d\xdf\C",temp);
        lcd_puts(text);
                      
        // Print date:
        lcd_gotoxy(3,1); 
        sprintf(text,"14%02d/%02d/%02d",r_Y,r_M,r_D);
        lcd_puts(text);
                                    
        // Print time:
        lcd_gotoxy(7,0);  
        sprintf(text,"%02d:%02d:%02d",r_h,r_m,r_s);
        lcd_puts(text); 


        delay_ms(200);
        
         
        if(selectKey == 0){ // Menu button  // H:M:S | Y/M/D
        delay_ms(3000);
        if(selectKey == 0){
            edit_mode[0] = 0;
            edit_mode[1] = 0;
            edit_mode[2] = 0;
            edit_mode[3] = 0;
            edit_mode[4] = 0;
            edit_mode[5] = 0;

            edit_mode[0]=r_h;edit_mode[1]=r_m;edit_mode[2]=r_s;
            edit_mode[3]=r_Y;edit_mode[4]=r_M;edit_mode[5]=r_D;  
        
            lcd_clear();  
            sprintf(text,"%02d:%02d:%02d  Cancel14%02d/%02d/%02d   Ok",
                 edit_mode[0],edit_mode[1],edit_mode[2],
                 edit_mode[3],edit_mode[4],edit_mode[5]
                );
            lcd_puts(text);   
                              
            change_select_po();
            
            while(selectKey == 0);// Up key            
            
            while(1){
                if(selectKey == 0){select++;if(select==8)select=0;change_select_po();delay_ms(500);}
                if(ValueKey==0){
                    if(select==3){canceling_page();lcd_clear();break;}// Cancel
                    else if(select==7){save_data();lcd_clear();break;} // Save 
                    else{change_select_va();}
                    delay_ms(400);
                }
            }
        }
        
        
        
       } 
      }
}
