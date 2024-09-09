List<Contact> contacts = [
        SELECT Description
        FROM Contact
];

for (Contact contact : contacts) {
    contact.Description = 'Lorem Ipsum.';
}

update contacts;