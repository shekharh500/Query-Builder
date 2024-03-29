global class LongRange {

    private Long min;
    private Long max;
    
    global LongRange(Long number1){
        if(number1 == null){
            throw new IllegalArgumentException('illegal argument: null number');
        }
        min = max = number1;
    } 
    global LongRange(Long number1, Long number2){
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
    
    global Long max(){ return max; }
    global Long min(){ return min;}
    global String toAString(){ return '[' + min + ',' + max + ']'; }
    global Boolean contains(Long value){ return min <= value && value <= max; }
    global Boolean contains(LongRange value){ return min <= value.min() && value.max() <= max; }
    global Boolean overlaps(LongRange value){ return min <= value.max() && value.min() <= max; }

}