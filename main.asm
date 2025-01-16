.include "m328pdef.inc"
		.equ treshold = (0x0190)
stacksetup:
          ldi   r16, high(RAMEND)
          out   SPH, r16
          ldi   r16, low(RAMEND)
          out   SPL, r16

setup:
          ldi   r16, (1<<PB0)
          out   DDRB, r16


          ldi   r16, (1<<REFS0)
          sts   ADMUX, r16           
          ldi   r16, (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)
          sts   ADCSRA, r16          

start_adc:

          ldi   r16, (1<<REFS0)
          sts   ADMUX, r16          
          lds   r16, ADCSRA
          ori   r16, (1<<ADSC)
          sts   ADCSRA, r16

main_loop:
          lds   r16, ADCSRA
          sbrs  r16, ADIF
          rjmp  main_loop
          lds   r16, ADCSRA
          andi  r16, ~(1<<ADIF)
          sts   ADCSRA, r16


          lds   r16, ADCL           
          lds   r17, ADCH           

          ldi   r18, LOW(treshold)          
          ldi   r19, HIGH(treshold)         
          cp    r16, r18            
          cpc   r17, r19            
          brlo  buzzer_on           

buzzer_off:
          cbi   PORTB, PB0
          rjmp  start_adc

buzzer_on:
          sbi   PORTB, PB0
          rjmp  start_adc
