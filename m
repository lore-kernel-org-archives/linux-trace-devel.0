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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75082C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59385611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhIJNwS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbhIJNwS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCF7C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:07 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v5so2609280edc.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XYWKf7lOqw35y9lN/8H1/Bvl1oes+h87vk8aUd9pYvs=;
        b=PEimNWqSltdBBVGSbe2bJbBmpO/gBQFWUFxKjVH/lS/lnA4UmX0vV6wqytBv8GKpT9
         P6DCQjWrKmC7FLsnWB/EovBxWZQ2SfpfFW2iPeIz3r0xxDYA5SdRyn5QEJ+ksKngwtD7
         4HtGpaFJv4r1gO3AfnIZUI41gNW2Mu4iCi3cflEKAzmn3Kji5g4si6kyblwyMWJMNyFH
         0RV1gaYmxyvu5+aVpU73SJj8Yfo2n/Wd2wLhJeysfvKgXeUOir363S1e4f/Tf19eivN3
         4lvn8Lhr6f7dKP0ZxgIxSA1aPANXSea9kLAzmiO1kZ5O2gns1dn8oP4/civpiaAaZMwI
         QV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XYWKf7lOqw35y9lN/8H1/Bvl1oes+h87vk8aUd9pYvs=;
        b=lwhZuEZAWt3Hc/MsHXfrMLGL9lLlWV7cYef4WnLR6d30VxtO+TCfQGRJp4YKMVGWaV
         CcMrQ161GV58dLMM/1biB+lOqsT80nQohJSdurqgvhQbF/3eGAkI70Ne3wNgbDH5xSND
         j2fyTBsQeAlecN3RrtNfxG4LAKhO1fs9RI5W6E0ESCFWYIEM+Jv/9UkPyvdVvWkhjRWu
         OhlkqSTkAfrgQLE5D0ZQ0/ZFuZCjiLUBi3SQjh4UEsY3ryS22pSfmBoQbYxwK95uEmyf
         qkHf7sTvw/qhY8UPFVBPdP3PYHjKEGqIgphDXk0BXf+RrY+ylGKgh+DmElJ0pdT5pbXg
         Lp3w==
X-Gm-Message-State: AOAM531eJOhBvHfwNETPul0nHY9DvUpR6yK3dSf7ZNAIOUbTb3bXkF4f
        XILmvJPrkXIOY1Xr8SvEnQPBhDEqi8U=
X-Google-Smtp-Source: ABdhPJyRRSzCWNVXNGCS6ykaovlIAsPWdMkrNZxhrZsQdmS9fgPRHrX1p77lrxzIynhQAYsrIYdpJQ==
X-Received: by 2002:a05:6402:1395:: with SMTP id b21mr9383136edv.119.1631281865860;
        Fri, 10 Sep 2021 06:51:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/25] trace-cmd library: New APIs to get and set version of output handler
Date:   Fri, 10 Sep 2021 16:50:39 +0300
Message-Id: <20210910135101.2865226-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index 71ed55cf..08bf7614 100644
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
@@ -1880,3 +1900,12 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
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

