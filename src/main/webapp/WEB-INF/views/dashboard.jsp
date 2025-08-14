<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Data Dashboard - ETS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --danger-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --glass-bg: rgba(255, 255, 255, 0.25);
            --glass-border: rgba(255, 255, 255, 0.18);
            --text-primary: #2d3748;
            --text-secondary: #718096;
            --shadow-light: 0 8px 32px rgba(31, 38, 135, 0.37);
            --shadow-hover: 0 15px 35px rgba(31, 38, 135, 0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            color: var(--text-primary);
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
            animation: slideDown 1s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo {
            width: 120px;
            height: auto;
            margin-bottom: 20px;
            filter: drop-shadow(0 4px 8px rgba(0,0,0,0.2));
            transition: transform 0.3s ease;
        }

        .logo:hover {
            transform: scale(1.05) rotate(2deg);
        }

        h1 {
            font-size: 3rem;
            font-weight: 700;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 10px;
        }

        .subtitle {
            font-size: 1.1rem;
            color: rgba(255,255,255,0.9);
            font-weight: 400;
        }

        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            border: 1px solid var(--glass-border);
            box-shadow: var(--shadow-light);
            padding: 30px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: white;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .input-group {
            position: relative;
        }

        .input-field {
            width: 100%;
            padding: 15px 20px 15px 45px;
            border: none;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.9);
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .input-field:focus {
            outline: none;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            transform: translateY(-2px);
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #718096;
            font-size: 18px;
        }

        .btn-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 20px;
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }

        .btn-primary {
            background: var(--primary-gradient);
            color: white;
        }

        .btn-secondary {
            background: var(--success-gradient);
            color: white;
        }

        .btn-danger {
            background: var(--danger-gradient);
            color: white;
        }

        .message {
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn 0.5s ease-out;
            backdrop-filter: blur(10px);
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .message-success {
            background: rgba(72, 187, 120, 0.2);
            color: #22543d;
            border-left: 4px solid #48bb78;
        }

        .message-error {
            background: rgba(245, 101, 101, 0.2);
            color: #742a2a;
            border-left: 4px solid #f56565;
        }

        .data-table-container {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            border: 1px solid var(--glass-border);
            overflow: hidden;
            box-shadow: var(--shadow-light);
            animation: fadeInUp 0.8s ease-out;
        }

        .table-header {
            background: var(--primary-gradient);
            padding: 20px 30px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .table-title {
            font-size: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-responsive {
            overflow-x: auto;
            max-height: 70vh;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.95);
        }

        .data-table th {
            background: rgba(102, 126, 234, 0.1);
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            color: var(--text-primary);
            border-bottom: 2px solid rgba(102, 126, 234, 0.2);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .data-table td {
            padding: 15px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            transition: background-color 0.3s ease;
            max-width: 200px;
            word-wrap: break-word;
            vertical-align: top;
        }

        .data-table tr:hover td {
            background: rgba(102, 126, 234, 0.05);
        }

        .data-table tr:nth-child(even) {
            background: rgba(247, 250, 252, 0.8);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-active {
            background: rgba(72, 187, 120, 0.2);
            color: #22543d;
        }

        .status-inactive {
            background: rgba(245, 101, 101, 0.2);
            color: #742a2a;
        }

        .floating-stats {
            position: fixed;
            top: 20px;
            right: 20px;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid var(--glass-border);
            box-shadow: var(--shadow-light);
            z-index: 1000;
            animation: slideInRight 0.6s ease-out;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: white;
            font-weight: 500;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .loading-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(255,255,255,0.3);
            border-top: 4px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            h1 {
                font-size: 2rem;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .btn-group {
                flex-direction: column;
            }
            
            .floating-stats {
                position: relative;
                top: 0;
                right: 0;
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
    </div>

    <div class="container">
        <header class="header">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/etsBlackLogo.png" alt="ETS Logo" class="logo">
            </div>
            <h1>Exam Data Dashboard</h1>
            <p class="subtitle">Intelligent Question Management System</p>
        </header>

        <div class="floating-stats" id="floatingStats">
            <div class="stat-item">
                <i class="fas fa-database"></i>
                <span>Total Questions: <strong id="totalQuestions">0</strong></span>
            </div>
            <div class="stat-item">
                <i class="fas fa-filter"></i>
                <span>Filtered: <strong id="filteredCount">0</strong></span>
            </div>
            <div class="stat-item">
                <i class="fas fa-clock"></i>
                <span id="currentTime"></span>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty message}">
            <div class="message message-success">
                <i class="fas fa-check-circle"></i>
                <span>${message}</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="message message-error">
                <i class="fas fa-exclamation-triangle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <c:if test="${formSubmitted and empty questions}">
            <div class="message message-error">
                <i class="fas fa-search"></i>
                <span>No questions found matching your search criteria. Try adjusting your filters.</span>
            </div>
        </c:if>

        <c:if test="${formSubmitted and not empty questions}">
            <div class="message message-success">
                <i class="fas fa-check-circle"></i>
                <span>Found ${questions.size()} question(s) matching your criteria!</span>
            </div>
        </c:if>

        <!-- Filter Card -->
        <div class="glass-card">
            <div class="card-title">
                <i class="fas fa-search"></i>
                Advanced Search & Filters
            </div>
            <form id="filterForm" action="/dashboard/filter" method="post">
                <div class="form-grid">
                    <div class="input-group">
                        <i class="fas fa-book input-icon"></i>
                        <input type="text" name="subject" class="input-field" placeholder="Subject (e.g., Mathematics, Physics)">
                    </div>
                    <div class="input-group">
                        <i class="fas fa-tags input-icon"></i>
                        <input type="text" name="topic" class="input-field" placeholder="Topic (e.g., Algebra, Mechanics)">
                    </div>
                    <div class="input-group">
                        <i class="fas fa-layer-group input-icon"></i>
                        <input type="text" name="subtopic" class="input-field" placeholder="Subtopic (e.g., Linear Equations)">
                    </div>
                    <div class="input-group">
                        <i class="fas fa-graduation-cap input-icon"></i>
                        <input type="text" name="grade" class="input-field" placeholder="Grade (e.g., 10, 11, 12)">
                    </div>
                    <div class="input-group">
                        <i class="fas fa-signal input-icon"></i>
                        <input type="text" name="difficultyLevel" class="input-field" placeholder="Difficulty (Easy, Medium, Hard)">
                    </div>
                    <div class="input-group">
                        <i class="fas fa-question input-icon"></i>
                        <input type="text" name="question" class="input-field" placeholder="Search in questions...">
                    </div>
                    <div class="input-group">
                        <i class="fas fa-id-card input-icon"></i>
                        <input type="text" name="workorder" class="input-field" placeholder="Workorder ID">
                    </div>
                </div>
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i>
                        Search Questions
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                        <i class="fas fa-eraser"></i>
                        Clear Filters
                    </button>
                    <a href="${pageContext.request.contextPath}/questions/upload" class="btn btn-secondary">
                        <i class="fas fa-cloud-upload-alt"></i>
                        Upload New File
                    </a>
                </div>
            </form>
        </div>

        <!-- Delete Card -->
        <div class="glass-card">
            <div class="card-title">
                <i class="fas fa-trash-alt"></i>
                Quick Delete
            </div>
            <form id="deleteForm" action="/dashboard/delete" method="post">
                <div class="form-grid" style="grid-template-columns: 1fr auto;">
                    <div class="input-group">
                        <i class="fas fa-id-card input-icon"></i>
                        <input type="text" name="workorder" class="input-field" placeholder="Enter Workorder ID to delete" required>
                    </div>
                    <button type="submit" class="btn btn-danger" onclick="return confirmDelete()">
                        <i class="fas fa-trash"></i>
                        Delete
                    </button>
                </div>
            </form>
        </div>

        <!-- Data Table -->
        <div class="data-table-container">
            <div class="table-header">
                <div class="table-title">
                    <i class="fas fa-table"></i>
                    Question Database
                </div>
                <div class="table-actions">
                    <button class="btn btn-secondary" onclick="exportToExcel()">
                        <i class="fas fa-file-excel"></i>
                        Export to Excel
                    </button>
                    <button class="btn btn-secondary" onclick="exportToCSV()">
                        <i class="fas fa-file-csv"></i>
                        Export to CSV
                    </button>
                </div>
            </div>
            <div class="table-responsive">
                <table class="data-table" id="questionsTable">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> S.No</th>
                            <th><i class="fas fa-id-card"></i> Workorder</th>
                            <th><i class="fas fa-book"></i> Subject</th>
                            <th><i class="fas fa-tags"></i> Topic</th>
                            <th><i class="fas fa-layer-group"></i> Subtopic</th>
                            <th><i class="fas fa-graduation-cap"></i> Grade</th>
                            <th><i class="fas fa-signal"></i> Difficulty</th>
                            <th><i class="fas fa-question"></i> Question</th>
                            <th><i class="fas fa-list-ol"></i> Option 1</th>
                            <th><i class="fas fa-list-ol"></i> Option 2</th>
                            <th><i class="fas fa-list-ol"></i> Option 3</th>
                            <th><i class="fas fa-list-ol"></i> Option 4</th>
                            <th><i class="fas fa-check"></i> Answer</th>
                            <th><i class="fas fa-info"></i> Description</th>
                            <th><i class="fas fa-link"></i> References</th>
                            <th><i class="fas fa-toggle-on"></i> Status</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <c:forEach var="q" items="${questions}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${q.workorder}</td>
                                <td>${q.subject}</td>
                                <td>${q.topic}</td>
                                <td>${q.subtopic}</td>
                                <td>${q.grade}</td>
                                <td>${q.difficultyLevel}</td>
                                <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${q.question}">
                                    ${q.question}
                                </td>
                                <td>${q.option1}</td>
                                <td>${q.option2}</td>
                                <td>${q.option3}</td>
                                <td>${q.option4}</td>
                                <td><strong>${q.correctAnswer}</strong></td>
                                <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${q.description}">
                                    ${q.description}
                                </td>
                                <td>${q.references}</td>
                                <td>
                                    <span class="status-badge ${q.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                        ${q.status}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty questions and not formSubmitted}">
                            <tr>
                                <td colspan="16" style="text-align: center; padding: 40px; color: #718096; font-style: italic;">
                                    <i class="fas fa-search" style="font-size: 24px; margin-bottom: 10px; display: block;"></i>
                                    Use the search filters above to find questions
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // Initialize dashboard
        document.addEventListener('DOMContentLoaded', function() {
            updateStats();
            updateTime();
            setInterval(updateTime, 1000);
            
            // Add loading animation for forms
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function() {
                    showLoading();
                });
            });
        });

        function updateStats() {
            const tableRows = document.querySelectorAll('#tableBody tr');
            let totalQuestions = 0;
            
            // Count only data rows (exclude placeholder row)
            tableRows.forEach(row => {
                if (row.cells.length > 1 && !row.querySelector('td[colspan]')) {
                    totalQuestions++;
                }
            });
            
            const filteredCount = totalQuestions;
            
            document.getElementById('totalQuestions').textContent = totalQuestions;
            document.getElementById('filteredCount').textContent = filteredCount;
        }

        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString();
            document.getElementById('currentTime').textContent = timeString;
        }

        function clearFilters() {
            const inputs = document.querySelectorAll('.input-field');
            inputs.forEach(input => {
                input.value = '';
                input.style.transform = 'scale(0.95)';
                setTimeout(() => {
                    input.style.transform = 'scale(1)';
                }, 200);
            });
        }

        function confirmDelete() {
            const workorder = document.querySelector('input[name="workorder"]').value;
            return confirm(`Are you sure you want to delete workorder "${workorder}"? This action cannot be undone.`);
        }

        function exportToExcel() {
            const table = document.getElementById('questionsTable');
            const rows = table.querySelectorAll('tr');
            
            // Check if there's data to export
            const dataRows = table.querySelectorAll('tbody tr');
            if (dataRows.length === 0 || (dataRows.length === 1 && dataRows[0].querySelector('td[colspan]'))) {
                alert('No data available to export. Please search for questions first.');
                return;
            }
            
            showLoading();
            
            // Prepare data for export
            const exportData = [];
            
            // Add headers
            const headers = [];
            const headerCells = rows[0].querySelectorAll('th');
            headerCells.forEach(cell => {
                // Remove icons and get clean text
                const text = cell.textContent.replace(/[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]/gu, '').trim();
                headers.push(text);
            });
            exportData.push(headers);
            
            // Add data rows
            const bodyRows = table.querySelectorAll('tbody tr');
            bodyRows.forEach(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length > 1 && !row.querySelector('td[colspan]')) { // Skip placeholder rows
                    const rowData = [];
                    cells.forEach(cell => {
                        // Handle status badges and get clean text
                        const statusBadge = cell.querySelector('.status-badge');
                        if (statusBadge) {
                            rowData.push(statusBadge.textContent.trim());
                        } else {
                            // Get text content and clean it
                            let text = cell.textContent.trim();
                            // Remove extra whitespace
                            text = text.replace(/\s+/g, ' ');
                            rowData.push(text);
                        }
                    });
                    exportData.push(rowData);
                }
            });
            
            // Create workbook
            const wb = XLSX.utils.book_new();
            const ws = XLSX.utils.aoa_to_sheet(exportData);
            
            // Set column widths
            const colWidths = [
                { wch: 8 },   // S.No
                { wch: 12 },  // Workorder
                { wch: 15 },  // Subject
                { wch: 20 },  // Topic
                { wch: 20 },  // Subtopic
                { wch: 8 },   // Grade
                { wch: 12 },  // Difficulty
                { wch: 50 },  // Question
                { wch: 20 },  // Option 1
                { wch: 20 },  // Option 2
                { wch: 20 },  // Option 3
                { wch: 20 },  // Option 4
                { wch: 15 },  // Correct Answer
                { wch: 30 },  // Description
                { wch: 20 },  // References
                { wch: 10 }   // Status
            ];
            ws['!cols'] = colWidths;
            
            // Style the header row
            const headerRange = XLSX.utils.decode_range(ws['!ref']);
            for (let col = headerRange.s.c; col <= headerRange.e.c; col++) {
                const cellRef = XLSX.utils.encode_cell({ r: 0, c: col });
                if (!ws[cellRef]) continue;
                ws[cellRef].s = {
                    font: { bold: true, color: { rgb: "FFFFFF" } },
                    fill: { fgColor: { rgb: "1a237e" } },
                    alignment: { horizontal: "center", vertical: "center" }
                };
            }
            
            // Add worksheet to workbook
            XLSX.utils.book_append_sheet(wb, ws, "Exam Questions");
            
            // Generate filename with timestamp
            const now = new Date();
            const timestamp = now.getFullYear().toString() + 
                            String(now.getMonth() + 1).padStart(2, '0') + 
                            String(now.getDate()).padStart(2, '0') + '_' +
                            String(now.getHours()).padStart(2, '0') + 
                            String(now.getMinutes()).padStart(2, '0');
            
            const filename = 'Exam_Questions_' + timestamp + '.xlsx';
            
            // Save file
            setTimeout(() => {
                try {
                    XLSX.writeFile(wb, filename);
                    hideLoading();
                    showExportMessage('Excel file "' + filename + '" downloaded successfully!', 'success');
                } catch (error) {
                    hideLoading();
                    showExportMessage('Error exporting to Excel. Please try again.', 'error');
                    console.error('Export error:', error);
                }
            }, 1000);
        }

        function exportToCSV() {
            const table = document.getElementById('questionsTable');
            
            // Check if there's data to export
            const dataRows = table.querySelectorAll('tbody tr');
            if (dataRows.length === 0 || (dataRows.length === 1 && dataRows[0].querySelector('td[colspan]'))) {
                alert('No data available to export. Please search for questions first.');
                return;
            }
            
            showLoading();
            
            let csvContent = '';
            
            // Add headers
            const headerCells = table.querySelectorAll('thead th');
            const headers = Array.from(headerCells).map(cell => {
                const text = cell.textContent.replace(/[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]/gu, '').trim();
                return '"' + text.replace(/"/g, '""') + '"';
            });
            csvContent += headers.join(',') + '\n';
            
            // Add data rows
            const bodyRows = table.querySelectorAll('tbody tr');
            bodyRows.forEach(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length > 1 && !row.querySelector('td[colspan]')) {
                    const rowData = Array.from(cells).map(cell => {
                        const statusBadge = cell.querySelector('.status-badge');
                        let text = statusBadge ? statusBadge.textContent.trim() : cell.textContent.trim();
                        text = text.replace(/\s+/g, ' ');
                        return '"' + text.replace(/"/g, '""') + '"';
                    });
                    csvContent += rowData.join(',') + '\n';
                }
            });
            
            // Create and download CSV file
            setTimeout(() => {
                try {
                    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
                    const link = document.createElement('a');
                    const url = URL.createObjectURL(blob);
                    
                    const now = new Date();
                    const timestamp = now.getFullYear().toString() + 
                                    String(now.getMonth() + 1).padStart(2, '0') + 
                                    String(now.getDate()).padStart(2, '0') + '_' +
                                    String(now.getHours()).padStart(2, '0') + 
                                    String(now.getMinutes()).padStart(2, '0');
                    
                    const filename = 'Exam_Questions_' + timestamp + '.csv';
                    
                    link.setAttribute('href', url);
                    link.setAttribute('download', filename);
                    link.style.visibility = 'hidden';
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                    
                    hideLoading();
                    showExportMessage('CSV file "' + filename + '" downloaded successfully!', 'success');
                } catch (error) {
                    hideLoading();
                    showExportMessage('Error exporting to CSV. Please try again.', 'error');
                    console.error('Export error:', error);
                }
            }, 1000);
        }

        function exportData() {
            exportToExcel();
        }

        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'flex';
        }

        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }

        function showExportMessage(message, type) {
            // Create a temporary message element since we're using JSP messages now
            const messageDiv = document.createElement('div');
            messageDiv.className = `message message-${type}`;
            messageDiv.innerHTML = 
                '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-triangle') + '"></i>' +
                '<span>' + message + '</span>';
            
            // Insert after the floating stats
            const floatingStats = document.getElementById('floatingStats');
            floatingStats.parentNode.insertBefore(messageDiv, floatingStats.nextSibling);
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                messageDiv.style.opacity = '0';
                setTimeout(() => {
                    if (messageDiv.parentNode) {
                        messageDiv.parentNode.removeChild(messageDiv);
                    }
                }, 300);
            }, 5000);
        }

        // Add smooth scrolling for better UX
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });

        // Add interactive hover effects for table rows
        document.addEventListener('DOMContentLoaded', function() {
            const tableRows = document.querySelectorAll('.data-table tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.02)';
                    this.style.boxShadow = '0 4px 20px rgba(0,0,0,0.1)';
                });
                
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1)';
                    this.style.boxShadow = 'none';
                });
            });
        });

        // Add input field focus animations
        document.querySelectorAll('.input-field').forEach(field => {
            field.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateY(-2px)';
            });
            
            field.addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>