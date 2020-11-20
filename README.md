# Health Passport Health Provider Portal React UI

This is a Rails-based backend for a Health Provider portal to manage and sign Vaccination Certificates. 

The UI is [here](https://github.com/vitorpamplona/healthpassport-provider-portal-ui). 

## Behaviour

1. Health Provider Signs UP for the service. 
2. Health Provider creates a Vaccination Program. 
3. Health Provider generates a QR code, prints and places it visible for patients to scan. 

4. Patiens scan the QR Code after testing. 
5. QR Code takes patients to this portal, where. 
5.1. Users add their name to the certificate
5.2. Press button to generate and download. 
5. Portal generates que QR code text, signs and starts downloading the QR code with the Vaccine Certification. 

6. Users load on their signed certificate to the [Health Passport Reader app](https://github.com/vitorpamplona/healthpassport-reader-app). 

## Features / TO-DO List

- [x] Health Provider Sign Up
- [x] Health Provider Login 
- [x] Home Page
- [x] New Vaccination Programs
- [x] Listing Vaccination Programs on Home Page
- [ ] Health Provider's Password recovery (Forgot My Password logic)
- [ ] Edit Vaccination Program
- [ ] Generate and Sign Vaccination Program QR Code to Print
- [ ] Accept patient access to ask for their Name and sign the QR Code with Provider's Primary Key
- [ ] Generate and Download Patient's signed Certificate.
- [ ] Rails error messages on the browser are exposing routes and potentially confidential information. Have to remove this somehow. 

## Running

Make sure you have everything you need to run a Ruby 2.5 / Rails 6 service. 

Install modules:
`bundle install`

Start the API on port 3000
`rails server `