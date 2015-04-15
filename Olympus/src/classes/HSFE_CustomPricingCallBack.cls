/* 
* Class Name  : HSFE_CustomPricingCallBack
* Description : Trigger Handler for the Product SObject, which implements all the logic.
* Created By  : Yunus H Navalur
* Created On  : 03/17/2015
*
* Modification log:
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                  Date                             Description
* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Yunus                    3/17/2015
* Gaurav Kumar             3/19/2015
* Yunus                    3/23/2015
*/



global with sharing class HSFE_CustomPricingCallBack implements Apttus_Config2.CustomClass.IPricingCallback2{ //
    
    private Apttus_Config2.ProductConfiguration cart = null;
    private Apttus_Config2.CustomClass.PricingMode mode = null;
    private Apttus_Config2__ProductConfiguration__c prodConfigSO = null;

    public HSFE_CustomPricingCallBack(){
        HSFE_Utility_Class.setAlreadyExecutedFalse();
    }

    
    /**
    * Callback to indicate the pricing mode
    * @param mode the pricing mode
    */
    global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
        system.debug('-CallBack-SetMode--Start--');
        this.mode = mode;
        system.debug('-CallBack-SetMode--End--');
    }
    
    
    /**
    * Callback at the beginning of the pricing call.
    * Use the start method to initialize state
    * @param cart the cart object
    */
    global void start(Apttus_Config2.ProductConfiguration cart) {
        system.debug('-CallBack-Start Method--Start--');
        this.cart = cart;
        prodConfigSO  = cart.getConfigSO();
        system.debug('-CallBack-Start Method--End--');
    }
    
    
    /**
    * Callback before pricing the line item collection
    * Use this method to do all required pre-processing to prepare the line items for pricing.
    * @param itemColl the line item collection to pre-process
    */
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        system.debug('-CallBack-beforePricing--Start--');        
        
        //Declaration - Section
        //List <Apttus_Config2.LineItem> allLines = cart.getLineItems();
        List <Apttus_Config2.LineItem> allLines = itemColl.getAllLineItems();
        List<Apttus_Config2__LineItem__c> liSOList = new List<Apttus_Config2__LineItem__c>();
        map<id,string> ProductChargeTypeMap = new map<id,String>();
        map<id,string> ProductConditionTypeMap = new map<id,String>();
        map<string,decimal> PricematricKey_TargetMap = new map<string,decimal>();
        map<id,boolean> ProductStockingFlagMap = new map<id,boolean>();
        Set<Id> attributeValueIds = new Set<Id>();
        List<Apttus_Config2__ProductAttributeValue__c> pavLst = new List<Apttus_Config2__ProductAttributeValue__c>();
        boolean Is_Stocking_Kit = false;
        boolean Is_Kit_In_A_Kit = false;
        String pcondition = null;
        
        //Logic Section
        //Getting the list of line items form the cart
        for(Apttus_Config2.LineItem line: allLines) {
            liSOList.add(line.getLineItemSO());
        }
        for(Apttus_Config2__LineItem__c litem : liSOList){ 
            if(!String.isEmpty(litem.Apttus_Config2__OptionId__c))
                ProductChargeTypeMap.put(litem.Apttus_Config2__OptionId__c,'');
            else
                ProductChargeTypeMap.put(litem.Apttus_Config2__ProductId__c,'');            
            litem.Apttus_Config2__PricingStatus__c = 'Pending';    
        }
        
        for(Product2 ProdRec : [Select id,HSFE_Charge_Type__c,Is_Stocking_Kit__c from product2 where id in: ProductChargeTypeMap.keySet()]){
            if(ProductChargeTypeMap.ContainsKey(ProdRec.id)){
                ProductChargeTypeMap.put(ProdRec.id,ProdRec.HSFE_Charge_Type__c);
                ProductStockingFlagMap.put(ProdRec.id, ProdRec.Is_Stocking_Kit__c);
            }
        }
        for(Apttus_Config2__LineItem__c litem : liSOList){
            //check if the product is setup as an option
            if(!String.isEmpty(litem.Apttus_Config2__OptionId__c)){
                Is_Stocking_Kit = ProductStockingFlagMap.get(litem.Apttus_Config2__ProductId__c);//take the main product stocking flag
                if(Is_Stocking_Kit){
                    Is_Kit_In_A_Kit = litem.HSFE_Is_Kit_In_A_Kit__c;//take the main product stocking flag
                    if(litem.Apttus_Config2__OptionGroupLabel__c == HSFE_Constant.COUSTOM_RECOMMENDED || 
                             litem.Apttus_Config2__OptionGroupLabel__c == HSFE_Constant.COUSTOM_OPTIONAL || 
                             litem.Apttus_Config2__OptionGroupLabel__c == HSFE_Constant.COUSTOM_MANDATORY ||
                             litem.Apttus_Config2__OptionGroupLabel__c == HSFE_Constant.COUSTOM_FREE_GOODS ||
                             Is_Kit_In_A_Kit){
                            litem.Charge_Type__c = ProductChargeTypeMap.get(litem.Apttus_Config2__OptionId__c);
                            if(String.isEmpty(litem.Product_Conditions__c)){
                                pcondition = HSFE_Utility_Class.constantCategoryMap.get(litem.Charge_Type__c);
                                if(!String.isEmpty(pcondition)){
                                    litem.Product_Conditions__c = pcondition;
                                }else{
                                    litem.Product_Conditions__c = HSFE_Constant.COUSTOM_NEW;
                                }
                            }                            
                    }else{
                        litem.Charge_Type__c = HSFE_Constant.CHARGE_TYPE_KIT_OP;
                        litem.Product_Conditions__c = HSFE_Constant.NA_STOCKING_KIT;
                    }
                }else{                    
                    litem.Charge_Type__c = ProductChargeTypeMap.get(litem.Apttus_Config2__OptionId__c);
                    
                    if(String.isEmpty(litem.Product_Conditions__c)){
                        pcondition = HSFE_Utility_Class.constantCategoryMap.get(litem.Charge_Type__c);
                        if(!String.isEmpty(pcondition)){
                            litem.Product_Conditions__c = pcondition;
                        }else{
                            litem.Product_Conditions__c = HSFE_Constant.COUSTOM_NEW;
                        }
                    }                    
                }
            } 
            //Defaulting Product_Conditions__c  to "New".
            if(String.isEmpty(litem.Apttus_Config2__OptionId__c)){
                litem.Charge_Type__c = ProductChargeTypeMap.get(litem.Apttus_Config2__ProductId__c);
                if(String.isEmpty(litem.Product_Conditions__c)){
                    pcondition = HSFE_Utility_Class.constantCategoryMap.get(litem.Charge_Type__c);
                    if(!String.isEmpty(pcondition)){
                        litem.Product_Conditions__c = pcondition;
                    }else{
                        litem.Product_Conditions__c = HSFE_Constant.COUSTOM_NEW;
                    }
                }
            }
            if(HSFE_Constant.CUSTOM_SKIP_ADJUSTMENT.contains(litem.Product_Conditions__c))
                litem.Apttus_Config2__AllowManualAdjustment__c = false;    
            PricematricKey_TargetMap.put(litem.Apttus_Config2__PriceListItemId__c+litem.Product_Conditions__c,0.0);
        }
        for(Apttus_Config2__PriceMatrixEntry__c MatrixRec : [select id,HSFE_Target_Price__c,HSFE_Combination_Key__c from Apttus_Config2__PriceMatrixEntry__c where HSFE_Combination_Key__c in: PricematricKey_TargetMap.KeySet()]){
            If(PricematricKey_TargetMap.ContainsKey(MatrixRec.HSFE_Combination_Key__c))
                PricematricKey_TargetMap.put(MatrixRec.HSFE_Combination_Key__c,MatrixRec.HSFE_Target_Price__c);
        }
        
        for(Apttus_Config2__LineItem__c litem : liSOList){
            if(String.isEmpty(litem.Apttus_Config2__OptionId__c)){
                if(PricematricKey_TargetMap.ContainsKey(litem.Apttus_Config2__PriceListItemId__c+litem.Product_Conditions__c))
                    litem.HSFE_Target_Price__c = PricematricKey_TargetMap.get(litem.Apttus_Config2__PriceListItemId__c+litem.Product_Conditions__c);                
            }else if(!String.isEmpty(litem.Apttus_Config2__OptionId__c)){
                if(ProductStockingFlagMap.get(litem.Apttus_Config2__ProductId__c)){
                    if(litem.Apttus_Config2__OptionGroupLabel__c == HSFE_Constant.COUSTOM_RECOMMENDED || 
                             litem.Apttus_Config2__OptionGroupLabel__c == HSFE_Constant.COUSTOM_OPTIONAL || 
                             litem.Apttus_Config2__OptionGroupLabel__c == HSFE_Constant.COUSTOM_MANDATORY ||
                             litem.Apttus_Config2__OptionGroupLabel__c == HSFE_Constant.COUSTOM_FREE_GOODS){
                             
                        if(PricematricKey_TargetMap.ContainsKey(litem.Apttus_Config2__PriceListItemId__c+litem.Product_Conditions__c))
                            litem.HSFE_Target_Price__c = PricematricKey_TargetMap.get(litem.Apttus_Config2__PriceListItemId__c+litem.Product_Conditions__c);                             
                    }else{
                        litem.HSFE_Target_Price__c = 0.0;
                    }        
                }else{
                    if(PricematricKey_TargetMap.ContainsKey(litem.Apttus_Config2__PriceListItemId__c+litem.Product_Conditions__c))
                        litem.HSFE_Target_Price__c = PricematricKey_TargetMap.get(litem.Apttus_Config2__PriceListItemId__c+litem.Product_Conditions__c);                
                }
            }else{
                //no logic
            }
        }
        system.debug('-CallBack-beforePricing--End--');     
    }
    
    
    /**
    * Callback before pricing the given line item in the line item collection
    * Use this method to do all required pre-processing to prepare the line item for pricing.
    * @param itemColl the line item collection holding the line item
    * @param lineItemMO the line item to pre-process
    */
    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
        system.debug('-CallBack-beforePricingLineItem--Method-*-');
        if (Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT == mode) {
            calculateTerm(cart.getLineItems());
        }        
    }
    
    
    /**
    * Callback after pricing the given line item in the line item collection
    * Use this method to do all required post-processing after the line item is priced
    * @param itemColl the line item collection holding the line item
    * @param lineItemMO the line item to post-process
    */
    global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemColl, Apttus_Config2.LineItem lineItemMO) {
        system.debug('-CallBack-afterPricingLineItem--Method-*-');   
    }
    
    
    /**
    * Callback after pricing the line item collection
    * Use this method to do all required post-processing after line items are priced.
    * @param itemColl the line item collection to post-process
    * This method will validate pricing business rules for renewals and calculate Customer Price, Discount on line item 
    */
    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        system.debug('-CallBack-afterPricing--Start--'); 
        
        //Declaration - Section
        system.debug('-CallBack-afterPricing--ignored--');  
        List <Apttus_Config2.LineItem> allLines = itemColl.getAllLineItems();
        List<Apttus_Config2__LineItem__c> liSOList = new List<Apttus_Config2__LineItem__c>(); 
        
        //Logic Section
        //Getting the list of line items form the cart and setting has setAlreadyExecuted to true
        for(Apttus_Config2.LineItem line: allLines) {
            liSOList.add(line.getLineItemSO());
        }
        for(Apttus_Config2__LineItem__c litem : liSOList){ 
            system.debug(HSFE_Utility_Class.hasAlreadyExecuted() + '-CallBack-afterPricing--'+litem.Apttus_Config2__PricingStatus__c);
            if (!HSFE_Utility_Class.hasAlreadyExecuted() && litem.Apttus_Config2__PricingStatus__c == 'Pending') {  
                HSFE_Utility_Class.setAlreadyExecuted(); 
            }  
        } 
               
        system.debug('-CallBack-afterPricing--End--');     
    }
    
    
    /**
    * Callback after all batches of line items are processed
    * Use the finish method to release state
    */
    global void finish() {
        system.debug('-CallBack-finish--Method-*-');      
    }
    
    /**
    *calculateTerm: Calculates term on cart.
    */
    private void calculateTerm(List<Apttus_Config2.LineItem> allLines) {
        system.debug('-CallBack-calculateTerm--Method-*-');
    }

}