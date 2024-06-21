<template>
    <div class="branch-container">
        <div slot="header" class="clearfix">
          <span>Database Manual</span>
        </div>

        <a :href="downloadUrl" download="file.pdf">
            <button>Download PDF</button>
          </a>
          
      <el-button type="primary" @click="goToHomePage" style="margin-top: 20px;">
        Back to Home
      </el-button>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        downloadUrl: 'http://staff.ustc.edu.cn/~jianmin/2024/ai2024/coursework/1&7.pdf'  // 替换成实际的下载链接
      };
    }
  };
  </script>
  