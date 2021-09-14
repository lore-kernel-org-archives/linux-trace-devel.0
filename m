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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709A2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CD3E610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhINNQD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhINNQC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:02 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E14C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:45 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id u16so20154279wrn.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+AN1JM8fGNnbIsv8GFGkV3AJpi+3mBF3263o/EanhU=;
        b=ECAUnDPgagsv0KSm18OH5Bf5Gpa1aBPHP5t2PRC/LiH8QmAgv9PoyIGdGvOEoaG1qD
         dYqdUBZ4FYioWT3IaPBh6xosn5kXcjfQghWzGSafacUmap5UClLoQj4PdWe531elVzTt
         jHnZ+s3H7Bg9HTNc/oQZ7K5u4dkVq9H9ZEFvrhHQtw9Aol0rKtp8bo6kfk5sMM44ZHPP
         fMzIz/TIbSViq5eUkk7cwcj6OFynXD5/rlg5ypeKTnwg8LtB2avO787emcIkBwuGAWoa
         +U4skc3dBOKw0Yq4/1Y2EpEacHe432moChonqGQk35cexa/2xS0SgYb+cI5+uNupldRW
         EqEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+AN1JM8fGNnbIsv8GFGkV3AJpi+3mBF3263o/EanhU=;
        b=msdOf+uvasp8mPM14V+u7OAYgZT5Q/5JH62sJ9SBse/Q6TFkSYNCJmwloibRMGH8Pq
         zZzt59tAgHd5r0p2e0ysIYWAqRDKpWilDNJuFngXprkYghvefQ5j4/YQMbwNIfj8U1wG
         UzvKMIluJHKGVlZXfToOT5pR9ivJbCti1VMPb0ygETtOfECPRkOUsu9n3lewPB7PYIru
         hgsUk4/0NftWpZnxjR1AuRXexl7/2mjPwB+Q6BSPhZVcbHS0oo5J93X6jhC3UMsHWHxg
         utVoYYakH/gYKNoh0a+HQFTw14FVvXPfTmlF0bugmiV9VxSlbcKqc6QrR2tSyAObc0J/
         F6vg==
X-Gm-Message-State: AOAM533v9onc1LrrzKW6eovqkkDWUfSAWXXZIzugHqZ203XhzbCpNjhp
        4kRxhcYJzTt5stWwjAzoQELMMPy6SDA=
X-Google-Smtp-Source: ABdhPJyUu0UmDOrsvdOHc6LGPnAnOeDHvnmufRxx5+v3zffDVLNLJ8bPmI+B8v7LQO08kpFbtX/8bA==
X-Received: by 2002:adf:eec3:: with SMTP id a3mr17510611wrp.276.1631625283555;
        Tue, 14 Sep 2021 06:14:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 03/25] trace-cmd library: New APIs to get and set version of output handler
Date:   Tue, 14 Sep 2021 16:14:16 +0300
Message-Id: <20210914131438.3965484-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
index f48e6766..73e05d07 100644
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

