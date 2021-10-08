Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78324C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58C3C60F55
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhJHEWA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEV7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:21:59 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3223CC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:05 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z20so30912819edc.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GDDUdKSCtaRVRD/IRQKkFfu0acN1cHUKT1c4drthDFI=;
        b=jCCpw4k+8taLwDECkpVdYp4FaNj87d4HX+0rb49GeSB9u8iIq1oWsD1euCs7q3LXfX
         qeE2pf6WtHmQqR1A04L/bU0/jOxkjJ7fJM3jZ0Em00ijQfu6/Su09eiw1cRVluKslKHk
         g1hdzRrcmZ4i+svpL7pl+Ru4lYXNQ3O+tSY4O1+ZX1L1Cz95cK9Jk+yQl6P8MMciUnJ5
         n90eXpKKHmPDtoZi+2cxtwt8qAsvtsdCTic0T2kNpyOKB9NYtag+RPWJJp1Pi46SNhf2
         pwHxKynf1kB2ys7yi6c4hKPt967boNEMOjcUiQTl/OYt54B1hi1RQ8+mjQpZNxprCwg2
         T0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GDDUdKSCtaRVRD/IRQKkFfu0acN1cHUKT1c4drthDFI=;
        b=Uk8H9qkU/FeuLPKvoj8b2A3PV0y/7APulyBQ4ScuODrII2hqa87cmdXuRMqAGbXm97
         G4ZEBnW4BsJaCokC1C2bMOs5s9br0QDWtPc8purh3HBT1ItQJEyysOVav+JbtA1N+2WE
         qc0bJ+cZOGKw2yy5bZjaI3ZDaB5OTemcDD5Ly6oXd5G+IoVlyKw50M7zw8SBocaa9DGw
         NFQSPFcEzPC0n1uK8hqqlQ02CTMARGc3RaD2BCt2XaIktxA6KXjAQRcr47K4WNgAprDu
         t50CPspYnR9KQqUnofWddbY0RY0MaFSBwa4SP7l9e9EDLiN9rnnG5gPKwsSBx0hFYtoX
         5TnA==
X-Gm-Message-State: AOAM532SO2lRw2RyXi/4WlbBlU0YXFXt3ZeljiwD15ZVqq4MqmtCgJNb
        9V0jVS9U7p6qsoxkxNiKkkpJBKI7q4yMew==
X-Google-Smtp-Source: ABdhPJw/lBd76EvcEPFW3VBAc6myqoWXV+9+h456GY4xbGasS1ITX6LdwKUSGlQjUQ+bCLVS4HuOOg==
X-Received: by 2002:a50:be82:: with SMTP id b2mr11691493edk.56.1633666803777;
        Thu, 07 Oct 2021 21:20:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 03/25] trace-cmd library: New APIs to get and set version of output handler
Date:   Fri,  8 Oct 2021 07:19:36 +0300
Message-Id: <20211008041958.976309-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index 10e5875f..fa11fe77 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1055,6 +1055,26 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct trace
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
@@ -1882,3 +1902,12 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
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

