# Health Passport Health Provider Portal Rails Rest API

This is a Rails-based backend for a Health Provider portal to manage and sign Vaccination Certificates. 

The UI part is [here](https://github.com/vitorpamplona/healthpassport-provider-portal-ui). 
A Demo hot deployed from staging is [here](https://healthpassport.vitorpamplona.com/). 

<img src="./docs/ProviderPortalPreview.png" data-canonical-src="./docs/ProviderPortalPreview.png"/>

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

## QR Code formats used: 

There are two main QR formats we use: (i) a signed public URL that is used to generate an imunization certificate and (ii) the signed immunization certificate itself. It follows the format. 

### A Signed Public URL

The Signed Public URL is generated for a Vaccination Proram to be placed publically in the Vaccination site. 
It allows patients to scan the information of the vaccine, insert their names and generate a signed certificate from the 
Vaccinator's private key. 

```http://{UI_URL}/generateCertificate/{id_program}?date=YYYY-MM-DD&signature={RSA_SHA256}```

Example:

```
https://healthpassport.vitorpamplona.com/generateCertificate/9?date=2020-11-26&signature=
x9iSOLHgdlP5DUN4Aj2cbAqF1mDmkYcwB%2Bt327U6izI84QJXVDzN1ETfFfU8%
0ADFfvuAnnwysM0NnycHjqMJMvlscDNeqqLcSzCoswMAfN6pSAboqdXArpP0gj%
0AzUNP82cLI3OesK2TFNnwRiGkaakxGsEhaVX0x%2BriCr3Qk%2B5Py4c%3D%0A
```

### Immunization Certificate

The certificate is the official document that prove a patient name has taken a vaccine. It follows the format: 

```
healthpass:vaccine?vaccinator_pub_key={API/u/{user_id}/pub_key}?date=YYYY-MM-DD
&vaccinee={patient_name}&vaccinator={place}&manuf={vaccine brand}
&name={vaccine name}&route={Intramuscular, Subcutaneous, etc}
&lot={lot number}&dose={applied dose}&signature={RSA_SHA256}
```

Example:

```
healthpass:vaccine?vaccinator_pub_key=healthpassport-api.vitorpamplona.com/u/6/pub_key&date=2020-11-26
&vaccinee=Vitor+Fernando+pamplona+dos+santos&vaccinator=CVS+Minute+Clinics&manuf=Moderna+Vaccine
&name=COVID19&route=Intramuscular&lot=&dose=1&signature=
RVQ9h0s1rW%2BJ8Smy6%2Fg695oTclJ%2B%2FawR0m%2FVQRhyNZ6gyGVxajQMt
RHPtE6z%0APdi29Fk7Nf0oIVebaLzgBvIzhnO6F7STZIN0KNN1ItxGsbcMxawN4
jTF9rtr%0A980f4o1oj21nJZ5n8CeXapQQdLLZQyTTW0eBWGeQ8aMmNNh3lAS2R
wcCNsRm%0A3GObdJMpgeSNm9Gh7KXbqSGL0bCPFA%2FTySU4lycAGJVAQH5Vdjz
C1OoeFYKa%0Ay7U%2FFLlIr4twkq0GMP48WYPIaBUDs6HSicDezqOHQn8c8sPMZ
%2FXShwHpWpMH%0AyNKAGr8itGa4vmhnlyW8penV%2BjIjNVHDm%2B%2B7ZW3Bb
OQm9BwmtNwuczsmvcFb%0AiOpUdDhXTgHt0K%2FN%2BLzmQMP%2FmWahLTcTNtJ
OBd74GyRZXHkGxZ%2B%2BxOaqY%2FnY%0AcSeK693Ol%2ByJeg6NAXakez%2F1K
pu441sD7aImqy0hMd28BDfjPRS7Cb9v%2Fe16%0ALxYxIjai8B%2F8rR%2FE690
mUMLX%2BAjd8fKQmm9rMNC2ANj12g13zV%2B8yLYcwTBA%0AyH9L3vVvTQhKCAH
A6mOy86fs9N7KPv9FeKRIneQiElzFfh%2BsLE9fLigiZ%2Ffm%0AuPk9qSQZDMg
1TTSMZDP1Hx4Nem%2Fz1D%2FJV1zxnoOSTh%2FBGZonOF5YgB967%2Fox%0Asev
09MdoBmUNxIyZHnxDw%2BM%3D%0A
```

## Features / TO-DO List

- [x] Health Provider Sign Up
- [x] Health Provider Login 
- [x] Home Page
- [x] New Vaccination Programs
- [x] Listing Vaccination Programs on Home Page
- [x] Generate and Sign Vaccination Program QR Code to Print
- [x] Accept patient access to ask for their Name and sign the QR Code with Provider's Primary Key
- [x] Generate and Download Patient's signed Certificate.
- [x] Sign the Vaccination Program QR Code on the server
- [x] Sign the Certificate of Vaccination QR Code on the server
- [x] User's public key download
- [x] Percent-encoding and Base64 for signatures
- [x] Staging deployed [here](https://healthpassport.vitorpamplona.com/)
- [ ] Health Provider's Password recovery (Forgot My Password logic)
- [ ] Edit Vaccination Program
- [ ] Rails error messages on the browser are exposing routes and potentially confidential information. Have to remove this somehow. 
- [ ] Dockerize it
- [ ] Reduce amount of data on QRCodes

## Running

Make sure you have everything you need to run a Ruby 2.5 / Rails 6 service. 

Install modules:
`bundle install`

Start the API server
`rails server `

## Staging Server

This project is deployed to [https://healthpassport-api.vitorpamplona.com](https://healthpassport-api.vitorpamplona.com) at every commit. 

## Contributing

[Issues](https://github.com/Path-Check/healthpassport-provider-portal-api/issues) and [pull requests](https://github.com/Path-Check/healthpassport-provider-portal-api/pulls) are very welcome! :)