@isTest
public class AccountControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 1; i <= 5; i++) {
            testAccounts.add(new Account(
                Name = 'Test Account ' + i,
                Type = 'Customer',
                Industry = 'Technology'
            ));
        }
        insert testAccounts;
    }
    
    @isTest
    static void testGetAccounts() {
        Test.startTest();
        List<Account> accounts = AccountController.getAccounts();
        Test.stopTest();
        
        System.assertNotEquals(null, accounts, 'Accounts list should not be null');
        System.assertEquals(5, accounts.size(), 'Should return 5 test accounts');
        System.assertEquals('Test Account 1', accounts[0].Name, 'First account name should match');
    }
    
    @isTest
    static void testCreateAccount() {
        Test.startTest();
        Id accountId = AccountController.createAccount('New Test Account', 'Prospect');
        Test.stopTest();
        
        System.assertNotEquals(null, accountId, 'Account ID should not be null');
        
        Account createdAccount = [SELECT Id, Name, Type FROM Account WHERE Id = :accountId];
        System.assertEquals('New Test Account', createdAccount.Name, 'Account name should match');
        System.assertEquals('Prospect', createdAccount.Type, 'Account type should match');
    }
    
    @isTest
    static void testCreateAccountException() {
        Test.startTest();
        try {
            // Try to create account with null name (should cause exception)
            AccountController.createAccount(null, 'Customer');
            System.assert(false, 'Exception should have been thrown');
        } catch (AuraHandledException e) {
            // AuraHandledException was thrown as expected
            System.assertNotEquals(null, e.getMessage(), 'Exception message should not be null');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetAccountStatistics() {
        // Get baseline counts before creating test data
        Map<String, Integer> baselineStats = AccountController.getAccountStatistics();
        Integer baselineTotal = baselineStats.get('totalAccounts') != null ? baselineStats.get('totalAccounts') : 0;
        Integer baselineCustomer = baselineStats.get('CustomerAccounts') != null ? baselineStats.get('CustomerAccounts') : 0;
        Integer baselineProspect = baselineStats.get('ProspectAccounts') != null ? baselineStats.get('ProspectAccounts') : 0;
        
        // Create test data
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Customer Account 1', Type = 'Customer'),
            new Account(Name = 'Test Customer Account 2', Type = 'Customer'),
            new Account(Name = 'Test Prospect Account 1', Type = 'Prospect')
        };
        insert testAccounts;
        
        Test.startTest();
        Map<String, Integer> stats = AccountController.getAccountStatistics();
        Test.stopTest();
        
        // Verify statistics - check for increases from baseline
        System.assertNotEquals(null, stats, 'Statistics should not be null');
        System.assertEquals(baselineTotal + 3, stats.get('totalAccounts'), 'Total accounts should increase by 3');
        System.assertEquals(baselineCustomer + 2, stats.get('CustomerAccounts'), 'Customer accounts should increase by 2');
        System.assertEquals(baselineProspect + 1, stats.get('ProspectAccounts'), 'Prospect accounts should increase by 1');
    }
}