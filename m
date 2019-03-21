Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB60C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A894218A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 15:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfCUPrW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:47:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40512 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbfCUPrW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 11:47:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id u10so3270852wmj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Mar 2019 08:47:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JNqi7C8pyRGKeE/tIEDKYJjlebPy53SLgPVmoL2+Am0=;
        b=pukiij30CWrGmjgw0mOySUoarMdyElDjrLU9CX3QlDjfdrjIovpxB4IKTIv3WaKLl8
         HOXqEW5NAyo7enWSj9FKLc2R6Gjg5d+ssExcSl8IpaF0brZ8k27c3dwRXGMW4UlFH79J
         kMs10ZCqvdnZ8azPOnqU74xUCadRFTOF4BPA+4m8K4WAO1AQ1MVAt8nMgidYdrzffmYG
         kvdPZHlacuYuOb5PpSHJU5GPUXBgFrtZ2zxAKLUzq7JxBLEZE12lXmNbkb0cpGyN5TUf
         C6Go785uQ/FYrtWwUEaD/3dPW/rNpRxwJBhUMI/QQnP3Ig//ByHhp+3U4+MhWJouET8+
         /LDg==
X-Gm-Message-State: APjAAAWE8Tw2JxE72035E8o2UgYDBHVFFoYdwsBLfNW8P4RBDmoTjqmK
        el3iVdlpADOoknvOk1zYfeqJnLVE
X-Google-Smtp-Source: APXvYqybypxwBKL19pAfwESlqgBJUmusZTB2y9/zEpWRx33DQbTWCknCICFy6IWx08XhGyHGGwT+Uw==
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr2927907wma.2.1553183240617;
        Thu, 21 Mar 2019 08:47:20 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c10sm8940049wrt.65.2019.03.21.08.47.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Mar 2019 08:47:19 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 7/9] trace-cmd: Implemented new API tracecmd_add_option_v()
Date:   Thu, 21 Mar 2019 17:47:07 +0200
Message-Id: <20190321154709.24163-8-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190321154709.24163-1-tstoyanov@vmware.com>
References: <20190321154709.24163-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch implements a new tracecmd API, tracecmd_add_option_v()
It adds new option in trace.dat, similar to tracecmd_add_option(),
but the option's data is passed as list of buffers. The standard
struct iovec is used as input parameter, containing the option's
data buffers.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h    |   5 ++
 include/traceevent/event-parse.h |   1 +
 tracecmd/trace-output.c          | 117 ++++++++++++++++++++++++++-----
 3 files changed, 106 insertions(+), 17 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 428d792..f7c043a 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -245,11 +245,16 @@ struct tracecmd_output *tracecmd_create_init_file_override(const char *output_fi
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
index 3f2ae80..9705b51 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -11,6 +11,7 @@
 #include <stdio.h>
 #include <regex.h>
 #include <string.h>
+#include <sys/uio.h>
 
 #include "trace-seq.h"
 
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 33d6ce3..d57539c 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -883,21 +883,23 @@ static struct tracecmd_output *create_file(const char *output_file,
 }
 
 /**
- * tracecmd_add_option - add options to the file
+ * tracecmd_add_option_v - add options to the file
  * @handle: the output file handle name
  * @id: the id of the option
- * @size: the size of the option data
- * @data: the data to write to the file.
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
+	char *data = NULL;
+	int i, size = 0;
 
 	/*
 	 * We can only add options before they were written.
@@ -906,32 +908,63 @@ tracecmd_add_option(struct tracecmd_output *handle,
 	if (handle->options_written)
 		return NULL;
 
-	handle->nr_options++;
+	for (i = 0; i < count; i++)
+		size += vector[i].iov_len;
+
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
-
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
+	vect.iov_base = data;
+	vect.iov_len = size;
+	return tracecmd_add_option_v(handle, id, &vect, 1);
+}
+
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 {
 	cpus = convert_endian_4(handle, cpus);
@@ -979,6 +1012,56 @@ int tracecmd_write_options(struct tracecmd_output *handle)
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
2.20.1

