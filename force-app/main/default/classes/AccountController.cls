public with sharing class AccountController {
    /**
     * Get list of accounts for display
     * @return List of Account records
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        try {
            return [
                SELECT Id, Name, Type, Industry, Phone, Website
                FROM Account
                WHERE IsDeleted = false
                WITH SECURITY_ENFORCED
                ORDER BY Name
                LIMIT 50
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving accounts: ' + e.getMessage());
        }
    }
    
    /**
     * Create a new account
     * @param accountName Name for the new account
     * @param accountType Type of the account
     * @return Id of the created account
     */
    @AuraEnabled
    public static Id createAccount(String accountName, String accountType) {
        try {
            Account newAccount = new Account(
                Name = accountName,
                Type = accountType
            );
            
            insert newAccount;
            return newAccount.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating account: ' + e.getMessage());
        }
    }
}