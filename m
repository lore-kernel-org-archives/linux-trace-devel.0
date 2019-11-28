Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF37C43141
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33B6F2176D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E5BPcpbf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfK1IyZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 03:54:25 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42175 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfK1IyY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 03:54:24 -0500
Received: by mail-lj1-f194.google.com with SMTP id e28so3401339ljo.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 00:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Irh037ZGGW4R8h8ErESe2jql4GwDXX/8LCDplJHfmvE=;
        b=E5BPcpbfKsP/FjZIcvQVIUFtUcNCoUuGlBk9Nz/xB3KGCXm1dImgbCJOaQckGWq+Qg
         g1dF/1q24yTbe26UdhsS7E6E4dP4R47l2cdV7N7iUBho3tSG15Fd7YN0AoNk5v8ZzSQs
         b61vSr1FzexaNfD5TFncDBzzW2l87vC+Y46iplb/CfG1OYzxm4nNAarMEaBzhmGPiiqx
         3cWLP0O8H0CX+JTkjg6iT6gg5dhIT9oxlR8RQbnwQSDq+o8lO7VmQ89BuKLTfmy3Xv5X
         NkkuL7irJ55TAqBOISMMPkGkzrbkRaQRyZ2JYYhcR4yRedOdGpIKKpjitqS0D4a0YLLv
         vzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Irh037ZGGW4R8h8ErESe2jql4GwDXX/8LCDplJHfmvE=;
        b=c3+ouiOB2zF5+6l51YzaLLaUVlbpR9jqjetWhn65j/9LrO1KtB/TLv2FFiEpSHZnNm
         Dm70d/awEXaUMPnEZvhhv0qRK/Z1/QgXmq3MCdSxamtru9foxwtW/H8WJNNjBjKoS7e0
         Zq7ZVFp/gowTN5w92mDGli8jwhuWIrvrLre7Qps2I0O+CmWbmWZmDVDCUmSAqwGNN4Eg
         VO4+rNnXrVrJ2rSfL7J0EKwmN0FY0XCK0h+ypzCL6YdhzKvF9jLXUOveotwf+ZC9fjME
         YmQaHY4FnMtYSAuSFlyvA4OngxMYxJVlk3InRqxFbCjFhAAvY9q/tz8T2R3hjVwRLtay
         U1Hw==
X-Gm-Message-State: APjAAAVJ7iMvCxxvxFXp5ePCMsaTm+byIWlXw/E6UmM6Fbv9xci9SXmO
        Gg7B31ewTuSe00N9O6cm+kH10rbqHi8=
X-Google-Smtp-Source: APXvYqzvTQ7EberRbt1PSmDVBXssWW38d1aE6YPCgts6Z7dJnMcbkzJIdttxX5XgAs3LU+TUYYJzXw==
X-Received: by 2002:a2e:8e97:: with SMTP id z23mr32805266ljk.149.1574931261730;
        Thu, 28 Nov 2019 00:54:21 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z19sm8253735ljk.66.2019.11.28.00.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 00:54:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 08/18] trace-cmd: Implement new API tracecmd_add_option_v()
Date:   Thu, 28 Nov 2019 10:53:59 +0200
Message-Id: <20191128085409.289684-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128085409.289684-1-tz.stoyanov@gmail.com>
References: <20191128085409.289684-1-tz.stoyanov@gmail.com>
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

