Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792740230;
	b=iS2ST7DfE4oi8cKcSDPMjTyWkKX+ql9CbbG0FA+HOi+fPk+rALWDwGosdiQ3cTBnPvXy
	 0+XC6IP5ig5xTGb3Yr2Y3dhUa3Wjct5ecUNSmjcMnw+m7QnYQyFSjNMQBjdkzGnYr/INr
	 uD8mfqrhNyZcB6oQSF5CQ1uCv8JHR+8ImRTywWvzduWszNwMEGBB62FbqC/16ka19m2JH
	 bbCPZypWEdluWXUxjfi09PHIBK5tHhFnpIvC+hI+rhxhr9ox2GDorcsPqyUVax1u1O2Gy
	 29daVperzZ++N+nx7Htt6BRr3iZuRQ+Ff+24BJXQA1Vj0FKvF7w0obdXy6PsPkU9SzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792740230;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IFiGDC9iu7kiNid/lfgtydHECDG62LmJxyWpqEwSdLs=;
	b=YWOkRdVoYRSsFMXDmCAO+J/ZL1+/iApTMtQ1mIP+FRf/Ld9WEhDgyYD9tFRzABOh+bUH
	 7UqffnVVL/2lLKPzvslcRN754J4X7Hu+t2TnihzwwhFWVV9QbC8m4WMrL5oY5MFT3umS/
	 AMUHcwjnv1U0Fjvz9mMxPojjPQ5Xi03T3ZLdXTJyi8gF2pSghg9rytWatCI+vg8o7tDEk
	 CtANH2XUFponFtek30LtaHron4YOydkT5VCwFC9KdB3YFGjdeS1IOPV2nI30H671W/u0N
	 yxGA4QmsCW4oXDwZYTbYwsguh13M0EUy02jQ5WdBNdn+mTStsxbboDwAAGvHbN0NzkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OK5xdYUd;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7D8606A31A
	for <linux-trace-devel@vger.kernel.org>; Fri, 23 Oct 2026 07:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC7D8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OK5xdYUd
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e8fe8e343fso2631095ad.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Oct 2026 00:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792740229; x=1793345029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IFiGDC9iu7kiNid/lfgtydHECDG62LmJxyWpqEwSdLs=;
        b=OK5xdYUdfW3KfSgIs+Wxxz5WIEYseKq10NObpIxHc3Z2ky1JOoG4mB494MQUtADSX9
         awV8eH9ZsVegS53ITk7fZfe2nc5FM5zG2vRPlGfTwNdUnt4UOORNoxQrHdIiRfPa2cjS
         mHPmLq7o/10bssYLZfq4MEhBGAGzmlGPQ1sRLve/4u12JxWusZYlB9UQ+v4+ayyTnZia
         E+iZGq8SLB+nc7Shk/aIt+BJ+u3yl5YXHIJ+V9kB+MtJEfBCuDmvmV1c2pn8ftgArSkP
         QX/79K0uWGMKrKqtygB+owb5Oypzpa7U24Z3buwR11kZmkOMs6nwSyg+Rnt8YG371VVb
         +7Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792740229; x=1793345029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IFiGDC9iu7kiNid/lfgtydHECDG62LmJxyWpqEwSdLs=;
        b=ObRbzn2mzZ2mjB7ZfFXj/Ii+ru/52w18W15aV4tBz6E6O8MPifhq4trs7iNqWS13mP
         2i5WcPx5m0pE8Uo96OWsbembKtrgxGkzCMsJ49eJcLNn7mG8wfwg9JVzrpJlSVYdOjfv
         Dw6a38lb3vgnUp7YnBX2lV9upb23zax5GBtTqY2J2/ClS/iL1i7WsfkoOzLbY/07EkCC
         bdxCaB+aHT6D7xN39JvuU53welZAue5I8+BRduflJXmRhqJHRHM0vIWgxBU7qc1x28Ik
         xoB52oymwOjS+cvAXMZPfJu9cB5tDvbMxyjMb1lwVhvnoj+4A5OqOvSIyZp6i2pe3h8R
         dd/w==
X-Gm-Message-State: AFq9FYIicA5L2rB+zyMYTqxyKyEg4ud+hxXUgNpLHWkP3JcbjTcCZ6zl
	x28mcPCv7ERos/hAASksvrCD4tW5H+UcCiznFiKBvYvLm/9FjjUZHjwx
X-Gm-Gg: AYBFou3DGgkuCcXpNZ+JVBWP3DZ8UTlacan+DkoSBLxU5PzaiR12ftcmkMA5IwZ/M/q
	Z2VYr4ZGP/8rc5g1O+ZNbWe/0bDaI77tk1YS1fVOo4hCGJLOjOvvCd2B6IF5CcLhzTIKK+PLF7s
	MAczDlXwdWq5cKai5dssTjHH5swlJ26YiZJNuQ8fg5kdqecdFZ7QnV1whg1XjRq4oRz2SbSd+cS
	DFr3VnCa/vWhjsD8pGcuLbQ9LuXR1i63riahs4BFsQH06tBBPf7NEiaBHTfLEWC03ev1vrACfOi
	zuQMnYJipu5yG1TOO6NpQhcgI6eaTyoUd8CA+mf7OB2Vo3AS0DbcWmi1RUjyzUcCuizxXzbXCek
	02NELS8LBEGdBamM9G3CVNmQLgWXPgRiDaFF4wn75Ma1ayTJtf66YlVid6gi3eIq5UR5Zum3btv
	3vbe5WQPHzAHQR2dvPcMe19EtOgwvpnwIi8ZOoFRVHyF2WTM+Y7JwloLq8X9oicNnCTEUlAOh7x
	A/cHHYNnZ+RS4OvHHvqytpNsOPhHSj0W4W1jtd+EXNWgCfeRH5H4UPoKsDhBJEg4iN7FtSKOzyO
	XpLY5EEVlSDS6W1Xlcy2Tw==
X-Received: by 2002:a17:90b:2cc8:b0:3a4:b0a1:c7ed with SMTP id 98e67ed59e1d1-3adce3cac5bmr1087736a91.13.1792740228446;
        Fri, 23 Oct 2026 00:23:48 -0700 (PDT)
Received: from lipengfei28-ThinkStation-P368.mioffice.cn ([2408:8607:1b00:8:3783:b945:cdf2:bfce])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada490e5edsm7651055a91.8.2026.10.23.00.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:23:47 -0700 (PDT)
From: Li Pengfei <ljdlns1987@gmail.com>
X-Google-Original-From: Li Pengfei <lipengfei28@xiaomi.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
	lipengfei28@xiaomi.com
Subject: [PATCH v2] trace-cmd: add streaming CPU compression
Date: Fri, 23 Oct 2026 15:23:31 +0800
Message-Id: <20261023072331.2948729-1-lipengfei28@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020202454.277d4802@gandalf.local.home>
References: <20261020202454.277d4802@gandalf.local.home>
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add "trace-cmd record --stream-compression", which compresses the per
CPU data as it is recorded instead of keeping the raw ring buffer data
on disk and compressing it at the end. This lowers the temporary disk
space needed by long recordings.

The per CPU temporary file holds a chunk count followed by the chunks,
each prefixed with its compressed and uncompressed size. The count is
only known when the recorder exits, so it is reserved up front and
filled in afterwards, which requires a seekable output. Network, guest,
agent and FIFO recorders along with the maximum buffer mode are
rejected for that reason.

The reader indexes into a decompressed chunk in units of the sub buffer
size, so a chunk holds a whole number of sub buffers rather than of
system pages. Otherwise --subbuf-size would cut chunks in the middle of
a sub buffer.

The compressor owns the output file descriptor, so the data is read
into a buffer instead of spliced, the sub buffer padding is dropped as
the chunk framing already carries the sizes, and the partial sub buffer
left behind at the end of a recording is read out with
tracefs_cpu_flush() and fed to the compressor.

The recorder runs in its own process, cannot report a failure to the
writer and may not get to run any cleanup at all, so the CPU file is
marked as failed before the first byte is compressed. Once that marker
exists, any later read, flush or compression failure leaves it behind,
as does a SIGKILL, and only a stream that was written in full clears
it. The writer only checks how much it copied against the file size, so
it takes a CPU file as complete only when the marker is known to be
absent, and fails on anything it cannot tell apart from a recorder that
did not finish. Without that, the compressed bytes would be stored as
raw ring buffer pages.

Signed-off-by: Li Pengfei <lipengfei28@xiaomi.com>
---
Changes since v1:

 - The error state protocol is turned around. In v1 the recorder wrote a
   ".rawsize.error" marker on the way out, so a recorder that was killed,
   or one that failed before it could write anything, left no marker at
   all and the writer stored the compressed bytes as raw ring buffer
   pages. The marker is now created before the first byte is compressed
   and is cleared only once the stream has been written in full. Any
   read, flush or compression failure keeps it, as does a SIGKILL. The
   writer takes a CPU file as complete only when the marker is known to
   be absent, so a probe that fails for any reason other than ENOENT
   fails the recording. The protocol is written down in
   trace-cmd-private.h.

 - tracecmd_flush_recording() reports a negative flush to its caller
   instead of always returning the padded size, so a failure there
   reaches the marker protocol. It retries EINTR, as
   tracecmd_start_recording() already does. The return of
   tracefs_cpu_stop() is checked as well, since a buffer that stayed
   blocking turns a zero read into "nothing yet" rather than "done".

 - A chunk holds a whole number of sub buffers rather than of system
   pages, so --subbuf-size cannot cut a chunk in the middle of a sub
   buffer. The read buffer is sized from the sub buffer and moved off
   the stack.

 - No endian conversion for the reserved zero chunk count, and the
   combined tests with side effects in trace-compress.c are split.

 - The anonymous block in trace-record.c is a delete_compress_files()
   helper, the pointless maxkb handling is gone, as maxkb and streaming
   compression are mutually exclusive, the redundant NOSPLICE
   assignments in create_recorder_instance() are dropped, and the
   CMD_record_agent test is removed.

 - The struct formatting in trace-record.c is left alone.

 - --stream-compression is documented in the man page.

Your memory mapping patch and streaming compression do want each other,
as the latter is forced onto NOSPLICE, but they do not meet yet:
tracecmd_recorder_set_compression() sets NOSPLICE after the tracefs_cpu
has been opened. Nothing is broken, it just stays unmapped unless
--nosplice is also given. I have left that out of v2 rather than depend
on an unapplied patch.

Tested on x86_64 and arm64: record and report for zlib and zstd with and
without --stream-compression and --nosplice, extract, and the ENOSPC and
SIGKILL cases.
 .../trace-cmd/trace-cmd-record.1.txt          |  15 +
 .../include/private/trace-cmd-private.h       |  32 ++
 lib/trace-cmd/include/trace-cmd-local.h       |   3 +-
 lib/trace-cmd/trace-compress.c                |  71 ++++
 lib/trace-cmd/trace-output.c                  | 108 +++++-
 lib/trace-cmd/trace-recorder.c                | 352 +++++++++++++++++-
 tracecmd/trace-record.c                       |  59 ++-
 tracecmd/trace-usage.c                        |   1 +
 8 files changed, 613 insertions(+), 28 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 494c5c9f..caa1edd1 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -432,6 +432,21 @@ OPTIONS
     'name' - the name of the desired compression algorithms. Available algorithms can be listed with
     trace-cmd list -c
 
+*--stream-compression*::
+    Compress the CPU trace data while recording instead of after the recording
+    has finished. This keeps the temporary files small, which helps when the
+    storage holding them is limited, and it avoids the compression pass over
+    the full trace data at the end of a recording.
+
+    Implies *--compression* 'any' if no algorithm was asked for, as the output
+    file holds the data that was compressed while recording.
+
+    Requires compression support and file version 7 or newer, so it cannot be
+    used with *--compression* 'none' or with *--file-version* 6. It is only
+    supported for local recordings writing to seekable CPU files, which rules
+    out network, guest, agent and FIFO recorders, and it cannot be combined
+    with *-m*.
+
 *--proxy* 'vsocket'::
     Use a vsocket proxy to reach the agent. Acts the same as *-A* (for an
     agent) but will send the proxy connection to the agent. It is expected to
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 33fa2f80..d01d27cf 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -38,6 +38,33 @@ int *tracecmd_add_id(int *list, int id, int len);
 #define FILE_VERSION_SECTIONS		7
 #define FILE_VERSION_COMPRESSION	7
 
+/*
+ * A recorder that compresses while recording runs in its own process, and the
+ * writer only sees the files it leaves behind.  It cannot report a failure, and
+ * may not get to run any cleanup at all, so two marker files next to the per
+ * CPU file carry that state:
+ *
+ *   <cpu file>.rawsize.error	Created before the first byte is compressed and
+ *				removed once the whole stream has been written.
+ *				If the writer finds it, the per CPU data is
+ *				unusable and the recording fails.
+ *
+ *   <cpu file>.rawsize		Written once the stream is complete, and holds
+ *				the u64 amount of raw ring buffer data that went
+ *				into it.  It tells the writer to copy the file as
+ *				is instead of compressing it, and gives it the
+ *				uncompressed size, which it cannot work out from
+ *				a file it does not decompress.
+ *
+ * The error marker comes first and is dropped only after the raw size has been
+ * written in full, so an incomplete stream can only be left marked as failed,
+ * never as complete.  The writer rejects the CPU data if the error marker is
+ * there, or if the raw size exists but cannot be read in full.  Neither file
+ * exists for a recording that was not compressed while recording.
+ */
+#define TRACE_CMD_RAW_SIZE_SUFFIX	".rawsize"
+#define TRACE_CMD_REC_ERROR_SUFFIX	".error"
+
 enum {
 	RINGBUF_TYPE_PADDING		= 29,
 	RINGBUF_TYPE_TIME_EXTEND	= 30,
@@ -364,6 +391,8 @@ struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int c
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, struct tracefs_instance *instance);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, struct tracefs_instance *instance);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags, struct tracefs_instance *instance, int maxkb);
+int tracecmd_recorder_set_compression(struct tracecmd_recorder *recorder,
+				      const char *compression);
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep);
 int tracecmd_stop_recording(struct tracecmd_recorder *recorder);
@@ -553,6 +582,9 @@ struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const cha
 						     struct tracecmd_msg_handle *msg_handle);
 void tracecmd_compress_destroy(struct tracecmd_compression *handle);
 int tracecmd_compress_block(struct tracecmd_compression *handle);
+int tracecmd_compress_stream_start(struct tracecmd_compression *handle);
+int tracecmd_compress_stream_block(struct tracecmd_compression *handle);
+int tracecmd_compress_stream_end(struct tracecmd_compression *handle);
 int tracecmd_uncompress_block(struct tracecmd_compression *handle);
 void tracecmd_compress_reset(struct tracecmd_compression *handle);
 ssize_t tracecmd_compress_buffer_read(struct tracecmd_compression *handle, char *dst, size_t len);
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index c75055ec..c5e8491d 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -10,7 +10,6 @@
 #include "trace-cmd-private.h"
 
 #define FILE_VERSION_DEFAULT		7
-
 /* Can be overridden */
 void tracecmd_warning(const char *fmt, ...);
 void tracecmd_critical(const char *fmt, ...);
@@ -94,6 +93,8 @@ struct cpu_data_source {
 	int fd;
 	ssize_t size;
 	off_t offset;
+	unsigned long long raw_size;
+	bool precompressed;
 };
 
 int tcmd_out_write_cpu_data(struct tracecmd_output *handle, int cpus,
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index fe4ab84a..33f6ac66 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -39,6 +39,8 @@ struct tracecmd_compression {
 	struct tep_handle		*tep;
 	struct tracecmd_msg_handle	*msg_handle;
 	void				*context;
+	off_t				stream_offset;
+	unsigned int			stream_chunks;
 };
 
 static ssize_t read_fd(int fd, char *dst, int len)
@@ -393,6 +395,75 @@ void *tracecmd_uncompress_buffer(struct tracecmd_compression *handle, size_t *si
 	return buffer;
 }
 
+/*
+ * A trace-cmd CPU data stream is a chunked compression block:
+ *
+ *   u32 chunk_count
+ *   repeated { u32 compressed_size, u32 uncompressed_size, data }
+ *
+ * The normal file writer can seek back after reading a complete temporary
+ * file and fill in chunk_count.  Recorders cannot do that at every read, so
+ * these helpers reserve the count and update it when the recorder exits.
+ */
+int tracecmd_compress_stream_start(struct tracecmd_compression *handle)
+{
+	unsigned int zero = 0;
+
+	if (!handle || handle->msg_handle || handle->fd < 0)
+		return -1;
+
+	handle->stream_offset = lseek(handle->fd, 0, SEEK_CUR);
+	if (handle->stream_offset == (off_t)-1)
+		return -1;
+
+	/* A zero needs no endian conversion */
+	if (write_fd(handle->fd, &zero, sizeof(zero)) != sizeof(zero))
+		return -1;
+
+	handle->stream_chunks = 0;
+	return 0;
+}
+
+int tracecmd_compress_stream_block(struct tracecmd_compression *handle)
+{
+	if (!handle || !handle->pointer)
+		return -1;
+
+	if (tracecmd_compress_block(handle))
+		return -1;
+
+	handle->stream_chunks++;
+	return 0;
+}
+
+int tracecmd_compress_stream_end(struct tracecmd_compression *handle)
+{
+	unsigned int chunks;
+	off_t end;
+	int endian4;
+
+	if (!handle || handle->msg_handle || handle->fd < 0)
+		return -1;
+
+	end = lseek(handle->fd, 0, SEEK_CUR);
+	if (end == (off_t)-1)
+		return -1;
+
+	if (lseek(handle->fd, handle->stream_offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	chunks = handle->stream_chunks;
+	endian4 = tep_read_number(handle->tep, &chunks, sizeof(chunks));
+
+	if (write_fd(handle->fd, &endian4, sizeof(endian4)) != sizeof(endian4))
+		return -1;
+
+	if (lseek(handle->fd, end, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	return 0;
+}
+
 /**
  * tracecmd_compress_buffer_write - write() to compression buffer
  * @handle: compression handle
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 3ef6db6b..f4abca20 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2707,6 +2707,7 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 	struct data_file_write *data_files = NULL;
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
+	unsigned long long expect_size;
 	unsigned long long read_size;
 	int page_size;
 	char *clock;
@@ -2746,7 +2747,8 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
-		data_files[i].file_size = data[i].size;
+		data_files[i].file_size = data[i].precompressed ?
+			data[i].raw_size : data[i].size;
 		/*
 		 * Place 0 for the data offset and size, and save the offsets to
 		 * updated them with the correct data later.
@@ -2786,14 +2788,23 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 		if (data[i].size) {
 			if (lseek(data[i].fd, data[i].offset, SEEK_SET) == (off_t)-1)
 				goto out_free;
-			read_size = tcmd_out_copy_fd_compress(handle, data[i].fd,
-							      data[i].size, &data_files[i].write_size,
-							      page_size);
+			if (data[i].precompressed) {
+				read_size = copy_file_fd(handle, data[i].fd,
+							 data[i].size);
+				data_files[i].write_size = read_size;
+			} else {
+				read_size = tcmd_out_copy_fd_compress(handle, data[i].fd,
+								      data[i].size,
+								      &data_files[i].write_size,
+								      page_size);
+			}
 
-			if (read_size != data_files[i].file_size) {
+			expect_size = data[i].precompressed ?
+				data[i].size : data_files[i].file_size;
+			if (read_size != expect_size) {
 				errno = EINVAL;
 				tracecmd_warning("did not match size of %llu to %llu",
-						 read_size, data_files[i].file_size);
+						 read_size, expect_size);
 				goto out_free;
 			}
 		} else {
@@ -2818,12 +2829,14 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 				goto out_free;
 		}
 		if (!tracecmd_get_quiet(handle)) {
-			fprintf(stderr, "    %llu bytes in size",
-				(unsigned long long)data_files[i].write_size);
-			if (handle->compress)
-				fprintf(stderr, " (%llu uncompressed)",
+			if (handle->compress) {
+				fprintf(stderr, "    %llu bytes stored (%llu uncompressed)\n",
+					(unsigned long long)data_files[i].write_size,
 					(unsigned long long)data_files[i].file_size);
-			fprintf(stderr, "\n");
+			} else {
+				fprintf(stderr, "    %llu bytes in size\n",
+					(unsigned long long)data_files[i].write_size);
+			}
 		}
 	}
 
@@ -2869,6 +2882,12 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 		return -1;
 
 	for (i = 0; i < cpus; i++) {
+		char *raw_size_file;
+		char *error_file;
+		unsigned long long raw_size;
+		bool failed;
+		int raw_fd;
+
 		ret = stat(cpu_data_files[i], &st);
 		if (ret < 0) {
 			tracecmd_warning("can not stat '%s'", cpu_data_files[i]);
@@ -2882,6 +2901,73 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 		data[i].size = st.st_size;
 		data[i].offset = 0;
+		data[i].precompressed = false;
+		data[i].raw_size = 0;
+		if (asprintf(&raw_size_file, "%s%s", cpu_data_files[i],
+			     TRACE_CMD_RAW_SIZE_SUFFIX) < 0) {
+			close(data[i].fd);
+			errno = ENOMEM;
+			break;
+		}
+		if (asprintf(&error_file, "%s%s", raw_size_file,
+			     TRACE_CMD_REC_ERROR_SUFFIX) < 0) {
+			free(raw_size_file);
+			close(data[i].fd);
+			errno = ENOMEM;
+			break;
+		}
+		/*
+		 * A recorder that did not finish its compressed stream leaves
+		 * this marker behind.  The data cannot be used, and reading it
+		 * as raw ring buffer pages would pass the size check below and
+		 * store garbage.  Only a marker that is known not to exist may
+		 * be taken as a recording that went fine, so anything other
+		 * than ENOENT has to fail here as well.
+		 */
+		if (!access(error_file, F_OK))
+			failed = true;
+		else
+			failed = errno != ENOENT;
+		free(error_file);
+		if (failed) {
+			close(data[i].fd);
+			errno = EIO;
+			tracecmd_warning("CPU%d compressed recording failed", i);
+			free(raw_size_file);
+			break;
+		}
+		raw_fd = open(raw_size_file, O_RDONLY);
+		if (raw_fd < 0 && errno != ENOENT) {
+			close(data[i].fd);
+			errno = EIO;
+			tracecmd_warning("CPU%d raw size '%s' is unreadable",
+					 i, raw_size_file);
+			free(raw_size_file);
+			break;
+		}
+		if (raw_fd >= 0) {
+			ssize_t r;
+
+			r = read(raw_fd, &raw_size, sizeof(raw_size));
+			close(raw_fd);
+			/*
+			 * The error marker is cleared only after the raw size
+			 * has been written in full, so a short one means the
+			 * file was damaged afterwards.  The compressed data
+			 * must not be stored as raw ring buffer pages.
+			 */
+			if (r < 0 || (size_t)r != sizeof(raw_size)) {
+				close(data[i].fd);
+				errno = EIO;
+				tracecmd_warning("CPU%d raw size '%s' is unreadable",
+						 i, raw_size_file);
+				free(raw_size_file);
+				break;
+			}
+			data[i].precompressed = true;
+			data[i].raw_size = raw_size;
+		}
+		free(raw_size_file);
 		size += st.st_size;
 	}
 
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 6f146bb6..b2a0806d 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -10,6 +10,8 @@
 #include <poll.h>
 #include <unistd.h>
 #include <errno.h>
+#include <stdint.h>
+#include <string.h>
 
 #include "tracefs.h"
 #include "trace-cmd-private.h"
@@ -43,8 +45,20 @@ struct tracecmd_recorder {
 	int		pages;
 	int		count;
 	unsigned	flags;
+	char		*buf;
+	struct tracecmd_compression *compress;
+	struct tep_handle *compress_tep;
+	size_t		compress_block_size;
+	size_t		compress_pending;
+	unsigned long long	raw_size;
+	char		*raw_size_file;
+	char		*error_file;
+	bool		stream_compression;
+	bool		stream_failed;
 };
 
+#define TRACE_RECORD_COMPRESS_PAGES	10
+
 static int append_file(int size, int dst, int src)
 {
 	char buf[size];
@@ -64,8 +78,28 @@ static int append_file(int size, int dst, int src)
 	return 0;
 }
 
+/*
+ * Create the empty TRACE_CMD_REC_ERROR_SUFFIX marker, which tells the writer
+ * that this CPU file is not usable.  It is put in place before the stream is
+ * started and removed once it is complete, see the description of the marker
+ * files in trace-cmd-private.h.
+ */
+static int mark_stream_error(struct tracecmd_recorder *recorder)
+{
+	int fd;
+
+	fd = open(recorder->error_file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+	if (fd < 0)
+		return -1;
+
+	close(fd);
+	return 0;
+}
+
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 {
+	bool stream_failed = false;
+
 	if (!recorder)
 		return;
 
@@ -89,7 +123,51 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 		}
 		append_file(recorder->page_size, recorder->fd1, recorder->fd2);
 	}
+	if (recorder->compress) {
+		if (recorder->stream_failed)
+			stream_failed = true;
+		if (recorder->compress_pending &&
+		    tracecmd_compress_stream_block(recorder->compress))
+			stream_failed = true;
+		if (tracecmd_compress_stream_end(recorder->compress))
+			stream_failed = true;
+		tracecmd_compress_destroy(recorder->compress);
+	}
+	/*
+	 * Finish the marker protocol described in trace-cmd-private.h.  The
+	 * error marker is already in place, so only a stream that made it all
+	 * the way here gets to clear it.  Everything else has to stay marked as
+	 * failed, as the writer would otherwise read the compressed bytes as
+	 * raw ring buffer pages.  It only compares how much it copied against
+	 * the file size, which a compressed file would still pass.
+	 */
+	if (recorder->stream_compression && !stream_failed) {
+		uint64_t size = recorder->raw_size;
+		int fd;
+
+		fd = open(recorder->raw_size_file,
+			  O_WRONLY | O_CREAT | O_TRUNC, 0644);
+		if (fd >= 0) {
+			bool wrote_size;
+
+			wrote_size = write(fd, &size, sizeof(size)) ==
+				sizeof(size);
+			close(fd);
+			/*
+			 * Dropping the error marker is the last step, so a raw
+			 * size that was not written in full keeps the CPU file
+			 * marked as failed.
+			 */
+			if (wrote_size)
+				unlink(recorder->error_file);
+		}
+	}
+	if (recorder->compress_tep)
+		tep_free(recorder->compress_tep);
  close:
+	free(recorder->raw_size_file);
+	free(recorder->error_file);
+	free(recorder->buf);
 	tracefs_cpu_close(recorder->tcpu);
 
 	if (recorder->fd1 >= 0)
@@ -101,6 +179,89 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 	free(recorder);
 }
 
+int tracecmd_recorder_set_compression(struct tracecmd_recorder *recorder,
+				      const char *compression)
+{
+	const char *name = compression;
+
+	if (!recorder || recorder->compress) {
+		errno = EINVAL;
+		return -1;
+	}
+	if (recorder->max) {
+		errno = EINVAL;
+		return -1;
+	}
+	/* Only a recorder writing to a file of its own can be marked */
+	if (!recorder->raw_size_file || !recorder->error_file) {
+		errno = EINVAL;
+		return -1;
+	}
+	if (!name || !strcmp(name, "any"))
+		name = NULL;
+	if (!name || strcmp(name, "none")) {
+		recorder->compress_tep = tep_alloc();
+		if (!recorder->compress_tep) {
+			errno = ENOMEM;
+			return -1;
+		}
+		tep_set_file_bigendian(recorder->compress_tep,
+				       tracecmd_host_bigendian());
+		recorder->compress = tracecmd_compress_alloc(
+			name, NULL, recorder->fd, recorder->compress_tep, NULL);
+		if (!recorder->compress) {
+			errno = ENOTSUP;
+			goto fail;
+		}
+		/*
+		 * The reader indexes into a decompressed chunk in units of
+		 * the sub buffer size, so chunks must be a whole number of
+		 * sub buffers.  Using the system page size here would cut
+		 * chunks in the middle of a sub buffer whenever the tracing
+		 * sub buffer is larger (see "trace-cmd record --subbuf-size").
+		 */
+		recorder->compress_block_size =
+			TRACE_RECORD_COMPRESS_PAGES * (size_t)recorder->subbuf_size;
+		/*
+		 * Mark the CPU file as failed before a single byte is
+		 * compressed, and clear the marker only once the whole stream
+		 * has been written.  A recorder runs in its own process, so
+		 * anything from a failed compression to a SIGKILL has to leave
+		 * the marker behind, see trace-cmd-private.h.
+		 */
+		if (mark_stream_error(recorder))
+			goto fail;
+		/* Not every failure path of the helper sets errno */
+		errno = 0;
+		if (tracecmd_compress_stream_start(recorder->compress)) {
+			if (!errno)
+				errno = EIO;
+			goto fail;
+		}
+		/*
+		 * The compressor owns the output file descriptor, so the data
+		 * has to be read into a buffer before it can be compressed.
+		 * Splicing it straight into the file would bypass the
+		 * compressor and corrupt the stream.
+		 */
+		recorder->flags |= TRACECMD_RECORD_NOSPLICE;
+		recorder->stream_compression = true;
+	}
+	return 0;
+fail:
+	/*
+	 * The error marker is left in place if it was created.  The stream start
+	 * may have written part of the chunk count before failing, and the
+	 * caller is free to carry on recording without compression, so the CPU
+	 * file cannot be trusted either way.
+	 */
+	tracecmd_compress_destroy(recorder->compress);
+	recorder->compress = NULL;
+	tep_free(recorder->compress_tep);
+	recorder->compress_tep = NULL;
+	return -1;
+}
+
 static int set_nonblock(struct tracecmd_recorder *recorder)
 {
 	return tracefs_cpu_stop(recorder->tcpu);
@@ -113,7 +274,7 @@ create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	struct tracecmd_recorder *recorder;
 	bool nonblock = false;
 
-	recorder = malloc(sizeof(*recorder));
+	recorder = calloc(1, sizeof(*recorder));
 	if (!recorder)
 		return NULL;
 
@@ -153,6 +314,16 @@ create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 		goto out_free;
 
 	recorder->subbuf_size = tracefs_cpu_read_size(recorder->tcpu);
+
+	/*
+	 * The sub buffer size is set by the kernel and can be megabytes with
+	 * "trace-cmd record --subbuf-size".  Keep it off the stack, as the
+	 * read and the flush paths would otherwise nest several of them.
+	 */
+	recorder->buf = malloc(recorder->subbuf_size);
+	if (!recorder->buf)
+		goto out_free;
+
 	return recorder;
 
  out_free:
@@ -212,6 +383,34 @@ __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
 		if (fd2 != -1)
 			close(fd2);
 	}
+	if (recorder) {
+		char *raw_size_file = NULL;
+		char *error_file = NULL;
+
+		if (asprintf(&raw_size_file, "%s%s", file,
+			     TRACE_CMD_RAW_SIZE_SUFFIX) < 0)
+			raw_size_file = NULL;
+		if (raw_size_file &&
+		    asprintf(&error_file, "%s%s", raw_size_file,
+			     TRACE_CMD_REC_ERROR_SUFFIX) < 0)
+			error_file = NULL;
+
+		if (!error_file) {
+			free(raw_size_file);
+			tracecmd_free_recorder(recorder);
+			recorder = NULL;
+		} else {
+			recorder->raw_size_file = raw_size_file;
+			recorder->error_file = error_file;
+			/*
+			 * Stale markers from an interrupted streaming run must
+			 * never make a later raw recording look precompressed,
+			 * nor make it look like it failed.
+			 */
+			unlink(raw_size_file);
+			unlink(error_file);
+		}
+	}
 
 	if (fd2 != -1) {
 		/* Unlink file2, we need to add everything to file at the end */
@@ -343,10 +542,68 @@ static inline void update_fd(struct tracecmd_recorder *recorder, int size)
  * Returns -1 on error.
  *          or bytes of data read.
  */
+static long compress_data(struct tracecmd_recorder *recorder, const char *buf, long r)
+{
+	size_t done = 0;
+
+	while (done < (size_t)r) {
+		size_t space = recorder->compress_block_size -
+			recorder->compress_pending;
+		size_t size = (size_t)r - done;
+
+		if (size > space)
+			size = space;
+		/*
+		 * The compression helpers do not set errno on every failure
+		 * path.  The callers check errno to decide whether a negative
+		 * return is retryable, so clear it first.  A leftover EINTR
+		 * would make the caller retry a read that cannot be repeated,
+		 * as the data is already out of the ring buffer.
+		 */
+		errno = 0;
+		if (tracecmd_compress_buffer_write(recorder->compress,
+						   buf + done, size))
+			goto fail;
+		done += size;
+		recorder->compress_pending += size;
+		recorder->raw_size += size;
+		if (recorder->compress_pending ==
+		    recorder->compress_block_size) {
+			errno = 0;
+			if (tracecmd_compress_stream_block(recorder->compress))
+				goto fail;
+			recorder->compress_pending = 0;
+		}
+	}
+
+	return r;
+fail:
+	/*
+	 * Data has been taken out of the ring buffer and cannot be recovered,
+	 * so the stream is incomplete no matter what the caller does next.
+	 */
+	recorder->stream_failed = true;
+	if (!errno)
+		errno = EIO;
+	return -1;
+}
+
+/*
+ * A failed read or write leaves a gap in what was recorded.  The stream is
+ * incomplete from here on, and the CPU file has to stay marked as failed so
+ * that the writer does not store it as a complete recording.
+ */
+static long mark_failed(struct tracecmd_recorder *recorder, long ret)
+{
+	if (recorder->compress)
+		recorder->stream_failed = true;
+	return ret;
+}
+
 static long read_data(struct tracecmd_recorder *recorder)
 {
 	bool nonblock = recorder->stop;
-	char buf[recorder->subbuf_size];
+	char *buf = recorder->buf;
 	long left;
 	long r, w;
 
@@ -354,6 +611,9 @@ static long read_data(struct tracecmd_recorder *recorder)
 	if (r < 0)
 		return r;
 
+	if (recorder->compress)
+		return compress_data(recorder, buf, r);
+
 	left = r;
 	do {
 		w = write(recorder->fd, buf + (r - left), left);
@@ -396,9 +656,33 @@ static long move_data(struct tracecmd_recorder *recorder)
 	return ret;
 }
 
+/*
+ * Read out the remaining data of the ring buffer.  The recording paths only
+ * move whole sub buffers and leave a partial tail behind, which is what the
+ * tracefs flush helpers pick up.
+ *
+ * Returns the number of bytes flushed, or negative on error.
+ */
+static long flush_data(struct tracecmd_recorder *recorder)
+{
+	long ret;
+
+	if (!recorder->compress)
+		return tracefs_cpu_flush_write(recorder->tcpu, recorder->fd);
+
+	/*
+	 * A streaming compressor owns the output fd, so the data cannot be
+	 * written to it directly.  Read it out and feed the compressor.
+	 */
+	ret = tracefs_cpu_flush(recorder->tcpu, recorder->buf);
+	if (ret <= 0)
+		return ret;
+
+	return compress_data(recorder, recorder->buf, ret);
+}
+
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder, bool finish)
 {
-	char buf[recorder->subbuf_size];
 	long total = 0;
 	long wrote = 0;
 	long ret;
@@ -406,25 +690,63 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder, bool finish)
 	if (!recorder)
 		return 0;
 
-	if (!finish)
-		return tracefs_cpu_flush_write(recorder->tcpu, recorder->fd);
+	if (!finish) {
+		ret = flush_data(recorder);
+		if (ret < 0)
+			return mark_failed(recorder, ret);
+		return ret;
+	}
 
-	set_nonblock(recorder);
+	/*
+	 * A ring buffer that could not be switched to non blocking may still
+	 * have data in it when the loop below reads zero, which would leave the
+	 * stream short of what was recorded.
+	 */
+	if (set_nonblock(recorder) < 0)
+		mark_failed(recorder, -1);
 
 	do {
-		ret = tracefs_cpu_flush_write(recorder->tcpu, recorder->fd);
-		if (ret > 0)
+		ret = flush_data(recorder);
+		if (ret > 0) {
 			wrote += ret;
+			continue;
+		}
+		/*
+		 * An interrupted read has not consumed anything, so it can be
+		 * repeated.  tracecmd_start_recording() does the same, and the
+		 * negative return is now reported to the caller.
+		 */
+		if (ret < 0 && errno == EINTR && !recorder->stream_failed)
+			ret = 1;
 	} while (ret > 0);
 
-	/* Make sure we finish off with a page size boundary */
-	wrote &= recorder->subbuf_size - 1;
-	if (wrote) {
-		memset(buf, 0, recorder->subbuf_size);
-		write(recorder->fd, buf, recorder->subbuf_size - wrote);
-		total += recorder->subbuf_size;
+	/*
+	 * The sub buffer padding is part of the raw recording format.  With a
+	 * streaming compressor the recorded bytes are already in its input
+	 * buffer and the chunk framing keeps track of the sizes, so writing
+	 * padding here is both unnecessary and would corrupt the stream.
+	 */
+	if (!recorder->compress) {
+		int err = errno;
+
+		wrote &= recorder->subbuf_size - 1;
+		if (wrote) {
+			memset(recorder->buf, 0, recorder->subbuf_size);
+			write(recorder->fd, recorder->buf,
+			      recorder->subbuf_size - wrote);
+			total += recorder->subbuf_size;
+		}
+		/* The padding write must not hide why the flush failed */
+		errno = err;
 	}
 
+	/*
+	 * Report the failure only after the recording has been padded, so that
+	 * the output is left in the same state as after a successful flush.
+	 */
+	if (ret < 0)
+		return mark_failed(recorder, ret);
+
 	return total;
 }
 
@@ -453,7 +775,7 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 				if ((recorder->flags & TRACECMD_RECORD_POLL) &&
 				    errno == EAGAIN)
 					continue;
-				return ret;
+				return mark_failed(recorder, ret);
 			}
 			read += ret;
 		} while (ret > 0 && !recorder->stop);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e7bb2f58..c7641558 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -140,6 +140,9 @@ struct event_list {
 
 struct tracecmd_event_list *listed_events;
 
+static bool stream_compression;
+static const char *recorder_compression;
+
 struct events {
 	struct events *sibling;
 	struct events *children;
@@ -207,6 +210,7 @@ struct common_record_context {
 	char *user;
 	const char *clock;
 	const char *compression;
+	bool stream_compression;
 	struct tsc_nsec tsc2nsec;
 	int data_flags;
 	int tsync_loop_interval;
@@ -591,6 +595,20 @@ static void put_temp_file(char *file)
 	free(file);
 }
 
+/* Remove the marker files that a recorder compressing its stream leaves behind */
+static void delete_compress_files(const char *cpu_file)
+{
+	char file[PATH_MAX];
+
+	snprintf(file, sizeof(file), "%s%s", cpu_file,
+		 TRACE_CMD_RAW_SIZE_SUFFIX);
+	unlink(file);
+
+	snprintf(file, sizeof(file), "%s%s%s", cpu_file,
+		 TRACE_CMD_RAW_SIZE_SUFFIX, TRACE_CMD_REC_ERROR_SUFFIX);
+	unlink(file);
+}
+
 static void delete_temp_file(struct buffer_instance *instance, int cpu)
 {
 	const char *output_file;
@@ -608,6 +626,7 @@ static void delete_temp_file(struct buffer_instance *instance, int cpu)
 	else
 		snprintf(file, PATH_MAX, "%s.cpu%d", output_file, cpu);
 	unlink(file);
+	delete_compress_files(file);
 }
 
 static int kill_thread_instance(int start, struct buffer_instance *instance)
@@ -3677,6 +3696,9 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 
 	if (!recorder)
 		die ("can't create recorder");
+	if (stream_compression &&
+	    tracecmd_recorder_set_compression(recorder, recorder_compression))
+		die("can't enable streaming compression");
 
 	if (type == TRACE_TYPE_EXTRACT) {
 		ret = tracecmd_flush_recording(recorder, true);
@@ -4291,6 +4313,30 @@ static void start_threads(enum trace_type type, struct common_record_context *ct
 	int i = 0;
 	int ret;
 
+	if (ctx->stream_compression) {
+		if (ctx->compression && !strcmp(ctx->compression, "none"))
+			die("--stream-compression requires compression support");
+		if (ctx->file_version && ctx->file_version < FILE_VERSION_COMPRESSION)
+			die("--stream-compression requires file version %d or newer",
+			    FILE_VERSION_COMPRESSION);
+		if (max_kb)
+			die("--stream-compression cannot be used with -m");
+		if (!ctx->compression)
+			ctx->compression = "any";
+		/*
+		 * The recorder reserves and later patches the chunk count in each
+		 * CPU temporary file.  Network, guest, agent and FIFO recorders
+		 * are not seekable, so silently enabling this mode there would
+		 * create an invalid compressed stream.
+		 */
+		for_all_instances(instance) {
+			if (host || is_guest(instance) || is_agent(instance) ||
+			    instance->client_ports || instance->use_fifos)
+				die("--stream-compression is supported only for local seekable CPU files");
+		}
+	}
+	stream_compression = ctx->stream_compression;
+	recorder_compression = ctx->compression;
 	for_all_instances(instance) {
 		/* Start the connection now to find out how many CPUs we need */
 		if (is_guest(instance))
@@ -4824,7 +4870,8 @@ static void record_data(struct common_record_context *ctx)
 		if (tracecmd_write_cmdlines(handle))
 			die("Writing cmdlines");
 
-		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
+		if (tracecmd_append_cpu_data(handle, local_cpu_count, temp_files) < 0)
+			die("Writing CPU data");
 
 		for (i = 0; i < max_cpu_count; i++)
 			put_temp_file(temp_files[i]);
@@ -6033,6 +6080,7 @@ enum {
 	OPT_notimeout		= LONG_OPT(26),
 	OPT_daemonize		= LONG_OPT(27),
 	OPT_subbuf		= LONG_OPT(28),
+	OPT_stream_compression	= LONG_OPT(29),
 };
 
 void trace_stop(int argc, char **argv)
@@ -6506,6 +6554,7 @@ static void parse_record_options(int argc,
 			{"temp", required_argument, NULL, OPT_temp},
 			{"subbuf-size", required_argument, NULL, OPT_subbuf},
 			{"daemonize", no_argument, NULL, OPT_daemonize},
+			{"stream-compression", no_argument, NULL, OPT_stream_compression},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -7019,6 +7068,14 @@ static void parse_record_options(int argc,
 				die("Compression algorithm  %s is not supported", optarg);
 			ctx->compression = strdup(optarg);
 			break;
+		case OPT_stream_compression:
+			cmd_check_die(ctx, CMD_extract, *(argv+1), "--stream-compression");
+			cmd_check_die(ctx, CMD_start, *(argv+1), "--stream-compression");
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--stream-compression");
+			cmd_check_die(ctx, CMD_stream, *(argv+1), "--stream-compression");
+			cmd_check_die(ctx, CMD_profile, *(argv+1), "--stream-compression");
+			ctx->stream_compression = true;
+			break;
 		case OPT_file_ver:
 			if (ctx->curr_cmd != CMD_record && ctx->curr_cmd != CMD_record_agent)
 				die("--file_version has no effect with the command %s\n",
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index e7b32f80..6cfd330d 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -81,6 +81,7 @@ static struct usage_help usage_help[] = {
 		"                            none - do not compress the trace file\n"
 		"                            name - the name of the desired compression algorithms\n"
 		"                        available algorithms can be listed with trace-cmd list -c\n"
+		"          --stream-compression compress each CPU trace block while recording\n"
 		"          --proxy vsocket to reach the agent. Acts the same as -A (for an agent)\n"
 		"              but will send the proxy connection to the agent.\n"
 		"          --daemonize run trace-cmd in the background as a daemon after recording has started.\n"
-- 
2.34.1

