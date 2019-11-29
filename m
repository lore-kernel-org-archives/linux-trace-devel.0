Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02267C33CB8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD04C217D6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rZrVRu5W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfK2KRt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:17:49 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39641 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2KRt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 05:17:49 -0500
Received: by mail-lf1-f65.google.com with SMTP id f18so22182294lfj.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Nov 2019 02:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Irh037ZGGW4R8h8ErESe2jql4GwDXX/8LCDplJHfmvE=;
        b=rZrVRu5WZigUMmzdgy3OFb2XAbAGD2F3KzAsEUW6Olz04DnTE+l+wDARl4CwAsYJg3
         R7jvxmuZM3NIJJBNbbMH6LlMLWV3YA1Gvenyg/BPXJHqm2QMzcK6c05d6XGoLP3eB1qb
         fXeeTu7zd4gHD7ao5pisArZBArj4RX2HCsV5G5MUavGX22Z3erWkZZxC5KK5LnbbFRgJ
         CdkwGCOFGtwwnE5Bmg7PLCi3t3QBINkNbEu6biE/21kTwcwXxRCzAihNNfFMFG+dGLGA
         ga+2n2F8dexKzmOiVQ/qbt6KINKcLrLpvjEuvqC4VI1gPumFlVfU6NYUs8LCM27HM6MA
         vifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Irh037ZGGW4R8h8ErESe2jql4GwDXX/8LCDplJHfmvE=;
        b=sJuXrFdxsypevjztbbc5wzobh5EFEzg61n4gblEpX4ynBOKs4Z593g02YlGCsHtQgs
         cmA5Bg90yTehsosT8H3RNxHBYYb1AenMhbVQe1h+/spMT8jryZpakeoXboH16Wll+4Gz
         LKJ2bfrM7RLXsQbjBtGIGs+xpsahYgbV/4Lb6ZlpxwFdlQ903TYoAd/lO0WdrPuoXnug
         JQVRlid2PTf2iqQ+PeBzfLfBzwvQbGP1AAHD6lR5o1rt04QNJ5aXidv0Wsp5X1xNIv2N
         s99DM+rj6Pu15KyTDndGYCAdNbHbAHOh2SjQBw0/p+ZtcmvUqod8VJAZ+A1gXHQ9+sIL
         wlIw==
X-Gm-Message-State: APjAAAVgq3hq8zyjMefDY8XN6caJTnyhwvt5fT5H5/CuGM1NauPZnsgp
        zp6mWdauEkl8QAcKJQU/oTs=
X-Google-Smtp-Source: APXvYqz84Libx2IHkfgIMrpuTXsteoTe3L5YTxhyuzHKPXBfhgQhRzEr5aOdx5CF2vv5xSg0rY+U5Q==
X-Received: by 2002:ac2:4199:: with SMTP id z25mr6287708lfh.102.1575022666270;
        Fri, 29 Nov 2019 02:17:46 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x29sm11367935lfg.45.2019.11.29.02.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:17:45 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v16 08/18] trace-cmd: Implement new API tracecmd_add_option_v()
Date:   Fri, 29 Nov 2019 12:17:23 +0200
Message-Id: <20191129101733.375808-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129101733.375808-1-tz.stoyanov@gmail.com>
References: <20191129101733.375808-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c     | 116 +++++++++++++++++++++++++++----
 3 files changed, 108 insertions(+), 14 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 831bb1a..47fa463 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -261,11 +261,16 @@ struct tracecmd_output *tracecmd_create_init_file_override(const char *output_fi
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
index a77af4c..30e06a7 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -11,6 +11,7 @@
 #include <stdio.h>
 #include <regex.h>
 #include <string.h>
+#include <sys/uio.h>
 
 #include "traceevent/trace-seq.h"
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index be4d3f5..db65ee4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -950,21 +950,27 @@ static struct tracecmd_output *create_file(const char *output_file,
 }
 
 /**
- * tracecmd_add_option - add options to the file
+ * tracecmd_add_option_v - add options to the file
  * @handle: the output file handle name
  * @id: the id of the option
  * @size: the size of the option data
  * @data: the data to write to the file.
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
@@ -973,32 +979,63 @@ tracecmd_add_option(struct tracecmd_output *handle,
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
+ * @data: the data to write to the file.
+ *
+ * Returns handle to update option if needed.
+ *  Just the content can be updated, with smaller or equal to
+ *  content than the specified size.
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
@@ -1046,6 +1083,57 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
+	handle->options_written = 1;
+
+	return 0;
+}
+
 int tracecmd_update_option(struct tracecmd_output *handle,
 			   struct tracecmd_option *option, int size,
 			   const void *data)
-- 
2.23.0

