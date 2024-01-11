#define LOGIC_LOW                            (0)
#define LOGIC_HIGH                           (1)

#define PRESSED                              (LOGIC_LOW)
#define NOT_PRESSED                          (LOGIC_HIGH)

#define BELT_STOP                            (0)
#define BELT_RUN                             (1)

#define BOX_MAX_NUM                          (3)
#define BALL_MAX_NUM                         (20)
#define TIMER0_PER_SEC                       (40)
#define TIMER0_OVF_VALUE(x)                  ((255)-(x))

#define SSD_DIGIT1_PIN                    (portb.b3)
#define SSD_DIGIT2_PIN                    (portb.b4)
#define SSD_BOX_PIN                       (portb.b6)

#define SSD_DIGIT_BALL_1                     (0)
#define SSD_DIGIT_BALL_2                     (1)
#define SSD_DIGIT_BOXS                       (2)

#define SSD_DELAY_SCREEN                     (20)
#define ARM_MOTOR_START_PIN             (portb.b2) 
#define ARM_MOTOR_PIN                   (portb.b5)

#define LED_INDECATOR_PIN                 (portb.b1)
#define BELT_MOTOR_PIN                    (portc.b1)
#define SYSTEM_CYCLE_START_PIN            (portc.b2)
#define LED_BELT_STATE_PIN                (portc.b0)
/* IR PIN MAP */
#define IR_DIGITAL_OUT_PIN                (portc.b5)

                 /* SSD ARRAY*/
unsigned short int const
seg[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7C,0x07,0x7F,0x67 };

volatile unsigned char ball_counter          =0; 
volatile unsigned char digit1                =0;
volatile unsigned char digit2                =0;
volatile unsigned char box                   =0;
unsigned char timer0_int_counter             =0;
unsigned char SSD_select_counter             =0;
unsigned char belt_flag                      =BELT_RUN;

void interrupt()
{
                          /*Timer0 INT*/

   if (TMR0IF_bit == 1)
   {
      TMR0=TIMER0_OVF_VALUE(195); // number of tick for ovf interrupt
   if (++timer0_int_counter == TIMER0_PER_SEC) 
      { 
         if(belt_flag == BELT_STOP )
         {
            BELT_MOTOR_PIN       = LOGIC_LOW;
            ARM_MOTOR_PIN        = LOGIC_HIGH;
            LED_BELT_STATE_PIN   = LOGIC_LOW  ;
            belt_flag            = BELT_RUN;
         }
         else if(belt_flag == BELT_RUN )
         {
            BELT_MOTOR_PIN       = LOGIC_HIGH;
            ARM_MOTOR_PIN        = LOGIC_LOW;
            LED_BELT_STATE_PIN   = LOGIC_HIGH;
         }

         LED_INDECATOR_PIN    =LED_INDECATOR_PIN^LOGIC_HIGH;
         timer0_int_counter   = 0;
         
      }
      TMR0IF_bit=0;
   }
                       /*EXT_INT (Push botton)*/
if (intf_bit==1 )     // high when set ground on ex_int
   {
    ball_counter++;
    digit1=ball_counter % 10;
    digit2=ball_counter/10;
    if(ball_counter >= BALL_MAX_NUM)
    {
      ball_counter = 0;
      box++;
      if(box >= BOX_MAX_NUM)
      {
         box = 0;
      }
    }
    intf_bit=0;
   }

 
}

void main() 
{
/*System init*/
// port b
trisb             =0b00000101;                              // init REG B with bin (0,2) inputs and remain are output
// port d
trisd             =0;                              // init REG D all output 
portd             =0;                              // init REG D all Low 
// port c
trisc             = 0;                             // init REG D all output & init input pin 5 of IR sensor
// timer0
option_reg        = 0b00000111;                    //set timer0 prescaler as 256
TMR0              =TIMER0_OVF_VALUE(195);          // timer init with ovf int after 195 tick
// interrupts
intcon            = 0b11110000;                    // Enable interrupts
/*super loop*/
while (1)
{
  {
      while(box <= BOX_MAX_NUM)
       {
        SSD_select_counter++; 
        if (SSD_select_counter      == SSD_DIGIT_BALL_1 )  // done
        {
            SSD_BOX_PIN    =LOGIC_LOW;
            portd          =seg[digit1];
            SSD_DIGIT1_PIN =LOGIC_HIGH;
            SSD_DIGIT2_PIN =LOGIC_LOW;
            delay_ms(5);
        }
        else if(SSD_select_counter  == SSD_DIGIT_BALL_2 ) // done
        {
            
            SSD_DIGIT1_PIN =LOGIC_LOW;
            portd          =seg[digit2];
            SSD_DIGIT2_PIN =LOGIC_HIGH;
            SSD_BOX_PIN    =LOGIC_LOW;
            delay_ms(5);
        }
        else if(SSD_select_counter  == SSD_DIGIT_BOXS ) // done
        {
            
            SSD_DIGIT1_PIN    =LOGIC_LOW;
            SSD_DIGIT2_PIN     =LOGIC_LOW;
            portd		          =seg[box];            
            SSD_BOX_PIN        =LOGIC_HIGH;
            delay_ms(5);
            SSD_select_counter = SSD_DIGIT_BALL_1;
        }
        if (ARM_MOTOR_START_PIN == PRESSED)
            {
               belt_flag       = BELT_STOP;
            }
       }
   }
  }
}

  
