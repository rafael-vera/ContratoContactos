const Contacts = artifacts.require("Contacts");

contract("Contacts", () => {
    before(async () => {
        this.contactsContract = await Contacts.deployed();
    })
    
    it("Deployed or migrated successfully", async () => {
        const address = this.contactsContract.address;
        assert.notEqual(address, null);
        assert.notEqual(address, undefined);
        assert.notEqual(address, 0x0);
        assert.notEqual(address, "");
    })
    
    it("Contacts created successfully", async () => {
        // Add 1 contact
        const firstNameExample = "Rafael";
        const lastNameExample = "Vera";
        const telephoneNumberExample = "1234567890";
        const emailExample = "rafael@algo.com";
        const accountExample = "0x0000000000000000000000000000000000000000";
        const result = await this.contactsContract.addContact(
            firstNameExample,
            lastNameExample,
            telephoneNumberExample,
            emailExample,
            accountExample
        );
        const contactEvent = result.logs[0].args;
        assert.equal(contactEvent.id, 1);
        assert.equal(contactEvent.firstName, firstNameExample);
        assert.equal(contactEvent.lastName, lastNameExample);
        assert.equal(contactEvent.telephoneNumber, telephoneNumberExample);
        assert.equal(contactEvent.email, emailExample);
        assert.equal(contactEvent.account, accountExample);
    })
    
    it("Contacts updated successfully", async () => {
        // Add 1 contact
        const oldFirstNameExample = "Rafael";
        const oldLastNameExample = "Vera";
        const oldTelephoneNumberExample = "1234567890";
        const oldEmailExample = "rafael@algo.com";
        const oldAccountExample = "0x0000000000000000000000000000000000000000";
        await this.contactsContract.addContact(
            oldFirstNameExample,
            oldLastNameExample,
            oldTelephoneNumberExample,
            oldEmailExample,
            oldAccountExample
        );
        // Update 2nd contact
        const newFirstNameExample = "Karen";
        const newLastNameExample = "Peña";
        const newTelephoneNumberExample = "0987654321";
        const newEmailExample = "karen@algo.com";
        const newAccountExample = "0x9999999999999999999999999999999999999999";
        const result = await this.contactsContract.updateContact(
            2,
            newFirstNameExample,
            newLastNameExample,
            newTelephoneNumberExample,
            newEmailExample,
            newAccountExample
        );
        const contactEvent = result.logs[0].args;
        assert.equal(contactEvent.id, 2);
        assert.notEqual(contactEvent.firstName, oldFirstNameExample);
        assert.notEqual(contactEvent.lastName, oldLastNameExample);
        assert.notEqual(contactEvent.telephoneNumber, oldTelephoneNumberExample);
        assert.notEqual(contactEvent.email, oldEmailExample);
        assert.notEqual(contactEvent.account, oldAccountExample);
        assert.equal(contactEvent.firstName, newFirstNameExample);
        assert.equal(contactEvent.lastName, newLastNameExample);
        assert.equal(contactEvent.telephoneNumber, newTelephoneNumberExample);
        assert.equal(contactEvent.email, newEmailExample);
        assert.equal(contactEvent.account, newAccountExample);
    })
    
    it("Contacts deleted successfully", async () => {
        // Add 2 contacts
        await this.contactsContract.addContact(
            "Monserrat",
            "Diaz",
            "1357924680",
            "monse@algo.com",
            "0x1234567890123456789012345678901234567890"
        );
        await this.contactsContract.addContact(
            "Marcelo",
            "De la Cruz",
            "0864297531",
            "marcelo@algo.com",
            "0x0987654321098765432109876543210987654321"
        );
        // Delete 1st contact
        const result = await this.contactsContract.deleteContact(1);
        const contactEvent = result.logs[0].args;
        assert.equal(contactEvent.id.toNumber(), 1);
        assert.equal(contactEvent.replacedByID.toNumber(), 4);
    })
})