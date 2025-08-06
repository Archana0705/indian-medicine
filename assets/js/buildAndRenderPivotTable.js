window.generatePivotTable = function (data, containerId) {
    debugger
    const rows = [...new Set(data.map(d => `${d.medicine_name}|||${d.packing_size}|||${parseFloat(d.amount).toFixed(2)}`))];
    const cols = [...new Set(data.map(d => d.name_of_the_district))].sort();

    // Initialize pivot data
    const pivot = {};
    rows.forEach(row => {
        pivot[row] = {};
        cols.forEach(col => {
            pivot[row][col] = 0;
        });
    });

    // Fill pivot with quantities
    data.forEach(item => {
        const rowKey = `${item.medicine_name}|||${item.packing_size}|||${parseFloat(item.amount).toFixed(2)}`;
        const colKey = item.name_of_the_district;
        const quantity = parseFloat(item.quantity) || 0;
        pivot[rowKey][colKey] += quantity;
    });

    // Build HTML
    let html = "<table border='1' cellspacing='0' cellpadding='4'><thead><tr>";
    html += "<th>Medicine Name</th><th>Packing Size</th><th>Amount</th>";
    cols.forEach(col => html += `<th>${col}</th>`);
    html += "<th>Total</th></tr></thead><tbody>";

    rows.forEach(rowKey => {
        const [medicine, packing, amount] = rowKey.split("|||");
        let rowTotal = 0;
        html += `<tr><td>${medicine}</td><td>${packing}</td><td>${amount}</td>`;
        cols.forEach(col => {
            const val = pivot[rowKey][col];
            html += `<td>${val ? val : ''}</td>`;
            rowTotal += val;
        });
        html += `<td><strong>${rowTotal}</strong></td></tr>`;
    });

    // Column totals
    html += "<tr><td colspan='3'><strong>Total</strong></td>";
    let grandTotal = 0;
    cols.forEach(col => {
        let colTotal = 0;
        rows.forEach(rowKey => colTotal += pivot[rowKey][col]);
        html += `<td><strong>${colTotal}</strong></td>`;
        grandTotal += colTotal;
    });
    html += `<td><strong>${grandTotal}</strong></td></tr>`;

    html += "</tbody></table>";

    document.getElementById(containerId).innerHTML = html;
};
