Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE25D2E2
	for <linux-trace-devel@vger.kernel.org>; Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CC5C433C8;
	Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rHTzL-00000004VxG-38q4;
	Sun, 24 Dec 2023 14:18:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/6] libtraceevent: Add tep_get_sub_buffer_commit_offset()
Date: Sun, 24 Dec 2023 14:15:58 -0500
Message-ID: <20231224191813.1076074-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231224191813.1076074-1-rostedt@goodmis.org>
References: <20231224191813.1076074-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a function that retrieves the offset on the sub-buffer to find where the
"commit" variable of the sub buffer is located.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-page_size.txt |  9 +++++++++
 Documentation/libtraceevent.txt           |  1 +
 include/traceevent/event-parse.h          |  1 +
 src/event-parse-api.c                     | 15 +++++++++++++++
 4 files changed, 26 insertions(+)

diff --git a/Documentation/libtraceevent-page_size.txt b/Documentation/libtraceevent-page_size.txt
index 6d0dd36e3d68..0264e528e08a 100644
--- a/Documentation/libtraceevent-page_size.txt
+++ b/Documentation/libtraceevent-page_size.txt
@@ -15,6 +15,7 @@ SYNOPSIS
 int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
 void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
 int *tep_get_sub_buffer_size*(struct tep_handle pass:[*]_tep_);
+int *tep_get_sub_buffer_commit_offset*(struct tep_handle pass:[*]_tep_);
 --
 
 DESCRIPTION
@@ -32,6 +33,11 @@ The *tep_get_sub_buffer_size()* returns the size of each "sub buffer" of the
 ring buffer. The Linux kernel ring buffer is broken up into sections called
 sub buffers. This returns the size of those buffers.
 
+The *tep_get_sub_buffer_commit_offset()* returns the offset on the sub buffer
+that holds the committed portion of data. This number contains the index from
+the data portion of the sub buffer that is the end of the last element on the
+sub buffer.
+
 RETURN VALUE
 ------------
 The *tep_get_page_size()* function returns size of the memory page, in bytes.
@@ -39,6 +45,9 @@ The *tep_get_page_size()* function returns size of the memory page, in bytes.
 The *tep_get_sub_buffer_size()* function returns the number of bytes each sub
 buffer is made up of.
 
+The *tep_get_sub_buffer_commit_offset()* function returns the location on the
+sub buffer that contains the index of the last element.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 2ae6628bd324..07b9a2dffb68 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -27,6 +27,7 @@ Management of tep handler data structure and access of its members:
 	int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
 	int *tep_get_sub_buffer_size*(struct tep_handle pass:[*]_tep_);
+	int *tep_get_sub_buffer_commit_offset*(struct tep_handle pass:[*]_tep_);
 	int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
 	int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
 	bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index e0785f7fe1d4..adfb770aa4ee 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -588,6 +588,7 @@ int tep_get_long_size(struct tep_handle *tep);
 void tep_set_long_size(struct tep_handle *tep, int long_size);
 int tep_get_page_size(struct tep_handle *tep);
 int tep_get_sub_buffer_size(struct tep_handle *tep);
+int tep_get_sub_buffer_commit_offset(struct tep_handle *tep);
 void tep_set_page_size(struct tep_handle *tep, int _page_size);
 bool tep_is_file_bigendian(struct tep_handle *tep);
 void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);
diff --git a/src/event-parse-api.c b/src/event-parse-api.c
index 268a58609419..1a9457352875 100644
--- a/src/event-parse-api.c
+++ b/src/event-parse-api.c
@@ -277,6 +277,21 @@ int tep_get_sub_buffer_size(struct tep_handle *tep)
 	return tep->header_page_data_size + tep->header_page_data_offset;
 }
 
+/**
+ * tep_get_sub_buffer_commit_offset - return offset of the commit location
+ * @tep: the handle to the tep_handle
+ *
+ * Returns the offset of where to find the "commit" field of the offset.
+ * Use tep_get_header_page_size() to find the size of the commit field.
+ */
+int tep_get_sub_buffer_commit_offset(struct tep_handle *tep)
+{
+	if (!tep)
+		return -1;
+
+	return tep->header_page_size_offset;
+}
+
 /**
  * tep_is_file_bigendian - return the endian of the file
  * @tep: a handle to the tep_handle
-- 
2.42.0

