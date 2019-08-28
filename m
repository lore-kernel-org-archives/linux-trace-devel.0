Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C8EC3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5646B2189D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJEWsW4o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfH1I56 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 04:57:58 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37927 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfH1I55 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 04:57:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id o184so1151217wme.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 01:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GbGYkEmYblBmNINRPa8aXQYJD8H6TCYdrUpYwcLE0Vg=;
        b=KJEWsW4oGOag8fFMGP2nHLf/hslTvWZcNnnkCKfZNO9RAzjm0NOviq9cLQgrSvLVzI
         c06bk/x5cOkOHueFg7O65iC49JBTNtK0/IsG3UQmBtrMUaUrrBNvJCQstQE+zHiakSXU
         +RzC1nsfD659ERqaibazj2j2R+8/ZfGRQRyqQJ98n5beFaJr2eReQ+yG148yum4+IA8q
         xwSjpVm+4yfsehOCl/9W5CHMyYpp9pD1xupQNptSt1qo2mFCwt/37bodBHRgzsfC+YJe
         xCyANwXX28hXnTfmmcBVSPQvX5WAhHY5iw+ubrVd7iQ2QzECBUNKVf2uA0t7ZMCwFY9U
         RDyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GbGYkEmYblBmNINRPa8aXQYJD8H6TCYdrUpYwcLE0Vg=;
        b=Qf5Qfehpf48q1Ntq1JeNS5NBu4ENfbJw6HahBI/TcS+xctixCvZrGdoagDqkT17Gsj
         vDQCSO996PiIoL7pc/icAi/vTOmWiRksQ8bocdqUgL4KJC7yqZLU/kuXo2UBVrXbqSyj
         tPivRE9WIjpqQtyJWx1ObfRm8SOIJiZGNCbNxSIT8FgovG9eMW/ANxj6qKT5T/FvTadN
         9S0ZMDBS0dhr7x6ZTXwzRqOPaivyIdKTA5/Fx3G4gjOZ+tCnEnj+YK/dRi5X/VuDWTv4
         NHNxgsBw7LsFHU6G+iwxdo4owqKxGl2Fj0jv47sxV5Kv2s2HXux/EyIbQnjz6uoJrB+j
         op/g==
X-Gm-Message-State: APjAAAWutmRXljyXoSjYImzwtxHtEbUMcPdxZ33oVD/L7XYtXD03au9a
        W2TTKxO1OD70aVCJaFwhBog=
X-Google-Smtp-Source: APXvYqwpmJcoiNfTKfbpX7JTB5KUoJxUD6ju+y9nXDuXce3XjMnGbyQxrLmi3VDryGLCmRGWXVw6ww==
X-Received: by 2002:a7b:c775:: with SMTP id x21mr3638106wmk.90.1566982675481;
        Wed, 28 Aug 2019 01:57:55 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u186sm2579433wmu.26.2019.08.28.01.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 01:57:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 7/9] trace-cmd: Implemented new API tracecmd_add_option_v()
Date:   Wed, 28 Aug 2019 11:57:44 +0300
Message-Id: <20190828085746.26231-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828085746.26231-1-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

This patch implements a new tracecmd API, tracecmd_add_option_v()
It adds new option in trace.dat, similar to tracecmd_add_option(),
but the option's data is passed as list of buffers. The standard
struct iovec is used as input parameter, containing the option's
data buffers.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h    |   5 ++
 include/traceevent/event-parse.h |   1 +
 tracecmd/trace-output.c          | 114 +++++++++++++++++++++++++++----
 3 files changed, 105 insertions(+), 15 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index c7cac98..6f7bc2e 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -249,11 +249,16 @@ struct tracecmd_output *tracecmd_create_init_file_override(const char *output_fi
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
 					    const void *data);
+struct tracecmd_option *
+tracecmd_add_option_v(struct tracecmd_output *handle,
+		    unsigned short id, const struct iovec *vector, int count);
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
index 65cabd9..b7bda12 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -11,6 +11,7 @@
 #include <stdio.h>
 #include <regex.h>
 #include <string.h>
+#include <sys/uio.h>
 
 #include "traceevent/trace-seq.h"
 
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 33d6ce3..41fb037 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -883,22 +883,25 @@ static struct tracecmd_output *create_file(const char *output_file,
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
  *
  * Returns handle to update option if needed.
  *  Just the content can be updated, with smaller or equal to
  *  content than the specified size.
  */
 struct tracecmd_option *
-tracecmd_add_option(struct tracecmd_output *handle,
-		    unsigned short id, int size, const void *data)
+tracecmd_add_option_v(struct tracecmd_output *handle,
+		    unsigned short id, const struct iovec *vector, int count)
 {
 	struct tracecmd_option *option;
-
+	char *data = NULL;
+	int i, size = 0;
 	/*
 	 * We can only add options before they were written.
 	 * This may change in the future.
@@ -906,32 +909,63 @@ tracecmd_add_option(struct tracecmd_output *handle,
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
@@ -979,6 +1013,56 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
2.21.0

