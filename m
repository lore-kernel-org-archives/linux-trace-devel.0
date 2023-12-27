Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BF53C0D
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Dec 2023 04:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8954AC433C8
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Dec 2023 04:10:14 +0000 (UTC)
Date: Tue, 26 Dec 2023 23:10:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add tep_get_sub_buffer_data_size()
Message-ID: <20231226231007.444daed0@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add an API to be able to read the header page file and return the data size of
the sub buffers. This is the total size of the sub buffer minus the meta
data.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-page_size.txt |  6 +++++-
 Documentation/libtraceevent.txt           |  1 +
 include/traceevent/event-parse.h          |  1 +
 src/event-parse-api.c                     | 14 ++++++++++++++
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-page_size.txt b/Documentation/libtraceevent-page_size.txt
index 0264e528e08a..18fa5aec9402 100644
--- a/Documentation/libtraceevent-page_size.txt
+++ b/Documentation/libtraceevent-page_size.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_get_page_size, tep_set_page_size, tep_get_sub_buffer_size - Get / set the size of a memory page on
+tep_get_page_size, tep_set_page_size, tep_get_sub_buffer_data_size, tep_get_sub_buffer_size - Get / set the size of a memory page on
 the machine, where the trace is generated
 
 SYNOPSIS
@@ -15,6 +15,7 @@ SYNOPSIS
 int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
 void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
 int *tep_get_sub_buffer_size*(struct tep_handle pass:[*]_tep_);
+int *tep_get_sub_buffer_data_size*(struct tep_handle pass:[*]_tep_);
 int *tep_get_sub_buffer_commit_offset*(struct tep_handle pass:[*]_tep_);
 --
 
@@ -33,6 +34,9 @@ The *tep_get_sub_buffer_size()* returns the size of each "sub buffer" of the
 ring buffer. The Linux kernel ring buffer is broken up into sections called
 sub buffers. This returns the size of those buffers.
 
+The *tep_get_sub_buffer_data_size()* returns the size of just the data portion
+of the sub buffers.
+
 The *tep_get_sub_buffer_commit_offset()* returns the offset on the sub buffer
 that holds the committed portion of data. This number contains the index from
 the data portion of the sub buffer that is the end of the last element on the
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index d1aef40804e3..26e3ad2523db 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -27,6 +27,7 @@ Management of tep handler data structure and access of its members:
 	int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
 	int *tep_get_sub_buffer_size*(struct tep_handle pass:[*]_tep_);
+	int *tep_get_sub_buffer_data_size*(struct tep_handle pass:[*]_tep_);
 	int *tep_get_sub_buffer_commit_offset*(struct tep_handle pass:[*]_tep_);
 	int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
 	int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index adfb770aa4ee..c03f45926996 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -588,6 +588,7 @@ int tep_get_long_size(struct tep_handle *tep);
 void tep_set_long_size(struct tep_handle *tep, int long_size);
 int tep_get_page_size(struct tep_handle *tep);
 int tep_get_sub_buffer_size(struct tep_handle *tep);
+int tep_get_sub_buffer_data_size(struct tep_handle *tep);
 int tep_get_sub_buffer_commit_offset(struct tep_handle *tep);
 void tep_set_page_size(struct tep_handle *tep, int _page_size);
 bool tep_is_file_bigendian(struct tep_handle *tep);
diff --git a/src/event-parse-api.c b/src/event-parse-api.c
index 1a9457352875..fd03daf310ea 100644
--- a/src/event-parse-api.c
+++ b/src/event-parse-api.c
@@ -262,6 +262,20 @@ void tep_set_page_size(struct tep_handle *tep, int _page_size)
 		tep->page_size = _page_size;
 }
 
+/**
+ * tep_get_sub_buffer_data_size - get the size of the data portion
+ * @tep: The handle to the tep to get the data size from
+ *
+ * Returns the size of the data portion of the sub buffer
+ */
+int tep_get_sub_buffer_data_size(struct tep_handle *tep)
+{
+	if (!tep)
+		return -1;
+
+	return tep->header_page_data_size;
+}
+
 /**
  * tep_get_sub_buffer_size - get the size of a trace buffer page
  * @tep: a handle to the tep_handle
-- 
2.42.0

