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
                    { name: 'Home', href: '../admin/home.html' },
                    { name: 'Medicine Details', href: '../admin/medicine-details.html' },
                    { name: 'User Details', href: '../admin/user-details.html' }
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
                        name: 'Medicine Details',
                        href: '#',
                        children: [
                            { name: 'District Financial year only', href: '../factory/medicine-details.html' },
                            { name: 'District, Financial year, System, Quarter', href: '../factory/medicine-details-quarter.html' },
                            { name: 'District, Financial year, System, Quarter, Regular', href: '../factory/monthly-reports.html' },
                            { name: 'District, Financial year, System, Quarter, Scheme', href: '../factory/monthly-reports.html' }

                        ]
                    },
                    { name: 'Download Despatched Medicine', href: '../factory/download.html' },
                    { name: 'AMO Approved Medicine', href: '../factory/amo-approved.html' },
                    {
                        name: 'Consolidate Report - District wise',
                        href: '#',
                        children: [
                            { name: 'Financial year only', href: '../factory/report.html' },
                            { name: 'Financial year, Quarter, Regular', href: '../factory/report-regular.html' },
                            { name: 'Financial year, Quarter, Scheme', href: '../factory/report-scheme.html' }
                        ]
                    },
                ],
                nodal: [
                    { name: 'Home', href: '../nodal/home.html' },
                    {
                        name: 'Medicine Details',
                        href: '#',
                        children: [
                            { name: 'District Financial year only', href: '../nodal/medicine-yearly.html' },
                            { name: 'District, Financial year, System, Quarter', href: '../nodal/medicine-quarter.html' },
                            { name: 'District, Financial year, System, Quarter, Regular', href: '../nodal/medicine-regular.html' },
                            { name: 'District, Financial year, System, Quarter, Scheme', href: '../nodal/medicine-scheme.html' }

                        ]
                    },
                    { name: 'Download Despatched Medicine', href: '../nodal/download.html' },
                    { name: 'AMO Approved Medicine', href: '../nodal/amo.html' },
                    {
                        name: 'Consolidate Report - District wise',
                        href: '#',
                        children: [
                            { name: 'Financial year only', href: '../nodal/report-only.html' },
                            { name: 'Financial year, Quarter, Regular', href: '../nodal/report-regular.html' },
                            { name: 'Financial year, Quarter, Scheme', href: '../nodal/report-scheme.html' }
                        ]
                    },
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

                    // Check for submenu
                    if (link.children && link.children.length) {
                        li.innerHTML = `
            <a role="menuitem" class="a-MenuBar-label" href="#">${link.name} &#9660;</a>
            <ul class="submenu" style="list-style:none;margin-left:15px;padding-left:10px;border-left:2px solid #ccc;display:none;"></ul>
        `;

                        const submenu = li.querySelector(".submenu");

                        link.children.forEach(sub => {
                            const subLi = document.createElement("li");
                            const subA = document.createElement("a");
                            subA.href = sub.href;
                            subA.className = "a-MenuBar-label";
                            subA.style.display = "block";
                            subA.style.padding = "4px 0";
                            subA.innerText = sub.name;

                            if (sub.href.includes(currentPage)) {
                                li.classList.add("a-Menu--current");
                                subA.style.fontWeight = "bold";
                            }

                            subLi.appendChild(subA);
                            submenu.appendChild(subLi);
                        });

                        // Toggle submenu
                        li.querySelector("a").addEventListener("click", (e) => {
                            e.preventDefault();
                            submenu.style.display = submenu.style.display === "block" ? "none" : "block";
                        });

                    } else {
                        // Normal menu item
                        if (link.href.includes(currentPage)) {
                            li.classList.add("a-Menu--current");
                        }

                        li.innerHTML = `
            <a role="menuitem" class="a-MenuBar-label" href="${link.href}">${link.name}</a>
        `;
                    }

                    ul.appendChild(li);
                });

            }
        })
        .catch((err) => {
            console.error("Failed to load navbar:", err);
        });
});
