<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Question Bank - Excel Upload</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <style>
    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .upload-container { max-width: 800px; margin: 50px auto; background: rgba(255, 255, 255, 0.95); border-radius: 20px; box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1); overflow: hidden; }
    .upload-header { background: linear-gradient(45deg, #667eea, #764ba2); color: white; padding: 30px; text-align: center; }
    .upload-body { padding: 40px; }
    .file-upload-area { border: 3px dashed #667eea; border-radius: 15px; padding: 40px; text-align: center; transition: all 0.3s ease; background: #f8f9ff; }
    .file-upload-area:hover { border-color: #764ba2; background: #f0f2ff; }
    .file-upload-area.dragover { border-color: #28a745; background: #e8f5e8; }
    .upload-icon { font-size: 3rem; color: #667eea; margin-bottom: 20px; }
    .file-input { display: none; }
    .upload-btn { background: linear-gradient(45deg, #667eea, #764ba2); border: none; color: white; padding: 12px 30px; border-radius: 25px; font-weight: 600; transition: all 0.3s ease; }
    .upload-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); }
    .selected-file { background: #e8f5e8; border: 1px solid #28a745; padding: 15px; border-radius: 10px; margin-top: 20px; display: none; }
    .loading { display: none; text-align: center; padding: 20px; }
    .spinner { border: 4px solid #f3f3f3; border-top: 4px solid #667eea; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite; margin: 0 auto 15px; }
    @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    .info-section { background: #e3f2fd; padding: 20px; border-radius: 10px; margin-bottom: 30px; }
    .format-info { font-size: 0.9rem; color: #666; }
    .alert-custom { border-radius: 10px; border: none; padding: 15px 20px; margin-bottom: 20px; }
    .alert-success { background: linear-gradient(45deg, #28a745, #20c997); color: black; }
    .alert-danger { background: linear-gradient(45deg, #dc3545, #e74c3c); color: black; }
    .alert-warning { background: linear-gradient(45deg, #ffc107, #ffcd38); color: #333; }
    .feedback-list { max-height: 300px; overflow-y: auto; padding: 15px; background: #f8f9fa; border-radius: 8px; margin-top: 15px; }
    .feedback-item { padding: 10px; margin-bottom: 10px; background: white; border-radius: 5px; }
    .feedback-item.error { border-left: 4px solid #dc3545; }
    .feedback-item.warning { border-left: 4px solid #ffc107; }
  </style>
</head>
<body>
  <div class="upload-container">
    <div class="upload-header">
		<img src="${pageContext.request.contextPath}/images/etsBlackLogo.png" style="height:69px" alt="ETS Logo" class="logo">
      <h2><i class="fas fa-upload me-3"></i>Question Bank Excel Upload</h2>
      <p class="mb-0">Upload your Excel file with questions and validation will be performed automatically</p>
    </div>

    <div class="upload-body">
		<div class="mb-3">
		    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
		      <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
		    </a>
		  </div>
      <c:if test="${not empty success}">
        <div class="alert alert-success alert-custom">
          <i class="fas fa-check-circle me-2"></i>${success}
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger alert-custom">
          <i class="fas fa-exclamation-circle me-2"></i>${error}
        </div>
      </c:if>

      <c:if test="${not empty allFeedback}">
        <div class="alert ${not empty error ? 'alert-danger' : 'alert-warning'} alert-custom">
          <h5><i class="fas fa-exclamation-triangle me-2"></i>File Processing Feedback</h5>
          <p>Please review the following issues found in your Excel file:</p>
          <div class="feedback-list">
            <c:forEach var="item" items="${allFeedback}">
              <c:set var="isError" value="${fn:startsWith(item, 'ERROR:')}" />
              <div class="feedback-item ${isError ? 'error' : 'warning'}">
                <i class="fas ${isError ? 'fa-times-circle' : 'fa-exclamation-circle'} me-2"></i>
                <c:choose>
                    <c:when test="${isError}">
                        ${fn:substringAfter(item, 'ERROR: ')}
                    </c:when>
                    <c:otherwise>
                        ${fn:substringAfter(item, 'WARNING: ')}
                    </c:otherwise>
                </c:choose>
              </div>
            </c:forEach>
          </div>
        </div>
      </c:if>

      <div class="info-section">
        <h5><i class="fas fa-info-circle me-2"></i>Required Excel Format</h5>
        <div class="format-info">
          <p><strong>Columns (in order):</strong></p>
          <p>S.no | Subject | Topic | Subtopic | Grade | Difficulty Level | Question | Option 1 | Option 2 | Option 3 | Option 4 | Correct Answer | Step 1 | References | Status</p>
          <p><strong>Validation Rules:</strong></p>
          <ul>
            <li>No duplicate questions allowed</li>
            <li>Each question must have exactly 4 options</li>
            <li>All options must be unique for each question</li>
            <li>Only .xlsx files are accepted</li>
          </ul>
        </div>
      </div>

      <form id="uploadForm" action="/questions/upload" method="post" enctype="multipart/form-data">
		
		<!-- Work Order Input -->
		  <div class="mb-4">
		    <label for="workOrder" class="form-label fw-bold">
		      Work Order
		    </label>
		    <input type="text" id="workorder" name="workorder" class="form-control" 
		           placeholder="Enter Work Order ID" required>
		  </div>
		
        <div class="file-upload-area" id="fileUploadArea">
          <div class="upload-icon"><i class="fas fa-cloud-upload-alt"></i></div>
          <h4>Drag & Drop your Excel file here</h4>
          <p class="text-muted">or click to browse</p>
          <input type="file" id="fileInput" name="file" class="file-input" accept=".xlsx" required>
          <button type="button" class="btn upload-btn" id="browseBtn">
            <i class="fas fa-folder-open me-2"></i>Browse Files
          </button>
        </div>

        <div class="selected-file" id="selectedFile">
          <div class="d-flex align-items-center">
            <i class="fas fa-file-excel text-success me-3" style="font-size: 1.5rem;"></i>
            <div>
              <strong id="fileName"></strong>
              <div class="text-muted" id="fileSize"></div>
            </div>
            <button type="button" class="btn btn-sm btn-outline-danger ms-auto" onclick="clearFile()">
              <i class="fas fa-times"></i>
            </button>
          </div>
        </div>

        <div class="text-center mt-4">
          <button type="submit" class="btn upload-btn btn-lg" id="submitBtn" disabled>
            <i class="fas fa-upload me-2"></i>Upload & Validate
          </button>
        </div>
      </form>

      <div class="loading" id="loadingIndicator">
        <div class="spinner"></div>
        <p>Processing your file... Please wait</p>
      </div>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function () {
      const fileInput = document.getElementById('fileInput');
      const fileUploadArea = document.getElementById('fileUploadArea');
      const selectedFile = document.getElementById('selectedFile');
      const fileName = document.getElementById('fileName');
      const fileSize = document.getElementById('fileSize');
      const submitBtn = document.getElementById('submitBtn');
      const uploadForm = document.getElementById('uploadForm');
      const loadingIndicator = document.getElementById('loadingIndicator');
      const browseBtn = document.getElementById('browseBtn');

      browseBtn.addEventListener('click', () => fileInput.click());

      fileUploadArea.addEventListener('dragover', e => {
        e.preventDefault();
        fileUploadArea.classList.add('dragover');
      });

      fileUploadArea.addEventListener('dragleave', e => {
        e.preventDefault();
        fileUploadArea.classList.remove('dragover');
      });

      fileUploadArea.addEventListener('drop', e => {
        e.preventDefault();
        fileUploadArea.classList.remove('dragover');
        const files = e.dataTransfer.files;
        if (files.length > 0) {
          fileInput.files = files;
          handleFileSelect();
        }
      });

      fileInput.addEventListener('change', handleFileSelect);

      function handleFileSelect() {
        const file = fileInput.files[0];
        if (file) {
          if (!file.name.endsWith('.xlsx')) {
            alert('Please select an Excel file (.xlsx)');
            clearFile();
            return;
          }
          fileName.textContent = file.name;
          fileSize.textContent = formatFileSize(file.size);
          selectedFile.style.display = 'block';
          submitBtn.disabled = false;
        }
      }

      function clearFile() {
        fileInput.value = '';
        selectedFile.style.display = 'none';
        submitBtn.disabled = true;
      }

      function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
      }

      uploadForm.addEventListener('submit', function (e) {
        if (!fileInput.files[0]) {
          alert('Please select a file first');
          e.preventDefault();
          return;
        }
        loadingIndicator.style.display = 'block';
        submitBtn.disabled = true;
      });
    });
  </script>
</body>
</html>