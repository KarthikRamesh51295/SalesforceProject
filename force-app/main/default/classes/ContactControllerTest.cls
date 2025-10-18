@isTest
public class ContactControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test contacts
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 1; i <= 3; i++) {
            testContacts.add(new Contact(
                FirstName = 'Test' + i,
                LastName = 'Contact' + i,
                Email = 'test' + i + '@example.com'
            ));
        }
        insert testContacts;
    }
    
    @isTest
    static void testGetContacts() {
        Test.startTest();
        List<Contact> contacts = ContactController.getContacts();
        Test.stopTest();
        
        System.assertNotEquals(null, contacts, 'Contacts list should not be null');
        System.assertEquals(3, contacts.size(), 'Should return 3 test contacts');
        System.assertEquals('Test1', contacts[0].FirstName, 'First contact first name should match');
    }
    
    @isTest
    static void testCreateContact() {
        Test.startTest();
        Id contactId = ContactController.createContact('John', 'Doe', 'john.doe@example.com');
        Test.stopTest();
        
        System.assertNotEquals(null, contactId, 'Contact ID should not be null');
        
        Contact createdContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId];
        System.assertEquals('John', createdContact.FirstName, 'First name should match');
        System.assertEquals('Doe', createdContact.LastName, 'Last name should match');
        System.assertEquals('john.doe@example.com', createdContact.Email, 'Email should match');
    }
    
    @isTest
    static void testCreateContactException() {
        Test.startTest();
        try {
            ContactController.createContact(null, 'Doe', 'test@example.com');
            System.assert(false, 'Exception should have been thrown');
        } catch (AuraHandledException e) {
            System.assertNotEquals(null, e.getMessage(), 'Exception message should not be null');
        }
        Test.stopTest();
    }
}