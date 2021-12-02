Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF6BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357983AbhLBMZc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358221AbhLBMZV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:21 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92CEC06175A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:21:58 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so115413622edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fhN3EMHUINew41sFoQdsKAmLqqZJau9mu6Q+Il+IlwA=;
        b=IJ6DCVvscOtG7Geg7pNW20Pq6UrglcTfS+dsPAhJ2vTLlVc4ArQL1/CIcGpV7+M6IS
         bXyKEiVyCGxGWdcENUExtQaAlqXYl43zTMe95cvKzWKQaR14qU2Q1OAttdJw15/Ihd3a
         VBKsofGqUrSZIr8SJY1iFW3iD+9acGtWI4LJBA/rXiDO56X0IqvtS0xxqUlmr+ABWDe3
         ZaqK48OfOS3i3OR61saJH0LkrfcT8wCVTWmF3IEZObgFnu6mkFjG1ViPmUV99as5yCPx
         z68YXSWyeFUfNVl6ldhG1iivTFOHZd96hOdTlKBdCj6E6QHxzSJ+Yu/ksD/KOzy5uSzt
         6oqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fhN3EMHUINew41sFoQdsKAmLqqZJau9mu6Q+Il+IlwA=;
        b=oi1hTWLVZOX0YomaASfzGsvVR5fBEMuajKpQATzwu/2dwQ2c1rhBEuZwlnetxbKJF9
         XX+X1yarPgl37720X+uVEFdsfD1S1sxZCof67KDtN2+fsLdiA4fSbdilU/9zMFchOP1d
         IjptTwq1uvchuprwzVkEjW73zEVKqReC4kLCmDkyRmnP8EtTG18kGVcRhtAJUx4wca2g
         DChT1osyBtXSPjMOrdxKyayzU7sxW4CIwVjNBHOI+/ucHBzHDPGNOvqpgfbYReiPokcJ
         da5OTH4u03sVCE8eY7PXG1qm2LqueKjOglwdao11+zrvg5CaJuMCj9RjuIjEJVzD5Ngb
         X44g==
X-Gm-Message-State: AOAM530ICVn1Ng9PPWBOtGBx7sdUtLaTkZE1jVYoKqBcq6rK3vATZRdG
        Mb/UD6yQzBP48SwcPjlZl50EtEykIurEIQ==
X-Google-Smtp-Source: ABdhPJyGQMzJmIDILggC+NIiuijfgiRzAqe3vX+OFErqr5bOfqgOfuLt387DZBreaUbrwbSaWHUpCw==
X-Received: by 2002:a17:906:5501:: with SMTP id r1mr9023000ejp.212.1638447717356;
        Thu, 02 Dec 2021 04:21:57 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:21:56 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 03/23] trace-cmd library: New APIs to get and set version of output handler
Date:   Thu,  2 Dec 2021 14:21:32 +0200
Message-Id: <20211202122152.43275-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
index 9ed29e10..ed25d879 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -280,6 +280,7 @@ int tracecmd_output_set_msg(struct tracecmd_output *handle,
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tracing_dir);
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle);
+int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version);
 int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list);
 
@@ -313,6 +314,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
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
2.33.1

