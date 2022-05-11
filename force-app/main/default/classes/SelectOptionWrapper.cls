global class SelectOptionWrapper{
	global SelectOption selectOption{get;set;}
	global SelectOptionWrapper(SelectOption selectOption){
		this.selectOption = selectOption;
	}
}