Return-Path: <SRS0=bjmZ=QG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D565C282D7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F264920857
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfA3Kof (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:44:35 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52574 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfA3Kof (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jan 2019 05:44:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id m1so21102621wml.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jan 2019 02:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rCb3NGXA7lesF5jBW/ahfTz3WfjpVWV5itGnytj9UmE=;
        b=a9kyXyZuU++ld/yPc4eQeOEwRQWOcLrpuKaRJeHwlEzFVGLih34Ao+JNR2xbQNIcAv
         nIWR3cvrvJDRvQ5SHbVuoEfn9kY7dCyMWgtn9lCHwijJs5r761Q4KQ+F1EbbgvT2LyTe
         7kPs2Zy1b4xP5hpC1eu91NEyhATA82VEJpXyAQ8z41QExUomD3KP3w777mugG/2cIPdg
         q09xTYRoSYuUKIobtwmMbSRDhwlMx8Bo2csGnlCDiV9pJ451RCurrQfXcebSLcOEaQP7
         yerQMIBBLXtNTGpGQJn4H76yu3DGBsk9Az7mLGUcuK1owKyDfBPS7YTFt4OCAjcsrC9S
         xyaA==
X-Gm-Message-State: AJcUukcyVAXw7J+FZanK8qV1Qrd0F9dVIivnp04w/BUkkzUhULmPOEz5
        fdatYiQAuMW83IZXkNBachw=
X-Google-Smtp-Source: ALg8bN5fprINCUoQQxUqmoFA1+nm33Knj6GZxWh0AlhmlJGE6e8QUdxTnX8LSQQVr7fS4dB4x8Vf4A==
X-Received: by 2002:a1c:8c05:: with SMTP id o5mr23752489wmd.29.1548845072778;
        Wed, 30 Jan 2019 02:44:32 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w12sm503079wrr.23.2019.01.30.02.44.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 02:44:32 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/6] trace-cmd: Rename tep_is_file_bigendian() to tep_file_bigendian()
Date:   Wed, 30 Jan 2019 12:44:24 +0200
Message-Id: <20190130104425.8813-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130104425.8813-1-tstoyanov@vmware.com>
References: <20190130104425.8813-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to make libtraceevent into a proper library, its API
should be straightforward.

After a discussion with Steven Rostedt, we decided to rename a few APIs,
to have more intuitive names.

This patch renames tep_is_file_bigendian() to tep_file_bigendian().

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181201040852.767549746@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 2 +-
 lib/trace-cmd/trace-input.c      | 8 ++++----
 lib/traceevent/event-parse-api.c | 4 ++--
 plugins/plugin_kvm.c             | 2 +-
 python/tracecmd.py               | 2 +-
 tracecmd/trace-output.c          | 2 +-
 tracecmd/trace-read.c            | 4 ++--
 tracecmd/trace-split.c           | 2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index b4fa2c7..2dc5822 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -551,7 +551,7 @@ int tep_get_long_size(struct tep_handle *pevent);
 void tep_set_long_size(struct tep_handle *pevent, int long_size);
 int tep_get_page_size(struct tep_handle *pevent);
 void tep_set_page_size(struct tep_handle *pevent, int _page_size);
-int tep_is_file_bigendian(struct tep_handle *pevent);
+int tep_file_bigendian(struct tep_handle *pevent);
 void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian);
 int tep_is_host_bigendian(struct tep_handle *pevent);
 void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b628570..b161c75 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1619,7 +1619,7 @@ tracecmd_translate_data(struct tracecmd_input *handle,
 	memset(record, 0, sizeof(*record));
 
 	record->ref_count = 1;
-	if (tep_is_host_bigendian(pevent) == tep_is_file_bigendian(pevent))
+	if (tep_is_host_bigendian(pevent) == tep_file_bigendian(pevent))
 		swap = 0;
 	record->data = kbuffer_translate_data(swap, ptr, &length);
 	record->size = length;
@@ -1661,7 +1661,7 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
 	enum kbuffer_endian endian;
 	void *ptr;
 
-	if (tep_is_file_bigendian(pevent))
+	if (tep_file_bigendian(pevent))
 		endian = KBUFFER_ENDIAN_BIG;
 	else
 		endian = KBUFFER_ENDIAN_LITTLE;
@@ -2266,7 +2266,7 @@ static int read_cpu_data(struct tracecmd_input *handle)
 	else
 		long_size = KBUFFER_LSIZE_4;
 
-	if (tep_is_file_bigendian(handle->pevent))
+	if (tep_file_bigendian(handle->pevent))
 		endian = KBUFFER_ENDIAN_BIG;
 	else
 		endian = KBUFFER_ENDIAN_LITTLE;
@@ -2475,7 +2475,7 @@ int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus)
 	else
 		long_size = KBUFFER_LSIZE_4;
 
-	if (tep_is_file_bigendian(handle->pevent))
+	if (tep_file_bigendian(handle->pevent))
 		endian = KBUFFER_ENDIAN_BIG;
 	else
 		endian = KBUFFER_ENDIAN_LITTLE;
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index 347ff10..afafbc8 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -250,13 +250,13 @@ void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 }
 
 /**
- * tep_is_file_bigendian - get if the file is in big endian order
+ * tep_file_bigendian - get if the file is in big endian order
  * @pevent: a handle to the tep_handle
  *
  * This returns if the file is in big endian order
  * If @pevent is NULL, 0 is returned.
  */
-int tep_is_file_bigendian(struct tep_handle *pevent)
+int tep_file_bigendian(struct tep_handle *pevent)
 {
 	if (pevent)
 		return pevent->file_bigendian;
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index f81d3c5..ddac21a 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -386,7 +386,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	 * We can only use the structure if file is of the same
 	 * endianness.
 	 */
-	if (tep_is_file_bigendian(event->pevent) ==
+	if (tep_file_bigendian(event->pevent) ==
 	    tep_is_host_bigendian(event->pevent)) {
 
 		trace_seq_printf(s, "%u/%u q%u%s %s%s %spge %snxe",
diff --git a/python/tracecmd.py b/python/tracecmd.py
index f4f241e..60a0d3e 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -166,7 +166,7 @@ class PEvent(object):
 
     @cached_property
     def file_endian(self):
-        if tep_is_file_bigendian(self._pevent):
+        if tep_file_bigendian(self._pevent):
             return '>'
         return '<'
 
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 33d6ce3..1c2e92c 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -808,7 +808,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 		/* Use the pevent of the ihandle for later writes */
 		handle->pevent = tracecmd_get_pevent(ihandle);
 		tep_ref(pevent);
-		if (tep_is_file_bigendian(pevent))
+		if (tep_file_bigendian(pevent))
 			buf[0] = 1;
 		else
 			buf[0] = 0;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 4cc1f61..03c0978 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1700,8 +1700,8 @@ void trace_report (int argc, char **argv)
 
 		if (show_endian) {
 			printf("file is %s endian and host is %s endian\n",
-			       tep_is_file_bigendian(pevent) ? "big" : "little",
-			       tep_is_host_bigendian(pevent) ? "big" : "little");
+				tep_file_bigendian(pevent) ? "big" : "little",
+				tep_is_host_bigendian(pevent) ? "big" : "little");
 			return;
 		}
 
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index d27b3c6..6043e97 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -64,7 +64,7 @@ static int create_type_len(struct tep_handle *pevent, int time, int len)
 			bigendian = 1;
 	}
 
-	if (tep_is_file_bigendian(pevent))
+	if (tep_file_bigendian(pevent))
 		time |= (len << 27);
 	else
 		time = (time << 5) | len;
-- 
2.20.1

