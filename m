Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1D82117
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F266EC43390;
	Wed, 10 Jan 2024 03:00:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNOqD-00000000LLw-2sFt;
	Tue, 09 Jan 2024 22:01:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6/7] libtracefs: Add tracefs_mapped_is_supported() API
Date: Tue,  9 Jan 2024 21:51:50 -0500
Message-ID: <20240110030116.81837-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240110030116.81837-1-rostedt@goodmis.org>
References: <20240110030116.81837-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracefs_mapped_is_supported() which returns true if tracefs mapping is
supported and false if it is not or an error occurred.

This is useful so that an application can decide to do things differently if
mapping is supported or not.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-cpu-map.txt |  9 ++++++++-
 Documentation/libtracefs.txt         |  1 +
 include/tracefs.h                    |  1 +
 src/tracefs-record.c                 | 19 +++++++++++++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-cpu-map.txt b/Documentation/libtracefs-cpu-map.txt
index ed62c96f83a1..d961123b55a8 100644
--- a/Documentation/libtracefs-cpu-map.txt
+++ b/Documentation/libtracefs-cpu-map.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_cpu_open_mapped, tracefs_cpu_is_mapped, tracefs_cpu_map, tracefs_cpu_unmap - Memory mapping of the ring buffer
+tracefs_cpu_open_mapped, tracefs_cpu_is_mapped, tracefs_mapped_is_supported, tracefs_cpu_map, tracefs_cpu_unmap - Memory mapping of the ring buffer
 
 SYNOPSIS
 --------
@@ -12,6 +12,7 @@ SYNOPSIS
 *#include <tracefs.h>*
 
 bool *tracefs_cpu_is_mapped*(struct tracefs_cpu pass:[*]tcpu);
+bool *tracefs_mapped_is_supported*(void);
 int *tracefs_cpu_map*(struct tracefs_cpu pass:[*]tcpu);
 void *tracefs_cpu_unmap*(struct tracefs_cpu pass:[*]tcpu);
 struct tracefs_cpu pass:[*]*tracefs_cpu_open_mapped*(struct tracefs_instance pass:[*]instance,
@@ -45,6 +46,9 @@ its ring buffer memory mapped and false otherwise. This does not return whether
 not that the kernel supports memory mapping, but that can usually be determined
 by calling *tracefs_cpu_map()*.
 
+The *tracefs_mapped_is_supported()* returns true if the ring buffer can be
+memory mapped.
+
 The *tracefs_cpu_map()* function will attempt to map the ring buffer associated
 to _tcpu_ if it is not already mapped.
 
@@ -62,6 +66,9 @@ RETURN VALUE
 *tracefs_cpu_is_mapped()* returns true if the given _tcpu_ has its ring buffer
 memory mapped or false otherwise.
 
+*tracefs_mapped_is_supported()* returns true if the tracing ring buffer can be
+memory mapped or false if it cannot be or an error occurred.
+
 *tracefs_cpu_map()* returns 0 on success and -1 on error in mapping. If 0 is
 returned then *tracefs_cpu_is_mapped()* will return true afterward, or false
 if the mapping failed.
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 9c3cc3ea3c06..860e2be7d96a 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -148,6 +148,7 @@ Trace stream:
 
 Memory mapping the ring buffer:
 	bool *tracefs_cpu_is_mapped*(struct tracefs_cpu pass:[*]tcpu);
+	bool *tracefs_mapped_is_supported*(void);
 	int *tracefs_cpu_map*(struct tracefs_cpu pass:[*]tcpu);
 	void *tracefs_cpu_unmap*(struct tracefs_cpu pass:[*]tcpu);
 	struct tracefs_cpu pass:[*]*tracefs_cpu_open_mapped*(struct tracefs_instance pass:[*]instance,
diff --git a/include/tracefs.h b/include/tracefs.h
index 8569171247b7..b6e0f6b3c851 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -695,6 +695,7 @@ int tracefs_snapshot_free(struct tracefs_instance *instance);
 
 /* Memory mapping of ring buffer */
 bool tracefs_cpu_is_mapped(struct tracefs_cpu *tcpu);
+bool tracefs_mapped_is_supported(void);
 int tracefs_cpu_map(struct tracefs_cpu *tcpu);
 void tracefs_cpu_unmap(struct tracefs_cpu *tcpu);
 struct tracefs_cpu *tracefs_cpu_open_mapped(struct tracefs_instance *instance,
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index 59260da0e32c..932e8b44775b 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -317,6 +317,25 @@ bool tracefs_cpu_is_mapped(struct tracefs_cpu *tcpu)
 	return tcpu->mapping != NULL;
 }
 
+/**
+ * tracefs_mapped_is_supported - find out if memory mapping is supported
+ *
+ * Return true if the ring buffer can be memory mapped, or false on
+ * error or it cannot be.
+ */
+bool tracefs_mapped_is_supported(void)
+{
+	struct tracefs_cpu *tcpu;
+	bool ret;
+
+	tcpu = tracefs_cpu_open_mapped(NULL, 0, false);
+	if (!tcpu)
+		return false;
+	ret = tracefs_cpu_is_mapped(tcpu);
+	tracefs_cpu_close(tcpu);
+	return ret;
+}
+
 int tracefs_cpu_map(struct tracefs_cpu *tcpu)
 {
 	if (tcpu->mapping)
-- 
2.43.0

