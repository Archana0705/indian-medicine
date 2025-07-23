// function initializeUserSession() {
//     debugger
//     const secretKey = 'V7gN4dY8pT2xB3kRz';
//     const sampleUser = {
//         user_id: 101,
//         name: "John Doe",
//         role: "edistrict_manager"
//     };

//     const encrypted = CryptoJS.AES.encrypt(JSON.stringify(sampleUser), secretKey).toString();
//     localStorage.setItem('userDetails', encrypted);

//     const bytes = CryptoJS.AES.decrypt(encrypted, secretKey);
//     const decrypted = bytes.toString(CryptoJS.enc.Utf8);
//     const user = JSON.parse(decrypted);

//     window.userSession = {
//         userId: user.user_id,
//         name: user.name,
//         role: user.role
//     };

//     const userNameElement = document.querySelector('.t-Button-label');
//     if (userNameElement) userNameElement.textContent = user.name;
// }

// // window.initializeUserSession = initializeUserSession;
// export { initializeUserSession };


async function initializeUserSession(mobnumber) {
    debugger
    return new Promise((resolve, reject) => {
        console.log("mobile number", mobnumber);
        const payload = {
            action: "function_call",
            function_name: "im_own_district_fn",
            params: {
                mobnumber: parseInt(mobnumber),
            }
        };

        const apiUrl = 'https://tngis.tnega.org/medical_indent_api/v1/commonfunction';

        $.ajax({
            url: apiUrl,
            method: "POST",
            headers: {
                'X-APP-Key': "edm",
                'X-APP-Name': "edm"
            },
            data: {
                data: encryptData(payload)
            },
            dataType: 'json',
            cache: false,
            success: function (response) {
                try {
                    if (response && response.data) {
                        var decryptedResponse = decryptData(response.data);

                        if (!Array.isArray(decryptedResponse) || decryptedResponse.length === 0) {
                            throw new Error("Invalid decrypted data format");
                        }

                        const decrypted = decryptedResponse[0];
                        window.userSession = {
                            // userId: decrypted.user_id,
                            district: decrypted.district,
                            // role: decrypted.designation || ''
                        };

                        // localStorage.setItem('userRole', decrypted.designation || '');
                        localStorage.setItem('userDistrict', decrypted.district);
                        // localStorage.setItem('userName', decrypted.name);
                        // localStorage.setItem('userId', decrypted.user_id || '');

                        // const userNameElement = document.querySelector('.t-Button-label');
                        // if (userNameElement) userNameElement.textContent = decrypted.name;

                        resolve();
                    } else {
                        console.error("Invalid response structure - missing data field");
                        reject(new Error("Invalid response structure"));
                    }
                } catch (error) {
                    console.error("Error processing response:", error);
                    reject(error);
                }
            },
            error: function (xhr, status, error) {
                console.error("API call failed:", {
                    status: xhr.status,
                    statusText: xhr.statusText,
                    responseText: xhr.responseText,
                    error: error
                });
                reject(new Error("API call failed"));
            }
        });
    });
}

window.initializeUserSession = initializeUserSession;
