global class ImageController {
    
    @AuraEnabled
    global static String saveImageAttachment(String imageUrl, String recordId) {
         try {
			// Save in Attachment            
            Attachment attchment = new Attachment();
            attchment.ParentID = recordId;
            attchment.Body = EncodingUtil.base64Decode(imageUrl.substring(imageUrl.indexOf(',') + 1));
            attchment.contentType = 'image/png';
            attchment.Name=recordId+'.png';
            attchment.OwnerId = UserInfo.getUserId();
            insert attchment;
            return 'success';
            
        }catch(Exception e){
            system.debug('---------- ' + e.getMessage());
            return JSON.serialize(e.getMessage());
        }
    }
    @AuraEnabled
    global static String saveImageFile(String imageUrl, String recordId) {
        try {
          
            // Create Salesforce File
            //Insert ContentVersion
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; 
            cVersion.PathOnClient = recordId+'.png';
            cVersion.Origin = 'H';
            cVersion.OwnerId = UserInfo.getUserId();
            cVersion.Title = recordId+'.png';
            cVersion.VersionData = EncodingUtil.base64Decode(imageUrl.substring(imageUrl.indexOf(',') + 1));
            Insert cVersion;
            
            //After saved the Content Verison, get the ContentDocumentId
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;
            cDocLink.LinkedEntityId = recordId;
            cDocLink.ShareType = 'I';
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            Insert cDocLink;
            return 'success';
            
        }catch(Exception e){
            system.debug('---------- ' + e.getMessage());
            return JSON.serialize(e.getMessage());
        }
    }
}