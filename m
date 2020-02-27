Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48EFC5ED38
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82DC8246AC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jfX52asg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389830AbgB0OUN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:13 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42072 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730238AbgB0OUM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:12 -0500
Received: by mail-lj1-f195.google.com with SMTP id d10so3594495ljl.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HT/OFwCq9NMeexvwL+8+0hJRAzEV1ED9p/K4+kIVNa4=;
        b=jfX52asg2Fmp4BEtFu8zJUPFIIvN1tsM9NTuTqX8K8gvHj0oF1D8wV1vKdbG7qnq+0
         6kYfDpBjwNRQFV0GpFEKDGKxZp/8Xe6YbX4cHdjKo+U2vKR9T71sS/3GXVLN/YxD3Z7o
         mEMkfL+v056D8F362YJjQjlGkT7+Twzga/WkytPrrDoeHLR7uPQT/WQr4JcM0kQbHrzj
         sVDmmJ/5mSm6kJJrb4WDrFEWAckEpMon+RI0eU9rb/RmNqAeqF+VBpiCWQETJ7y6RQgx
         vu2sCJ6X6+AXgPT09vtPQwUm+vIU1yjF3g9h6fQBLf2lxrNHGeVjVrbmz/3q3FYN4/L3
         amOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HT/OFwCq9NMeexvwL+8+0hJRAzEV1ED9p/K4+kIVNa4=;
        b=asGuNDI/7wM3ObCU3V5ZZ0UzREFWVjlAZgYqPXSRptIbs0rBjKrM0k9FxJSnRQd02V
         +kXbNZpt9ehd/wfnNpB3sZR3zp42BttWF7rd30hfoAphteb5I/H+mCREVoepq+EAr4a2
         C8FkPnmvUIdYms0ElLLwkzwvtSpD3GEs5WTNtV73r9SAmHXqdPtYMGCa7rIT0e74/lgl
         pOO2oe7mfCsa93YgcwWhTfWkO3OVt6lBFmZeY2iKLzQDM2pR1TPbdsxDwGRS559KOfKO
         jnA9+8FVyMBR6OG8ZsILtbrGWCRLbavsZaRX8jGuUvD8rNE2rr6PuNi9kdbySfvaCqT8
         VwaA==
X-Gm-Message-State: ANhLgQ2MoBhhILVJMBQFhIk+ztQdorvLHJibKaAJGAZwBoiqNYGiJ4lr
        v/R0c2uRUh4AbX19I5TV39pb7aamEhk=
X-Google-Smtp-Source: ADFU+vsmq+YNNs/AQ7RSRqx1Gjpra3+4JHGFK+7giKEC5H7m8QiSff8xOH0yIqqeiGDuQWW01WtczQ==
X-Received: by 2002:a2e:3619:: with SMTP id d25mr2965264lja.231.1582813209903;
        Thu, 27 Feb 2020 06:20:09 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 04/15] trace-cmd: Implement new API tracecmd_add_option_v()
Date:   Thu, 27 Feb 2020 16:19:50 +0200
Message-Id: <20200227142001.61577-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

A new tracecmd API tracecmd_add_option_v() is introduced.
It adds new option in trace.dat, similar to tracecmd_add_option(),
but the option's data is passed as list of buffers. The standard
struct iovec is used as input parameter, containing the option's
data buffers.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h    |   5 ++
 include/traceevent/event-parse.h |   1 +
 lib/trace-cmd/trace-output.c     | 117 +++++++++++++++++++++++++++----
 3 files changed, 108 insertions(+), 15 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index d1b4a60f..b6393a89 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -278,11 +278,16 @@ struct tracecmd_output *tracecmd_create_init_file_override(const char *output_fi
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
 					    const void *data);
+struct tracecmd_option *
+tracecmd_add_option_v(struct tracecmd_output *handle,
+		      unsigned short id, const struct iovec *vector, int count);
+
 struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
 						   const char *name, int cpus);
 
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_options(struct tracecmd_output *handle);
+int tracecmd_append_options(struct tracecmd_output *handle);
 int tracecmd_update_option(struct tracecmd_output *handle,
 			   struct tracecmd_option *option, int size,
 			   const void *data);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 52bafa54..cfab6005 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -11,6 +11,7 @@
 #include <stdio.h>
 #include <regex.h>
 #include <string.h>
+#include <sys/uio.h>
 
 #include "traceevent/trace-seq.h"
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a3dda270..acdd2d57 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -951,21 +951,27 @@ static struct tracecmd_output *create_file(const char *output_file,
 }
 
 /**
- * tracecmd_add_option - add options to the file
+ * tracecmd_add_option_v - add options to the file
  * @handle: the output file handle name
  * @id: the id of the option
  * @size: the size of the option data
- * @data: the data to write to the file.
+ * @data: the data to write to the file
+ * @vector: array of vectors, pointing to the data to write in the file
+ * @count: number of items in the vector array
+ *
  *
  * Returns handle to update option if needed.
  *  Just the content can be updated, with smaller or equal to
  *  content than the specified size.
  */
 struct tracecmd_option *
-tracecmd_add_option(struct tracecmd_output *handle,
-		    unsigned short id, int size, const void *data)
+tracecmd_add_option_v(struct tracecmd_output *handle,
+		      unsigned short id, const struct iovec *vector, int count)
+
 {
 	struct tracecmd_option *option;
+	char *data = NULL;
+	int i, size = 0;
 
 	/*
 	 * We can only add options before they were written.
@@ -974,32 +980,63 @@ tracecmd_add_option(struct tracecmd_output *handle,
 	if (handle->options_written)
 		return NULL;
 
-	handle->nr_options++;
+	for (i = 0; i < count; i++)
+		size += vector[i].iov_len;
+	/* Some IDs (like TRACECMD_OPTION_TRACECLOCK) pass vector with 0 / NULL data */
+	if (size) {
+		data = malloc(size);
+		if (!data) {
+			warning("Insufficient memory");
+			return NULL;
+		}
+	}
 
 	option = malloc(sizeof(*option));
 	if (!option) {
 		warning("Could not allocate space for option");
+		free(data);
 		return NULL;
 	}
 
-	option->id = id;
-	option->size = size;
-	option->data = malloc(size);
-	if (!option->data) {
-		warning("Insufficient memory");
-		free(option);
-		return NULL;
+	handle->nr_options++;
+	option->data = data;
+	for (i = 0; i < count; i++) {
+		if (vector[i].iov_base && vector[i].iov_len) {
+			memcpy(data, vector[i].iov_base, vector[i].iov_len);
+			data += vector[i].iov_len;
+		}
 	}
 
-	/* Some IDs (like TRACECMD_OPTION_TRACECLOCK) pass 0 / NULL data */
-	if (size)
-		memcpy(option->data, data, size);
+	option->size = size;
+	option->id = id;
 
 	list_add_tail(&option->list, &handle->options);
 
 	return option;
 }
 
+/**
+ * tracecmd_add_option - add options to the file
+ * @handle: the output file handle name
+ * @id: the id of the option
+ * @size: the size of the option data
+ * @data: the data to write to the file
+ *
+ * Returns handle to update option if needed
+ *  Just the content can be updated, with smaller or equal to
+ *  content than the specified size
+ */
+struct tracecmd_option *
+tracecmd_add_option(struct tracecmd_output *handle,
+		    unsigned short id, int size, const void *data)
+{
+	struct iovec vect;
+
+	vect.iov_base = (void *) data;
+	vect.iov_len = size;
+	return tracecmd_add_option_v(handle, id, &vect, 1);
+}
+
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 {
 	cpus = convert_endian_4(handle, cpus);
@@ -1047,6 +1084,56 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 	return 0;
 }
 
+int tracecmd_append_options(struct tracecmd_output *handle)
+{
+	struct tracecmd_option *options;
+	unsigned short option;
+	unsigned short endian2;
+	unsigned int endian4;
+	off_t offset;
+	int r;
+
+	/* If already written, ignore */
+	if (handle->options_written)
+		return 0;
+
+	if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
+		return -1;
+	offset = lseek64(handle->fd, -2, SEEK_CUR);
+	if (offset == (off_t)-1)
+		return -1;
+
+	r = pread(handle->fd, &option, 2, offset);
+	if (r != 2 || option != TRACECMD_OPTION_DONE)
+		return -1;
+
+	list_for_each_entry(options, &handle->options, list) {
+		endian2 = convert_endian_2(handle, options->id);
+		if (do_write_check(handle, &endian2, 2))
+			return -1;
+
+		endian4 = convert_endian_4(handle, options->size);
+		if (do_write_check(handle, &endian4, 4))
+			return -1;
+
+		/* Save the data location in case it needs to be updated */
+		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
+
+		if (do_write_check(handle, options->data,
+				   options->size))
+			return -1;
+	}
+
+	option = TRACECMD_OPTION_DONE;
+
+	if (do_write_check(handle, &option, 2))
+		return -1;
+
+	handle->options_written = 1;
+
+	return 0;
+}
+
 int tracecmd_update_option(struct tracecmd_output *handle,
 			   struct tracecmd_option *option, int size,
 			   const void *data)
-- 
2.24.1

