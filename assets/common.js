document.addEventListener("DOMContentLoaded", function () {
    const navbarContainer = document.getElementById("navbar-container");

    if (!navbarContainer) return;

    fetch("../assets/navbar.html")
        .then((res) => res.text())
        .then((html) => {
            navbarContainer.innerHTML = html;

            const pathParts = window.location.pathname.split('/');
            const role = pathParts.find(part =>
                ['amo', 'admin', 'commissioner', 'dim', 'dsmo', 'factory', 'nodal'].includes(part)
            );

            const navLinks = {
                amo: [
                    { name: 'Home', href: '../amo/home.html' },
                    { name: 'Received Medicine Report', href: '../amo/received-medicine.html' },
                    { name: 'Patient Details', href: '../amo/patient-details.html' }
                ],
                admin: [
                    {
                        name: 'Home',
                        href: '../admin/home.html'
                    },
                    {
                        name: 'Medicine Details',
                        href: '#',
                        submenu: [
                            { name: 'Add Medicine', href: '../admin/add-medicine.html' },
                            { name: 'Edit Medicine', href: '../admin/edit-medicine.html' }
                        ]
                    },
                    {
                        name: 'User Details',
                        href: '../admin/user-details.html'
                    }
                ],
                commissioner: [
                    { name: 'Dashboard', href: '../commissioner/overall-dashboard.html' },
                    { name: 'All Stocks', href: '../commissioner/all-stocks-details.html' },
                    { name: 'Report', href: '../commissioner/overall-report.html' }
                ],
                dim: [
                    { name: 'Home', href: '../dim/home.html' },
                    { name: 'Stock Details', href: '../dim/stock-details.html' },
                    { name: 'View Indent Status', href: '../dim/view-indent-status.html' }
                ],
                dsmo: [
                    { name: 'Home', href: '../dsmo/home.html' },
                    { name: 'Received Medicine', href: '../dsmo/received-medicine.html' },
                    { name: 'View Indent', href: '../dsmo/view-indent.html' }
                ],
                factory: [
                    { name: 'Home', href: '../factory/home.html' },
                    {
                        name: 'Medicine Details', href: '#',
                        submenu: [
                            { name: 'Add Medicine', href: '../admin/add-medicine.html' },
                            { name: 'Edit Medicine', href: '../admin/edit-medicine.html' }
                        ]
                    },
                    { name: 'View Indent', href: '../factory/view-indent.html' }
                ],
                nodal: [
                    { name: 'Home', href: '../nodal/home.html' },
                    { name: 'Report Only', href: '../nodal/report-only.html' },
                    { name: 'Medicine Yearly', href: '../nodal/medicine-yearly.html' }
                ]
            };

            const links = navLinks[role] || [];
            const ul = document.getElementById("nav-links");
            const currentPage = window.location.pathname.split('/').pop();

            if (ul && links.length) {
                links.forEach(link => {
                    const li = document.createElement("li");
                    li.setAttribute("role", "none");
                    li.classList.add("a-MenuBar-item");

                    // Add active class if current page matches
                    const isActive = link.href?.includes(currentPage);
                    if (isActive) {
                        li.classList.add("a-Menu--current");
                    }

                    // Create main link
                    const mainLink = document.createElement("a");
                    mainLink.classList.add("a-MenuBar-label");
                    mainLink.setAttribute("role", "menuitem");
                    mainLink.href = link.href || "#";
                    mainLink.textContent = link.name;
                    li.appendChild(mainLink);

                    // Check for submenu
                    if (link.submenu && Array.isArray(link.submenu)) {
                        const subUl = document.createElement("ul");
                        subUl.classList.add("a-Menu-subMenu");
                        subUl.setAttribute("role", "menu");

                        link.submenu.forEach(sub => {
                            const subLi = document.createElement("li");
                            subLi.setAttribute("role", "none");
                            subLi.classList.add("a-MenuBar-item");

                            if (sub.href.includes(currentPage)) {
                                subLi.classList.add("a-Menu--current");
                            }

                            subLi.innerHTML = `
                                <a role="menuitem" class="a-MenuBar-label" href="${sub.href}">${sub.name}</a>
                            `;
                            subUl.appendChild(subLi);
                        });

                        li.appendChild(subUl);
                    }

                    ul.appendChild(li);
                });
            }
        })
        .catch((err) => {
            console.error("Failed to load navbar:", err);
        });
});
