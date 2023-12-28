Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C2110964
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302A9C4339A;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKp-00000000EJZ-0WHb;
	Thu, 28 Dec 2023 16:54:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 15/22] libtracefs: Add kerneldoc comments to tracefs_instance_set_buffer_size()
Date: Thu, 28 Dec 2023 16:52:10 -0500
Message-ID: <20231228215433.54854-16-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228215433.54854-1-rostedt@goodmis.org>
References: <20231228215433.54854-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When the API tracefs_instance_set_buffer_size() was added, the kerneldoc
associated to it was not.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 4e7434157109..2162424ad3a7 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -402,6 +402,18 @@ ssize_t tracefs_instance_get_buffer_size(struct tracefs_instance *instance, int
 	return size;
 }
 
+/**
+ * tracefs_instance_set_buffer_size - modify the ring buffer size
+ * @instance: The instance to modify (NULL for the top level)
+ * @size: The size in kilobytes to to set the size to
+ * @cpu: the CPU to set it to (-1 for all CPUs)
+ *
+ * Sets the size of the ring buffer per CPU buffers. If @cpu is negative,
+ * then it sets the ring buffer size for all the per CPU buffers, otherwise
+ * it only sets the per CPU buffer specified by @cpu.
+ *
+ * Returns 0 on success and -1 on error.
+ */
 int tracefs_instance_set_buffer_size(struct tracefs_instance *instance, size_t size, int cpu)
 {
 	char *path;
-- 
2.42.0

