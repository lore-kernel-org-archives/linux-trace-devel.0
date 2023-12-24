Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7685D297
	for <linux-trace-devel@vger.kernel.org>; Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840F2C433C7;
	Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rHTzL-00000004VxO-3kdD;
	Sun, 24 Dec 2023 14:18:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/6] kbuffer: Add kbuffer_read_buffer()
Date: Sun, 24 Dec 2023 14:16:00 -0500
Message-ID: <20231224191813.1076074-4-rostedt@goodmis.org>
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

The kbuffer_read_buffer() function will fill the given buffer from the
kbuf the same way the kernel would do a read system call. That is, if the
length len is less than the sub buffer size, or the current index is
non-zero, it will start from the next event to read, and create buffer as a new
sub buffer (with a timestamp and commit header) with that event that was found
and including all events after that can fit within len.

The len must include the size of the sub buffer header as
well as the events to include. That is, len is the allocate size of buffer
that can be filled.  The return from this function is the index of the end of
the last event that was added.  If there are no more events then zero is
returned, and if the buffer can not copy any events because len was too small,
then -1 is returned.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-kbuffer-read.txt |  19 +-
 Documentation/libtraceevent.txt              |   1 +
 include/traceevent/kbuffer.h                 |   1 +
 src/kbuffer-parse.c                          | 172 ++++++++++++++++---
 4 files changed, 171 insertions(+), 22 deletions(-)

diff --git a/Documentation/libtraceevent-kbuffer-read.txt b/Documentation/libtraceevent-kbuffer-read.txt
index 68184ad69ed7..ade42f33d8fc 100644
--- a/Documentation/libtraceevent-kbuffer-read.txt
+++ b/Documentation/libtraceevent-kbuffer-read.txt
@@ -4,7 +4,7 @@ libtraceevent(3)
 NAME
 ----
 kbuffer_read_event, kbuffer_next_event, kbuffer_missed_events, kbuffer_event_size, kbuffer_curr_size,
-kbuffer_curr_offset, kbuffer_curr_index -
+kbuffer_curr_offset, kbuffer_curr_index, kbuffer_read_buffer -
 Functions to read through the kbuffer sub buffer.
 
 SYNOPSIS
@@ -21,6 +21,7 @@ int *kbuffer_event_size*(struct kbuffer pass:[*]_kbuf_);
 int *kbuffer_curr_size*(struct kbuffer pass:[*]_kbuf_);
 int *kbuffer_curr_offset*(struct kbuffer pass:[*]_kbuf_);
 int *kbuffer_curr_index*(struct kbuffer pass:[*]_kbuf_);
+int *kbuffer_read_buffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_buffer_, int _len_);
 --
 
 DESCRIPTION
@@ -64,6 +65,18 @@ The *kbuffer_curr_index()* function returns the index from the beginning of the
 portion of the sub-buffer where the current evnet's meta data is located.
 The first event will likely be zero, but may not be if there's a timestamp attached to it.
 
+The *kbuffer_read_buffer()* function will fill the given _buffer_ from the _kbuf_ the same
+way the kernel would do a read system call. That is, if the length _len_ is less than the
+sub buffer size, or the kbuffer current index is non-zero, it will start copying from the
+_kbuf_ current event and create _buffer_ as a new sub buffer (with a timestamp
+and commit header) with that event that was found and including all events after that can
+fit within _len_. The _len_ must include the size of the sub buffer header as well as the
+events to include. That is, _len_ is the allocate size of _buffer_ that can be filled.
+The return from this function is the index of the end of the last event that was added.
+If there are no more events then zero is returned, and if the buffer can not
+copy any events because _len_ was too small, then -1 is returned.
+
+
 RETURN VALUE
 ------------
 *kbuffer_read_event()* returns the event that the _kbuf_ descriptor is currently at,
@@ -92,6 +105,10 @@ sub-buffer.
 *kbuf_curr_index()* returns the index of the current record from the beginning of the _kbuf_
 data section.
 
+*kbuf_read_buffer()* returns the index of the end of the last event that was filled in
+_buffer_. If there are no more events to copy from _start_ then 0 is returned. If _len_
+is not big enough to hold any events, then -1 is returned.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 07b9a2dffb68..407c06809269 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -195,6 +195,7 @@ kbuffer parsing:
 	int *kbuffer_curr_size*(struct kbuffer pass:[*]_kbuf_);
 	int *kbuffer_curr_offset*(struct kbuffer pass:[*]_kbuf_);
 	int *kbuffer_curr_index*(struct kbuffer pass:[*]_kbuf_);
+	int *kbuffer_read_buffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_buffer_, int _start_, int _len_);
 --
 
 DESCRIPTION
diff --git a/include/traceevent/kbuffer.h b/include/traceevent/kbuffer.h
index ca638bc06dba..e5d377bf0e60 100644
--- a/include/traceevent/kbuffer.h
+++ b/include/traceevent/kbuffer.h
@@ -42,6 +42,7 @@ unsigned int kbuffer_ptr_delta(struct kbuffer *kbuf, void *ptr);
 void *kbuffer_translate_data(int swap, void *data, unsigned int *size);
 
 void *kbuffer_read_at_offset(struct kbuffer *kbuf, int offset, unsigned long long *ts);
+int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len);
 
 int kbuffer_curr_index(struct kbuffer *kbuf);
 
diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 390a789b20fb..b86c8f0b9d4f 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -86,6 +86,42 @@ static int do_swap(struct kbuffer *kbuf)
 		ENDIAN_MASK;
 }
 
+static unsigned long long swap_8(unsigned long data)
+{
+	return ((data & 0xffULL) << 56) |
+		((data & (0xffULL << 8)) << 40) |
+		((data & (0xffULL << 16)) << 24) |
+		((data & (0xffULL << 24)) << 8) |
+		((data & (0xffULL << 32)) >> 8) |
+		((data & (0xffULL << 40)) >> 24) |
+		((data & (0xffULL << 48)) >> 40) |
+		((data & (0xffULL << 56)) >> 56);
+}
+
+static unsigned int swap_4(unsigned int data)
+{
+	return ((data & 0xffULL) << 24) |
+		((data & (0xffULL << 8)) << 8) |
+		((data & (0xffULL << 16)) >> 8) |
+		((data & (0xffULL << 24)) >> 24);
+}
+
+static void write_8(bool do_swap, void *ptr, unsigned long long data)
+{
+	if (do_swap)
+		*(unsigned long long *)ptr = swap_8(data);
+	else
+		*(unsigned long long *)ptr = data;
+}
+
+static void write_4(bool do_swap, void *ptr, unsigned int data)
+{
+	if (do_swap)
+		*(unsigned int *)ptr = swap_4(data);
+	else
+		*(unsigned int *)ptr = data;
+}
+
 static unsigned long long __read_8(void *ptr)
 {
 	unsigned long long data = *(unsigned long long *)ptr;
@@ -96,18 +132,8 @@ static unsigned long long __read_8(void *ptr)
 static unsigned long long __read_8_sw(void *ptr)
 {
 	unsigned long long data = *(unsigned long long *)ptr;
-	unsigned long long swap;
 
-	swap = ((data & 0xffULL) << 56) |
-		((data & (0xffULL << 8)) << 40) |
-		((data & (0xffULL << 16)) << 24) |
-		((data & (0xffULL << 24)) << 8) |
-		((data & (0xffULL << 32)) >> 8) |
-		((data & (0xffULL << 40)) >> 24) |
-		((data & (0xffULL << 48)) >> 40) |
-		((data & (0xffULL << 56)) >> 56);
-
-	return swap;
+	return swap_8(data);
 }
 
 static unsigned int __read_4(void *ptr)
@@ -120,14 +146,8 @@ static unsigned int __read_4(void *ptr)
 static unsigned int __read_4_sw(void *ptr)
 {
 	unsigned int data = *(unsigned int *)ptr;
-	unsigned int swap;
 
-	swap = ((data & 0xffULL) << 24) |
-		((data & (0xffULL << 8)) << 8) |
-		((data & (0xffULL << 16)) >> 8) |
-		((data & (0xffULL << 24)) >> 24);
-
-	return swap;
+	return swap_4(data);
 }
 
 static unsigned long long read_8(struct kbuffer *kbuf, void *ptr)
@@ -295,6 +315,13 @@ static unsigned int ts4host(struct kbuffer *kbuf,
 		return type_len_ts >> 5;
 }
 
+static void set_curr_to_end(struct kbuffer *kbuf)
+{
+	kbuf->curr = kbuf->size;
+	kbuf->next = kbuf->size;
+	kbuf->index = kbuf->size;
+}
+
 /*
  * Linux 2.6.30 and earlier (not much ealier) had a different
  * ring buffer format. It should be obsolete, but we handle it anyway.
@@ -339,9 +366,7 @@ static unsigned int old_update_pointers(struct kbuffer *kbuf)
 
 	case OLD_RINGBUF_TYPE_TIME_STAMP:
 		/* should never happen! */
-		kbuf->curr = kbuf->size;
-		kbuf->next = kbuf->size;
-		kbuf->index = kbuf->size;
+		set_curr_to_end(kbuf);
 		return -1;
 	default:
 		if (len)
@@ -846,3 +871,108 @@ kbuffer_raw_get(struct kbuffer *kbuf, void *subbuf, struct kbuffer_raw_info *inf
 
 	return info;
 }
+
+/**
+ * kbuffer_read_buffer - read a buffer like the kernel would perform a read
+ * @kbuf: the kbuffer handle
+ * @buffer: where to write the data into
+ * @len; The length of @buffer
+ *
+ * This will read the saved sub buffer within @kbuf like the systemcall
+ * of read() to the trace_pipe_raw would do. That is, if either @len
+ * can not fit the entire buffer, or if the current index in @kbuf
+ * is non-zero, it will write to @buffer a new subbuffer that could be
+ * loaded into kbuffer_load_subbuffer(). That is, it will write into
+ * @buffer a  legitimate sub-buffer with a header and all that has the
+ * proper timestamp and commit fields.
+ *
+ * Returns the index after the last element written.
+ * 0 if nothing was copied.
+ * -1 on error (which includes not having enough space in len to
+ *   copy the subbuffer header or any of its content. In otherwords,
+ *   do not try again!
+ *
+ * @kbuf current index will be set to the next element to read.
+ */
+int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
+{
+	int subbuf_size = kbuf->start + kbuf->size;
+	unsigned long long ts;
+	unsigned int type_len_ts;
+	bool do_swap = false;
+	int last_next;
+	int save_curr;
+
+	if (!kbuf->curr && len >= subbuf_size) {
+		memcpy(buffer, kbuf->subbuffer, subbuf_size);
+		set_curr_to_end(kbuf);
+		return kbuf->size;
+	}
+
+	/* Are we at the end of the buffer */
+	if (kbuf->curr >= kbuf->size)
+		return 0;
+
+	/* If we can not copy anyting, return -1 */
+	if (len < kbuf->start)
+		return -1;
+
+	/* Check if the first event can fit */
+	if (len < (kbuf->next - kbuf->curr) + kbuf->start)
+		return -1;
+
+	if (kbuf->read_8 ==  __read_8_sw)
+		do_swap = true;
+
+	/* Have this subbuffer timestamp be the current timestamp */
+	write_8(do_swap, buffer, kbuf->timestamp);
+
+	len -= kbuf->start;
+
+	save_curr = kbuf->curr;
+
+	/* Copy the rest of the buffer if it fits */
+	if (len >= kbuf->size - kbuf->curr) {
+		set_curr_to_end(kbuf);
+		last_next = kbuf->size;
+	} else {
+		/*
+		 * The length doesn't hold the rest,
+		 * need to find the last that fits
+		 */
+
+		/* Due to timestamps, we must save the current next to use */
+		last_next = kbuf->next;
+
+		while (len > kbuf->next - save_curr) {
+			last_next = kbuf->next;
+			if (!kbuffer_next_event(kbuf, &ts))
+				break;
+		}
+	}
+
+	len = last_next - save_curr;
+	/* No event was found? */
+	if (!len)
+		return 0;
+
+	memcpy(buffer + kbuf->start, kbuf->data + save_curr, len);
+
+	/* Zero out the delta, as the sub-buffer has the timestamp */
+	type_len_ts = read_4(kbuf, buffer + kbuf->start);
+
+	if (kbuf->flags & KBUFFER_FL_BIG_ENDIAN)
+		type_len_ts &= ~(((1 << 27) - 1));
+	else
+		type_len_ts &= ((1 << 5) - 1);
+
+	write_4(do_swap, buffer + kbuf->start, type_len_ts);
+
+	/* Update the size */
+	if (kbuf->read_long == __read_long_8)
+		write_8(do_swap, buffer + 8, len);
+	else
+		write_4(do_swap, buffer + 8, len);
+
+	return last_next;
+}
-- 
2.42.0

