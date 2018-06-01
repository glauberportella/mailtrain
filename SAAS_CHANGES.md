# SaaS Changes

Changes in Mailtrain to use multiple customer accounts, allowing to use it as an SaaS platform with multi-account users that sign up as customer service.

# Changes needed to be made

- Create the SaaS page so that users can sign up on a plan and after that do the account activation and login to the platform.

- Every database entities must now have an `account_id` column that is tied to the customer account ID.

- Limit the initial customer account to only 100 e-mails on list and 5 sends on month

- For more campaings and emails in list the user must pay montly according to the number of e-mails and campaings he wants to add.

- Free: 100 emails / 5 sends per month
- Plan 1: 500 emails / 10 sends per month
- Plan 2: 1000 emails / 10 sends per month
- Plan 3: 5000 emails / 20 sends per month

**Upgrades**

- R$ 5,00 per +100 emails
- R$ 20,00 per + 10 sends per month

## Models to add

- Account: the customer account
- Sends: register the user sends on month