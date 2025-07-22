// toastUtil.js

window.showSuccessToast = function (message) {
    const toastElement = document.getElementById('successToast');
    const toastBody = document.getElementById('successMessage');

    if (toastElement && toastBody) {
        toastBody.textContent = message;
        const toast = new bootstrap.Toast(toastElement, {
            autohide: true,
            delay: 3000
        });
        toast.show();
    } else {
        console.warn('Success toast layout not found in DOM.');
    }
};

window.showErrorToast = function (message) {
    const toastElement = document.getElementById('errorToast');
    const toastBody = document.getElementById('errorMessage');

    if (toastElement && toastBody) {
        toastBody.textContent = message;
        const toast = new bootstrap.Toast(toastElement, {
            autohide: true,
            delay: 3000
        });
        toast.show();
    } else {
        console.warn('Error toast layout not found in DOM.');
    }
};

// window.loadToastLayout = function (callback) {
//     fetch('/assets/partials/toastLayout.html')
//         .then(response => response.text())
//         .then(html => {
//             const div = document.createElement('div');
//             div.innerHTML = html;
//             document.body.appendChild(div);
//             console.log('Toast layout loaded.');
//             if (typeof callback === 'function') {
//                 callback();
//             }
//         })
//         .catch(err => console.error('Toast layout load failed:', err));
// };

// Ensure layout is loaded before any toast is shown
window.loadToastLayout = function (callback) {
    const currentPath = window.location.pathname;
    const isInEdmPortal = currentPath.includes("/edm_portal/");
    const toastPath = isInEdmPortal
        ? "assets/partials/toastLayout.html"       // Relative path for edm_portal/index.html
        : "/assets/partials/toastLayout.html";     // Absolute path for other folders

    fetch(toastPath)
        .then(response => response.text())
        .then(html => {
            const div = document.createElement('div');
            div.innerHTML = html;
            document.body.appendChild(div);
            console.log('Toast layout loaded.');
            if (typeof callback === 'function') {
                callback();
            }
        })
        .catch(err => console.error('Toast layout load failed:', err));
};


document.addEventListener('DOMContentLoaded', () => {
    loadToastLayout(() => {
        // You can test after layout is ready
        // Example:
        // showSuccessToast('Loaded successfully!');
    });
});
