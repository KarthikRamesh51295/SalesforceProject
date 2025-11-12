public with sharing class AccountController {
    /**
     * Get list of accounts for display
     * @return List of Account records
     * Updated: Project rerun demonstration
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
            if (String.isBlank(accountName)) {
                throw new AuraHandledException('Account name is required');
            }
            
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
    
    /**
     * Get account statistics for dashboard
     * Demo method for interview pipeline demonstration
     * @return Map with account statistics
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getAccountStatistics() {
        try {
            Map<String, Integer> stats = new Map<String, Integer>();
            
            // Total accounts
            stats.put('totalAccounts', [SELECT COUNT() FROM Account WITH SECURITY_ENFORCED]);
            
            // Accounts by type
            for (AggregateResult ar : [
                SELECT Type, COUNT(Id) total 
                FROM Account 
                WHERE Type != null 
                WITH SECURITY_ENFORCED
                GROUP BY Type
            ]) {
                String accountType = (String) ar.get('Type');
                Integer count = (Integer) ar.get('total');
                stats.put(accountType + 'Accounts', count);
            }
            
            return stats;
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving account statistics: ' + e.getMessage());
        }
    }
}