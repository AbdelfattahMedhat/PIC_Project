#line 1 "E:/#IMPORTANT#/#Embedded/Work/PIC/Project/ourproject2.c"
#line 35 "E:/#IMPORTANT#/#Embedded/Work/PIC/Project/ourproject2.c"
unsigned short int const
seg[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7C,0x07,0x7F,0x67 };

volatile unsigned char ball_counter =0;
volatile unsigned char digit1 =0;
volatile unsigned char digit2 =0;
volatile unsigned char box =0;
unsigned char timer0_int_counter =0;
unsigned char SSD_select_counter =0;
unsigned char belt_flag = (1) ;

void interrupt()
{


 if (TMR0IF_bit == 1)
 {
 TMR0= ((255)-(195)) ;
 if (++timer0_int_counter ==  (40) )
 {
 if(belt_flag ==  (0)  )
 {
  (portc.b1)  =  (0) ;
  (portb.b5)  =  (1) ;
  (portc.b0)  =  (0)  ;
 belt_flag =  (1) ;
 }
 else if(belt_flag ==  (1)  )
 {
  (portc.b1)  =  (1) ;
  (portb.b5)  =  (0) ;
  (portc.b0)  =  (1) ;
 }

  (portb.b1)  = (portb.b1) ^ (1) ;
 timer0_int_counter = 0;

 }
 TMR0IF_bit=0;
 }

if (intf_bit==1 )
 {
 ball_counter++;
 digit1=ball_counter % 10;
 digit2=ball_counter/10;
 if(ball_counter >=  (20) )
 {
 ball_counter = 0;
 box++;
 if(box >=  (3) )
 {
 box = 0;
 }
 }
 intf_bit=0;
 }


}

void main()
{


trisb =0b00000101;

trisd =0;
portd =0;

trisc = 0;

option_reg = 0b00000111;
TMR0 = ((255)-(195)) ;

intcon = 0b11110000;

while (1)
{
 {
 while(box <=  (3) )
 {
 SSD_select_counter++;
 if (SSD_select_counter ==  (0)  )
 {
  (portb.b6)  = (0) ;
 portd =seg[digit1];
  (portb.b3)  = (1) ;
  (portb.b4)  = (0) ;
 delay_ms(5);
 }
 else if(SSD_select_counter ==  (1)  )
 {

  (portb.b3)  = (0) ;
 portd =seg[digit2];
  (portb.b4)  = (1) ;
  (portb.b6)  = (0) ;
 delay_ms(5);
 }
 else if(SSD_select_counter ==  (2)  )
 {

  (portb.b3)  = (0) ;
  (portb.b4)  = (0) ;
 portd =seg[box];
  (portb.b6)  = (1) ;
 delay_ms(5);
 SSD_select_counter =  (0) ;
 }
 if ( (portb.b2)  ==  ( (0) ) )
 {
 belt_flag =  (0) ;
 }
 }
 }
 }
}
