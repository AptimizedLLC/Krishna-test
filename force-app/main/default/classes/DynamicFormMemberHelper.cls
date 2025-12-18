public class DynamicFormMemberHelper {

    public String rOptions {
        get; set;
    }
    
    public String rawValue {
        get; set;
    }
    
    public String rawYesOption {
        get; set;
    }
    
    public String morphedValue {
        get {
            if (rawValue == rawYesOption) {
                return 'Y';
            } else if (String.isNotBlank(rawValue)) {
            	return 'N';            
            } else {
                return '#N/A';
            }
        }
        set;
    }
    
    public List<String> splittedOptions {
        get {
            if (rOptions == null) {
                return new List<String>();
            }
            splittedOptions = new List<String>();
            for (String x: rOptions.split(','))  {
                splittedOptions.add(x.trim());
            }
            return splittedOptions;
        }
        set;
    }   
}