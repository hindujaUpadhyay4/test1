public class MetadataAPIUtility{
    
  @Future(callout=true)
  public static void createRemoteSiteSettings(){
         boolean isSucessfull=false;

        String Domain = URL.getOrgDomainUrl().getHost().split('\\.')[0];  
        String instanceName = [select InstanceName from Organization limit 1].InstanceName;
        
        String LWC_VF = 'https://' + Domain + '--vlocity-cmt.' + instanceName + '.visual.force.com';
        String LWC_LF= 'https://' + Domain + '.lightning.force.com';
        String LWC_VLF= 'https://' + Domain + '--vlocity-cmt.visualforce.com';
        String LWC_LVF = 'https://' + Domain + '--vlocity-cmt.vf.force.com';
        
        
        System.debug('Assigned Vars: ' + LWC_LVF);          
        Map<string,string> RemoteSiteMap = new Map<string,string>();
        //specify the remote site name and url in RemoteSiteMap
        RemoteSiteMap.put('LWC_VF',LWC_VF);
        RemoteSiteMap.put('LWC_LF',LWC_LF);
        RemoteSiteMap.put('LWC_LVF',LWC_LVF);
        RemoteSiteMap.put('LWC_VLF',LWC_VLF);
       //String PageURL1 = URL.getCurrentRequestUrl().toExternalForm();
        //RemoteSiteMap.put('FOR_REST_API_CALL',URL.getCurrentRequestUrl().toExternalForm());
        List<MetadataService.Metadata> allMetadataList = new List<MetadataService.Metadata>();
        for(string ss: RemoteSiteMap.keyset()){
            MetadataService.RemoteSiteSetting remoteSiteDetails = new MetadataService.RemoteSiteSetting();
            remoteSiteDetails.fullName = ss;
            remoteSiteDetails.description = ss+'-created through apex';
            remoteSiteDetails.disableProtocolSecurity  = false;
            remoteSiteDetails.isActive  = true;
            remoteSiteDetails.url=RemoteSiteMap.get(ss);
            allMetadataList.add(remoteSiteDetails);
            System.debug('Assigned Vars: ' + LWC_LVF);
        }        
        if(allMetadataList.size()>0){
            system.debug('****RemoteSiteSettings allMetadataList:'+allMetadataList);
            MetadataService.MetadataPort service = createService();
            List<MetadataService.UpsertResult> results = service.upsertMetadata(allMetadataList);
            for(MetadataService.UpsertResult result: results){
                    if(result.success){
                        system.debug('added remote site setting success='+result);
                        isSucessfull=true;
                    }else{
                        system.debug('****error while adding remote site settings:'+result.errors[0].message);
                    }

            }

        }
      
    }  
  
 /*   public static void insertAccount() {
        Account act = new Account(Name='Zabuza Corp Account');
        insert act;
    }*/
    
    public static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        PageReference reportPage = Page.SessionId;
        String sessionId = reportPage.getContent().toString();
        service.SessionHeader.sessionId = sessionId;
        return service;     
    }
}