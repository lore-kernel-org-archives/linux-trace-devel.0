Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DD0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346595AbiASIZP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352358AbiASIZO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:14 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5141CC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:14 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id q25so7643986edb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zi7+vslc/ZiY52+jOy+DyEXY9P5mYpQ8HCQAQVaqY/4=;
        b=BRFH9ZEOL7dkDWP/wMBu+uBCfNWEVBMNS/mgWTHjYFtuUdiJeD4SIx9iZRDnszv4tu
         M5Ja/9Vinkh9Bs5dDqKYvXyHVJcgg+OaG+xAxL8TOTy07mLCYC/ozjfm6H99rye/Bpef
         COEAE111HtAmeSyeqNVBxaPj9t6UVkcL+vxPMN34PaZiKzmla/365VS4nPbZuMNG3iae
         2grNsJ6dCSScrAXBim7LEsAyQyYU/0n8KQ8k2z5BWo6lvY7Hfk1+1o6q/5mDlGyis7Kp
         q4rZImOezYVnNUkrNt7IyN/hMsimcEE9+uSKOlWuuwl8pBr5rBfvOBmkqhCDYIR1j05l
         Bw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zi7+vslc/ZiY52+jOy+DyEXY9P5mYpQ8HCQAQVaqY/4=;
        b=OpteHxz6keeQEBSb5Zo4lwMzmjhYWRxVr1u/betX9EGP91gR6qx3ZF83xJqjzJcrYH
         BryebYSdBDH9qkMxpn1+3hD5mO6Pja0FCEYDOPRHrl0/qOdE8Jy3AzO/id3bUYlpxrTk
         3S+JzRCFlC0m2h2JYAYiKXfRqbkXNz9QDOIC4Ij277XLbDFzNfiTzdR331AibzibCk1u
         yvsrgUAj0JFJZutkpvCkUskl88rCDo1DCpRByCFP+vmYbK9aLEml1YJT44XxgwiP5NJK
         8OHkl6//bZGmPof5b+06FN5xquNExp2JO/5V9GjZSohGyOBfT1aU+UCGFLwLgOnW3GnM
         YCow==
X-Gm-Message-State: AOAM530sL24yw3BUVEmC/nIk8COFSJMdDMOEO9MaSIzngzPFMjGyK+zN
        gfvvMfZ6n9Hz4Hiq9WuyK6c=
X-Google-Smtp-Source: ABdhPJyKkjJg/OnnzruScYrn2jEmbbMcSgNQU/kwMjwMcTdI5frv7CKXzqTr4UD8PSME2NPLWukoHQ==
X-Received: by 2002:aa7:c448:: with SMTP id n8mr27312781edr.378.1642580712886;
        Wed, 19 Jan 2022 00:25:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 03/25] trace-cmd library: New APIs to get and set version of output handler
Date:   Wed, 19 Jan 2022 10:24:45 +0200
Message-Id: <20220119082507.245600-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are cases where the version of the file, associated with given
output handle must be get or set. Added new APIs for such use cases:
  tracecmd_get_out_file_version()
  tracecmd_output_set_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 ++
 lib/trace-cmd/trace-output.c                  | 28 +++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 3e366fe0..77374000 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -285,6 +285,7 @@ int tracecmd_output_set_msg(struct tracecmd_output *handle,
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tracing_dir);
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle);
+int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version);
 int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list);
 
@@ -318,6 +319,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 6ed4bbf0..4d165ac2 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1065,6 +1065,25 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracec
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_version - Set file version of the output handle
+ * @handle: output handle to a trace file.
+ * @file_version: desired file version
+ *
+ * This API must be called before tracecmd_output_write_headers().
+ *
+ * Returns 0 on success, or -1 if the output file handle is not allocated or not in expected state.
+ */
+int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version)
+{
+	if (!handle || handle->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+	if (file_version < FILE_VERSION_MIN || file_version > FILE_VERSION_MAX)
+		return -1;
+	handle->file_version = file_version;
+	return 0;
+}
+
 /**
  * output_write_init - Write the initial data into the trace file
  * @handle: output handle to a trace file.
@@ -1880,3 +1899,12 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 {
 	return check_file_state(handle->file_version, handle->file_state, new_state);
 }
+
+/**
+ * tracecmd_get_out_file_version - return the trace.dat file version
+ * @handle: output handle for the trace.dat file
+ */
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
+{
+	return handle->file_version;
+}
-- 
2.34.1

