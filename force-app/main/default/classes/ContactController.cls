public with sharing class ContactController {
    /**
     * Get list of contacts for display
     * @return List of Contact records
     */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        try {
            return [
                SELECT Id, Name, Email, Phone, Account.Name
                FROM Contact
                WHERE IsDeleted = false
                WITH SECURITY_ENFORCED
                ORDER BY Name
                LIMIT 50
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving contacts: ' + e.getMessage());
        }
    }
    
    /**
     * Create a new contact
     * @param firstName First name of contact
     * @param lastName Last name of contact  
     * @param email Email address
     * @return Id of created contact
     */
    @AuraEnabled
    public static Id createContact(String firstName, String lastName, String email) {
        try {
            if (String.isBlank(firstName) || String.isBlank(lastName)) {
                throw new AuraHandledException('First name and last name are required');
            }
            
            Contact newContact = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email
            );
            
            insert newContact;
            return newContact.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating contact: ' + e.getMessage());
        }
    }
}