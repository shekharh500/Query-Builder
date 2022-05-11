global class DecimalRange{

    private Decimal min;
    private Decimal max;
    
    global DecimalRange(Decimal number1){
        if(number1 == null){
            throw new IllegalArgumentException('illegal argument: null number');
        }
        min = max = number1;
    } 
    global DecimalRange(Decimal number1, Decimal number2){
        if(number1 == null || number2 == null){
            throw new IllegalArgumentException('illegal argument: null number');
        }
        if(number1 < number2){
            min = number1;
            max = number2;    
        } else {
            min = number2;
            max = number1;    
        }
    }
    
    global Decimal max(){ return max; }
    global Decimal min(){ return min;}
    global String toAString(){ return '[' + min + ',' + max + ']'; }
    global Boolean contains(Decimal value){ return min <= value && value <= max; }
    global Boolean contains(DecimalRange value){ return min <= value.min() && value.max() <= max; }
    global Boolean overlaps(DecimalRange value){ return min <= value.max() && value.min() <= max; }

}