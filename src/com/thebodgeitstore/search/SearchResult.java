package com.thebodgeitstore.search;

//Author: Doug Logan
//Email: dlogan@CyberNinjas.com

public class SearchResult {
    private String product = "";
    private String desc = "";
    private String type = "";
    private String price = "";
    
    //Constructors
    public SearchResult(){}
    
    public SearchResult(String prod, String des, String typ, String pric){
        this.product = prod;
        this.desc = des;
        this.type = typ;
        this.price = pric;      
    }
   
    //Checks to see if the val in question exists in ANY value
    public boolean checkIfValExists(String value){
        String[] targets = {this.product, this.desc, this.type, this.price};
        for(String target : targets){
            if(target.toLowerCase().indexOf(value.toLowerCase()) > -1)
                return true;
        }
        return false; 
    }
    
    //Returns the appropriate JSON for a single entry.
    public String getJSON(){
        String json = "{ \"product\": \"".concat(this.product).concat("\", \"desc\": \"") 
                            .concat(this.desc).concat("\", \"type\": \"")
                            .concat(this.type).concat("\", \"price\": \"") 
                            .concat(this.price).concat("\"}");
        return json;
    }
    
    //Returns a TR to be used in the HTML output.
    public String getTrHTML(){
        return       "<TR><TD>" + this.product + "</TD><TD>" + this.desc + 
                     "</TD><TD>" + this.type + "</TD><TD>" + this.price + "</TD></TR>\n";
    }
    
    //Returns the product value
    public String getProduct(){
        return this.product;
    }
    
    //Returns the description
    public String getDesc(){
        return this.desc;
    }
    
    //Returns the type
    public String getType(){
        return this.type;
    }
    
    //Returns the Price
    public String getPrice(){
        return this.price;
    }
    
    //Set Entries
    public void setProduct(String prod){
        this.product = prod;
    }
    public void setDesc(String des){
        this.desc = des;
    }
    public void setType(String typ){
        this.type = typ;
    }
    public void setPrice(String pric){
        this.price = pric;
    }
    
    
    
    
}
