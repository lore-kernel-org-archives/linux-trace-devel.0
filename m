Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF197C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A543960FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbhIMMbL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239995AbhIMMbJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:09 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92A7C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:53 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id e26so6537954wmk.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QUuYYLFD5YuznHGQPFKHAZ1VmNSj3wuUH/DMQ9e2ajc=;
        b=Bhe4X7ix3qQn6wYuFSVf2jJ+J5pYx36qI0PlQHhK7CqLL9NUUZ9Us3f3UhS5INdWS0
         BVJ89dCSJCPoTPRMnMnGHlvzDd1v/23FUyay6fATpvRP4tYAjtmU2quJjTabRkRTmv0M
         BcTUKZwoGap8WzmKKWKx+cqDHY7E2FB09uUcfGfb8uclfyd5Zz9fNRnZwt4hw9LBuaVE
         w4eNeJRVea5ZQOS5lMOtTq4Z83BkDzxlIVofazMjYfAroUTSUmYAgX+7pPJZI5DQFvl3
         /CrHIs2P+cEoDMR82gAS47szf6jmyXMEGzGORPLZoJhKQ8eoSd5xdgGq/RlZBIdbnhYL
         R0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QUuYYLFD5YuznHGQPFKHAZ1VmNSj3wuUH/DMQ9e2ajc=;
        b=LnNG4CoiwmqzWFBJk+F9lWW4Sw3gdaRj3zYJZ4XHgQJy/mfKowlh1CBF7M4YnFrMwR
         vmH/5zOLqp0zbiV1oYSjmh2r10w3Hx/tlA9n3b9Lh5f4boZpgMIEiXG6/pPBIOuHxiK5
         /+kkoBAmmtyZkBUcrR4AuoppvaVAt113VT0rWbqTDWSj/jd18YfCIwQ958Ip5KgNBVB7
         M82G0flTcALJtCdZuQxk6UzoC5n9ojc/gWlHExv4TimlNa6USS9wW06mh1Q/5At22gYn
         j1/rs3VyHndYerfJzjldAHFgvwxZiD2F2Y67xe5yKAdTggZgHAr3DFkuwVT37KCEf3Ea
         rJ8A==
X-Gm-Message-State: AOAM533JjDBEkQXGRubCQ6qfZ4aEolTgeaubhZzHmF+DvoTH9YiDb7mE
        3ucSVMs5JI3KLCe/2aWEJg3u86Lk9gY=
X-Google-Smtp-Source: ABdhPJz8CeJRkWIWUWR8XS4sYARAGbqMhXfiTUYI/v6YRkLippM/cQpu21Qj6FgKHYxJFK7CzwClUw==
X-Received: by 2002:a7b:c191:: with SMTP id y17mr3186255wmi.122.1631536192546;
        Mon, 13 Sep 2021 05:29:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:29:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 03/25] trace-cmd library: New APIs to get and set version of output handler
Date:   Mon, 13 Sep 2021 15:29:25 +0300
Message-Id: <20210913122947.3673239-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are cases where the version of the file, associated with given
output handler must be get or set. Added new APIs for such use cases:
  tracecmd_get_out_file_version()
  tracecmd_output_set_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 ++
 lib/trace-cmd/trace-output.c                  | 29 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 460f8a5d..ae930c2f 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -281,6 +281,7 @@ int tracecmd_output_set_msg(struct tracecmd_output *handler,
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
+int tracecmd_output_set_version(struct tracecmd_output *handler, int file_version);
 int tracecmd_output_write_init(struct tracecmd_output *handler);
 int tracecmd_output_write_headers(struct tracecmd_output *handler,
 				  struct tracecmd_event_list *list);
@@ -315,6 +316,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 118aa581..9226e817 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1063,6 +1063,26 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct trace
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_version - Set file version of the output handler
+ * @handle: output handler to a trace file.
+ * @file_version: desired file version
+ *
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_version(struct tracecmd_output *handler, int file_version)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+	if (file_version < FILE_VERSION_MIN || file_version > FILE_VERSION_MAX)
+		return -1;
+	handler->file_version = file_version;
+	return 0;
+}
+
+
 /**
  * tracecmd_output_write_init - Write the initial magics in the trace file
  * @handle: output handler to a trace file.
@@ -1877,3 +1897,12 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
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
2.31.1

