console.log('globalHeader.js loaded');

document.addEventListener('DOMContentLoaded', async function () {
    console.log('DOMContentLoaded triggered');

    try {
        const response = await fetch('/assets/partials/globalHeader.html');
        console.log('Fetching globalHeader.html – Status:', response.status);

        if (!response.ok) throw new Error('Header file not found');

        const html = await response.text();
        console.log('Header HTML fetched successfully');

        const container = document.getElementById('globalHeader');
        if (container) {
            container.innerHTML = html;
            console.log('Header injected into #globalHeader');

            // Set username
            const username = localStorage.getItem('userName') || 'User';
            const usernameElement = document.getElementById('dynamicUsername');
            if (usernameElement) {
                usernameElement.textContent = username;
                console.log('Username set:', username);
            }

            // // Set last login
            // const lastLogin = localStorage.getItem('lastLogin');
            // const lastLoginElement = document.getElementById('lastLoggedIn');
            // if (lastLogin && lastLoginElement) {
            //     lastLoginElement.textContent = lastLogin;
            //     console.log('Last login set:', lastLogin);
            // }

            // Sign out
            const signOutBtn = document.getElementById('signOutBtn');
            if (signOutBtn) {
                signOutBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    console.log('Sign out clicked');
                    localStorage.clear();
                    window.location.href = '/index.html';
                });
            }

            const role = (localStorage.getItem('userRole') || '').toLowerCase();
            const currentPage = window.location.pathname.toLowerCase();

            console.log('userRole:', role);
            console.log('currentPage:', currentPage);

        } else {
            console.warn('#globalHeader element not found in DOM');
        }
    } catch (error) {
        console.error('Error during globalHeader init:', error);
    }
});

// Header dropdown menu toggle
document.addEventListener('click', function (event) {
    const toggleBtn = document.querySelector('[data-menu="menu_L8804321173964414"]');
    const menu = document.getElementById('menu_L8804321173964414');

    if (!toggleBtn || !menu) return;

    if (toggleBtn.contains(event.target)) {
        const isVisible = menu.style.display === 'block';
        menu.style.display = isVisible ? 'none' : 'block';
        console.log(`Menu toggled: ${isVisible ? 'hide' : 'show'}`);
    } else if (!menu.contains(event.target)) {
        menu.style.display = 'none';
        console.log('Menu hidden (outside click)');
    }
});

// // Manual Change Password popup click
// document.addEventListener('click', async function (e) {
//     if (e.target && e.target.id === 'changePasswordLink') {
//         e.preventDefault();
//         console.log('🔧 Change Password link clicked');

//         if (!document.getElementById('popup-overlay')) {
//             try {
//                 const response = await fetch('../assets/ChangePassword/ChangePassword.html');
//                 if (!response.ok) throw new Error('Failed to fetch popup HTML');

//                 const html = await response.text();
//                 document.body.insertAdjacentHTML('beforeend', html);
//                 console.log('Manual ChangePassword popup inserted');

//                 const script = document.createElement('script');
//                 script.src = '../assets/js/changePassword.js';
//                 script.onload = () => console.log('changePassword.js loaded (manual)');
//                 document.body.appendChild(script);
//             } catch (err) {
//                 console.error('Error loading manual Change Password popup:', err);
//             }
//         }

//         $('#popup-overlay').fadeIn();
//         $('.t-Header').css('z-index', '0');
//     }

//     document.addEventListener('click', async function (e) {
//         if (e.target && e.target.id === 'myProfileLink') {
//             e.preventDefault();

//             if (!document.getElementById('profile-overlay')) {
//                 try {
//                     const response = await fetch('../assets/MyProfile/MyProfile.html');
//                     const html = await response.text();
//                     document.body.insertAdjacentHTML('beforeend', html);

//                     // First load encrypt_decrypt.js
//                     const encryptScript = document.createElement('script');
//                     encryptScript.src = '../assets/js/encrypt_decrypt.js';

//                     encryptScript.onload = () => {
//                         // After it’s loaded, load myProfile.js
//                         const profileScript = document.createElement('script');
//                         profileScript.src = '../assets/js/myProfile.js';
//                         document.body.appendChild(profileScript);
//                     };

//                     document.body.appendChild(encryptScript);
//                 } catch (err) {
//                     console.error('Error loading my profile popup:', err);
//                 }
//             }

//             $('#profile-overlay').fadeIn();
//             $('.t-Header').css('z-index', '0');
//         }
//     });
// });

