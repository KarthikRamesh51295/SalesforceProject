import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import createAccount from '@salesforce/apex/AccountController.createAccount';

export default class AccountList extends LightningElement {
    accounts;
    error;
    showForm = false;
    accountName = '';
    accountType = 'Customer';

    // Datatable columns configuration
    columns = [
        { label: 'Account Name', fieldName: 'Name', type: 'text' },
        { label: 'Type', fieldName: 'Type', type: 'text' },
        { label: 'Industry', fieldName: 'Industry', type: 'text' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        { label: 'Website', fieldName: 'Website', type: 'url' }
    ];

    // Account type options
    get typeOptions() {
        return [
            { label: 'Customer', value: 'Customer' },
            { label: 'Partner', value: 'Partner' },
            { label: 'Prospect', value: 'Prospect' },
            { label: 'Other', value: 'Other' }
        ];
    }

    // Button label computed property
    get buttonLabel() {
        return this.showForm ? 'Cancel' : 'New Account';
    }

    // Button variant computed property
    get buttonVariant() {
        return this.showForm ? 'neutral' : 'brand';
    }

    // Wire method to get accounts
    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
            this.showToast('Error', 'Error loading accounts', 'error');
        }
    }

    // Handle input changes
    handleInputChange(event) {
        const field = event.target.dataset.field;
        if (field === 'name') {
            this.accountName = event.target.value;
        } else if (field === 'type') {
            this.accountType = event.target.value;
        }
    }

    // Show/hide form
    toggleForm() {
        this.showForm = !this.showForm;
        if (!this.showForm) {
            this.accountName = '';
            this.accountType = 'Customer';
        }
    }

    // Create new account
    async handleCreateAccount() {
        if (!this.accountName) {
            this.showToast('Error', 'Please enter an account name', 'error');
            return;
        }

        try {
            await createAccount({ 
                accountName: this.accountName, 
                accountType: this.accountType 
            });
            
            this.showToast('Success', 'Account created successfully', 'success');
            this.toggleForm();
            
            // Refresh the account list
            await getAccounts();
        } catch (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    // Show toast notification
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
}