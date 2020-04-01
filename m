Return-Path: <SRS0=9gE1=5R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22904C2D0F0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E430B20787
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/yNLZR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbgDAQpP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 12:45:15 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33129 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389824AbgDAQpO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 12:45:14 -0400
Received: by mail-lj1-f193.google.com with SMTP id f20so209678ljm.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Apr 2020 09:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vTSZ5cNGhhjdzPTT8tYx3juT1xcUrpDXklEUUIb84Us=;
        b=T/yNLZR6BYqWBhngunMIBKy2CG5hGjRHjuLozYfJi3WCYEmjrSuIIh+5BAFt50ddGm
         9ZBL0kpoyPlAYuBKEey5Ua5tS5DvqHImiZ3jATwshL6R/H3SM8YD0KU8VF0qt1BQfvuE
         fAfLuSP6Lk4xZeSKX00pesIO7kkgJbRsktGnu9zBEdiCPpBmCDSLzDFghQqeoR6M6pJ0
         eqJeKXRVwv1N3pKTuJUm5BBgC7g5sgiPr7yPEKBT6dZTKgIb+MZoj/bdJhXK60jYf7r9
         Z1xe66HUPGWK721kzB2wjtFThhbjPERpt/7VUBC2ota4Uxrc5hoii2nmZQVpyRK5seSa
         UnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vTSZ5cNGhhjdzPTT8tYx3juT1xcUrpDXklEUUIb84Us=;
        b=VbJR4rLyIvprKD3J+HOw3QWybkbzRQH2YparwAyj6g35CET3p69XW0fEtnihVRjjxX
         gukh0dNn7W6LfhMtB6MLo9ChQ5PNRdOX8ROyCvZ5R1/inIs5nifeWONRgvG3QE1IEoDl
         PdxV9aLvEU9KT8MPl57pJ5BpquHq3keMQK0uGF11pHdf3yvqoK/VMMCb7TSN8fdLAGo5
         VXamPCnMPe9pW8Yg6YjMmJWYIYnsfFcozKStRzL4isRcvmuG6IpldjV6c0IeAPJz89Qa
         m/j4NL7saDZ7h+2s9dcwgC1Ys0ZccshZOWahg/ktsWhqlK9PUUTiGMXQuQsNknTLEm4K
         slNA==
X-Gm-Message-State: AGi0Pubz6iZIhT/68LpqJFLwI+cU2XmV8lSYEBFdpl6X8xgweEHb9RmJ
        OpVYQ/tnkKN8sIy2klsVGPs5XsYNxz8=
X-Google-Smtp-Source: APiQypL2UbuJ+TFBx/gLXOU7VritkRGhhkhjBRZBIKOUyg8uXKhr1NrlYYc78TgIwL38imJr4t7KaQ==
X-Received: by 2002:a2e:8ed9:: with SMTP id e25mr12558883ljl.219.1585759511277;
        Wed, 01 Apr 2020 09:45:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m7sm2096640lfh.54.2020.04.01.09.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 09:45:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark-2.alpha: Use new tracecmd API to open guest tracing file
Date:   Wed,  1 Apr 2020 19:45:09 +0300
Message-Id: <20200401164509.191494-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

The new tracecmd API tracecmd_open_merge() is used to open guest
tracing file and synchronize it to the host file.
This change is for testing purposes only, to test the new per CPU
timestamps synchronization logic.
It assumes that the stream with id 0 is the host one, and all others are
guest streams.
This change depends on commit:
 "trace-cmd: Add new API to merge two trace files"
where the new tracecmd API is introduced.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/libkshark-tepdata.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 8678e12..b80b945 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1008,8 +1008,17 @@ int kshark_tep_init_input(struct kshark_data_stream *stream,
 	tep_handle = calloc(1, sizeof(*tep_handle));
 	if (!tep_handle)
 		return -EFAULT;
-
-	tep_handle->input = tracecmd_open(file);
+	if (stream->stream_id > 0) {
+		struct kshark_data_stream *primary;
+
+		primary = kshark_get_data_stream(kshark_ctx, 0);
+		if (primary && primary->file)
+			tep_handle->input = tracecmd_open_merge(file,
+								primary->file);
+		else
+			tep_handle->input = tracecmd_open(file);
+	} else
+		tep_handle->input = tracecmd_open(file);
 	if (!tep_handle->input) {
 		free(tep_handle);
 		stream->interface.handle = NULL;
-- 
2.25.1

