/*********************************************************************************************************
* 
* @ Name            :   DRL_OpportunityTriggerHelper
* @ Author          :   Deeksha Suvarna
* @ Usage           :   To Calculate Influence Percentage in Campaign Influence Record.
*
*   Date            |  Developer Name                |  Version      |  Changes
* ========================================================================================================
*  21-11-2022       |  deeksha.suvarna@absyz.com     |  1.0          |  Initial version
*********************************************************************************************************/
public class DRL_OpportunityTriggerHelper {
    
    public static void CalculateInfluencePercentage(Opportunity objOpportunity, Opportunity objOldOpportunity, Boolean blnIsLeadConverted, Boolean blnSourceCampaignPresent) {
        Map<String, DRL_CampaignInfluenceConfiguration__mdt> map_CampaignInfluenceConfigurationByLabel = new Map<String, DRL_CampaignInfluenceConfiguration__mdt>();
        Map<Decimal, DRL_CampaignInfluenceConfiguration__mdt> map_CampaignInfluenceConfigurationBySortOrder = new Map<Decimal, DRL_CampaignInfluenceConfiguration__mdt>();
        Map<String, DRL_CampaignInfluenceConfiguration__mdt> map_CampaignInfluenceConfigurationByLabelLeadConverted = new Map<String, DRL_CampaignInfluenceConfiguration__mdt>();
        
        for (DRL_CampaignInfluenceConfiguration__mdt objCampaignInfluenceConfiguration : DRL_CampaignInfluenceConfiguration__mdt.getAll().values()) {
            if (objCampaignInfluenceConfiguration.IsLeadConversion__c == true ) {
                map_CampaignInfluenceConfigurationByLabelLeadConverted.put(objCampaignInfluenceConfiguration.Label, objCampaignInfluenceConfiguration);
            }
            else {
                map_CampaignInfluenceConfigurationByLabel.put(objCampaignInfluenceConfiguration.Label,objCampaignInfluenceConfiguration);
            	map_CampaignInfluenceConfigurationBySortOrder.put(objCampaignInfluenceConfiguration.SortOrder__c,objCampaignInfluenceConfiguration);
            }  
        }
        
        if (objOldOpportunity == null) {
            Integer intTempInfluenceWeightage = 0;
            
            if (map_CampaignInfluenceConfigurationByLabel.containsKey(objOpportunity.StageName)) {
                for (Decimal intSortOrder = 1 ; intSortOrder <= map_CampaignInfluenceConfigurationByLabel.get(objOpportunity.StageName).SortOrder__c; intSortOrder++) {
                    if (blnIsLeadConverted && blnSourceCampaignPresent && map_CampaignInfluenceConfigurationBySortOrder.get(intSortOrder).Label == 'Lead Generation' ) {
                        intTempInfluenceWeightage = Integer.valueOf(map_CampaignInfluenceConfigurationByLabelLeadConverted.get('Source Campaign').Weightage__c);
                        System.debug('1) SourceCampaignWeightage :'+intTempInfluenceWeightage);   
                        continue;
                    }
                    intTempInfluenceWeightage = intTempInfluenceWeightage + Integer.valueof(map_CampaignInfluenceConfigurationBySortOrder.get(intSortOrder).Weightage__c);
                    System.debug('1) TempInfluenceWeightage :'+intTempInfluenceWeightage);
                }
                System.debug('1) FinalTempInfluenceWeightage :'+intTempInfluenceWeightage);  
            }
            else {
                for ( Decimal intSortOrder = 1 ; intSortOrder <=map_CampaignInfluenceConfigurationBySortOrder.size(); intSortOrder++) {
                    if (blnIsLeadConverted && map_CampaignInfluenceConfigurationBySortOrder.get(intSortOrder).Label == 'Lead Generation') {
                        intTempInfluenceWeightage = Integer.valueOf(map_CampaignInfluenceConfigurationByLabelLeadConverted.get('Source Campaign').Weightage__c);
                        System.debug('2) SourceCampaignWeightage :'+intTempInfluenceWeightage);
                        continue;
                    }	
                   	intTempInfluenceWeightage = intTempInfluenceWeightage + Integer.valueof(map_CampaignInfluenceConfigurationBySortOrder.get(intSortOrder).Weightage__c);
                    System.debug('2) TempInfluenceWeightagebeyondmetadata :'+intTempInfluenceWeightage);
                }
                System.debug('2) FinalTempInfluenceWeightagebeyondmetadata :'+intTempInfluenceWeightage);
            }
        }
        else {
            Integer intTempInfluenceWeightage = 0;
            
            if (map_CampaignInfluenceConfigurationByLabel.containsKey(objOpportunity.StageName)) {
                for ( Decimal intSortOrder = map_CampaignInfluenceConfigurationByLabel.get(objOldOpportunity.StageName).SortOrder__c+1 ; intSortOrder <= map_CampaignInfluenceConfigurationByLabel.get(objOpportunity.StageName).SortOrder__c; intSortOrder++) {
					intTempInfluenceWeightage = intTempInfluenceWeightage + Integer.valueof(map_CampaignInfluenceConfigurationBySortOrder.get(intSortOrder).Weightage__c);
                    System.debug('3) TempInfluenceWeightageOlpOpp :'+intTempInfluenceWeightage);
                }
                System.debug('3) FinalTempInfluenceWeightageOldOpp :'+intTempInfluenceWeightage);    
            }
            else {
                for ( Decimal intSortOrder = map_CampaignInfluenceConfigurationByLabel.get(objOldOpportunity.StageName).SortOrder__c+1; intSortOrder <= map_CampaignInfluenceConfigurationBySortOrder.size(); intSortOrder++ ) {
                    intTempInfluenceWeightage = intTempInfluenceWeightage + Integer.valueof(map_CampaignInfluenceConfigurationBySortOrder.get(intSortOrder).Weightage__c);
                    System.debug('4) TempInfluenceWeightageOldOppBeyondMetadata :'+intTempInfluenceWeightage);
                }
                System.debug('4) FinalTempInfluenceWeightageOldOppBeyondMetadata :'+intTempInfluenceWeightage);
            }
        }
    }
}