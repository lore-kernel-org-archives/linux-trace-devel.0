Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FC6C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240090AbhLJLDU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:19 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DF5C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:44 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y13so28281260edd.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PCHlHvkzHaJ4SiSlcY0lkejT6x1X8SjCTCr8Wg+3s5Q=;
        b=YKv6zmPbYDUYNlr/Hk2ww966NKF3NdEenhf9Ri8xCYZa8dgXME4cMbsM8J8yeXI/HZ
         YKo0vIxwQdoKfkLliiU5ztZDHJV0AKveTUYODFev2okAaWDgc63akZOeDolZEbASegQh
         3xvZTnIb9JYuXaVMQcqHezL/JdsGyvT/JUSL/11EVN62tgZoFgXk1TbZgn7mxNgzzFys
         2nl8y8g59zGiruDYl1MW2tm+s89C/yGOe/ttdBiW+pXfFvIgDgGeDIQJu7YLx0GNEo+g
         OPNtXI7AVfB/0j5OEVr+zsLSlWXvYx9WJ8xMZPDnEsLB5GqQFCeZ023ASHu9zE5QcbTv
         COag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PCHlHvkzHaJ4SiSlcY0lkejT6x1X8SjCTCr8Wg+3s5Q=;
        b=i9OXNtZBkg79nPecY3Jxq7e5jLVO+yuQC0bYtSSE96JkUBSUY32X6AWMY6rHxo+Spj
         V7nvlI3a9SAcbOundnZoF2EB5M1Uw43NpaQ/T9crAFbAqf33hmsiwAJb8tqXdpAocY3Q
         m7gmXfT2mn9EuoCetpFP49dJ76epKUBgerKoLdB11GgNaYcMRiw53n/ZyOB4/TkzrWI0
         AkIMzgdg9hUbOeZXchJ2OBCruU1Oz2vefXTKh63SBwt/nZEusSwNHnm2w5SsDEF5k9L5
         I9YO1NHl55/ftPSqnP6DtzMtRZvuty6wWfXMCgqOEdxn4wAtJF+UNNJ4NfF1irUW7g9I
         5KDA==
X-Gm-Message-State: AOAM533dF2vopCSfvJCnK/DfChpwVTh8Vm+oEgUu1+cFNlZeUaIpfmB8
        wpTX9Dvu+OGwJERqGbzWirEcWW855Xw=
X-Google-Smtp-Source: ABdhPJy9BE4iqkJTdY9fVbiZHzdP9Zqa1MevMfvpzgmvyDOwkKTpa/wegziPJoCg4Adp8sIliUw9xw==
X-Received: by 2002:a05:6402:514d:: with SMTP id n13mr37779268edd.380.1639133983318;
        Fri, 10 Dec 2021 02:59:43 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:42 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 04/20] trace-cmd library: Inherit compression algorithm from input file
Date:   Fri, 10 Dec 2021 12:59:22 +0200
Message-Id: <20211210105938.98250-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace file output handler is allocated, based on given trace
file input handler - use the same compression algorithm.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 ++
 lib/trace-cmd/trace-input.c                   | 16 +++++++++++++++
 lib/trace-cmd/trace-output.c                  | 20 +++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 139c0a78..924efeeb 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -256,6 +256,8 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
 size_t tracecmd_get_options_offset(struct tracecmd_input *handle);
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index eb1359b8..e35e3c74 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4649,6 +4649,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
 	return handle->file_version;
 }
 
+/**
+ * tracecmd_get_file_compress_proto - get name and version of compression algorithm,
+ *				      used to compress the trace file
+ * @handle: input handle for the trace.dat file
+ * @name: return, name of the compression algorithm.
+ * @version: return, version of the compression algorithm.
+ *
+ * Returns 0 on success, or -1 in case of an error. If 0 is returned, the name and version of the
+ * algorithm are stored in @name and @version. The returned strings must *not* be freed.
+ */
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version)
+{
+	return tracecmd_compress_proto_get_name(handle->compress, name, version);
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 6dda61f1..a4d29d8e 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1294,6 +1294,9 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kal
  */
 int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle)
 {
+	const char *cname = NULL;
+	const char *cver = NULL;
+
 	if (!handle || !ihandle || handle->file_state != TRACECMD_FILE_ALLOCATED)
 		return -1;
 
@@ -1305,6 +1308,15 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracec
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	handle->big_endian = tep_is_file_bigendian(handle->pevent);
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+							    handle->pevent, handle->msg_handle);
+		if (!handle->compress)
+			return -1;
+		if (handle->file_version < FILE_VERSION_COMPRESSION)
+			handle->file_version = FILE_VERSION_COMPRESSION;
+	}
+
 	return 0;
 }
 
@@ -2254,6 +2266,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -2294,6 +2308,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+							   handle->pevent, handle->msg_handle);
+		if (!handle->compress)
+			goto out_free;
+	}
 	tracecmd_close(ihandle);
 
 	return handle;
-- 
2.33.1

