Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3278CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BDDF61252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhKKPLv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbhKKPLr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:11:47 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6800C0613F5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:57 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id t18so5986607edd.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J4Sa2loNC2J5Dn1F+0UFcuFjZX019rFzMn8JNOgtKYE=;
        b=MlWjh7VH+3ryBh4gQP78ChjN58fLL+dsGq+UVPO8DlZuzJIRi7D6LPm7p1JAjHkOiE
         zBBMovglhJQ82iXcOzH1H1pd6eT6I1xGDhQc5xqAoVltbLNy2gqGFDGZFCUY1lK6MPHx
         gYfEMkBRckWoGJKsad7ObF7awVaqqJm4yOMOjROXXw1b4Hcp1xihplD0woehDAg4mrcU
         6YwaseZvH/1/hiRa0XdqaeOU5ll4CoASpgzpHkS45rh74SH2wofnDFotqtCM/SJ/nkqu
         pkkTS78HjFNP1/J8b2dQrrUCll87oJgNp3px8c7E8OcpnEJ58RB+GEX25pGSkuZVvbAe
         P+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J4Sa2loNC2J5Dn1F+0UFcuFjZX019rFzMn8JNOgtKYE=;
        b=xUV2tug++j6B66E0oSB5J4EnAikfW3bC3Fjw9Xf/21QCTCKIUWsOAWVvBW/tU5S7aB
         njQk9oqkf2ELfg1qnsRImGn0Y8w9Mq3yv+nsjgDNfqff4YRyuvVWbr3xjT8v3G0LdhBB
         xBT2wES1wDd4OFFjfroDS2mlbdTZMltV+IzmG7KmH8SQIvNRjcP6CQckSG306R3T+EE9
         dyAVqJ/MdRm/vd4D9nWfRocaFyqThmWKI2JogMRSIGZv1TQL3w1HwOteRiz8hrHrnai7
         Dng+ii1cr0Ny2BKyHWmaMsE5nY/HfPIbq1dHWFiDdURm1MjWcT6siV+qPGTihD6+fLyv
         JJsA==
X-Gm-Message-State: AOAM532MjmT7Nvyteiv8YQOURFS6ypE7KTrwf9zMWNxF7Be4d5d6zb9p
        vMg/mC+a2/LlYlpI4rgMvCCmIjAxdEXUIg==
X-Google-Smtp-Source: ABdhPJxzxNABe4rRlKNrts2M/Kggu7xs4c/+A+QHu5L3QZJqK5m7aoWB/6i5S8nwiqqKZleHSWQNIg==
X-Received: by 2002:a17:906:1913:: with SMTP id a19mr10257359eje.484.1636643335151;
        Thu, 11 Nov 2021 07:08:55 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id hs8sm1544051ejc.53.2021.11.11.07.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:08:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 03/25] trace-cmd library: New APIs to get and set version of output handler
Date:   Thu, 11 Nov 2021 17:08:53 +0200
Message-Id: <20211111150853.86566-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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
index 47a30246..eaa902a3 100644
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
index b43f9e47..e8c788ad 100644
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
@@ -1885,3 +1905,12 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
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
2.33.1

