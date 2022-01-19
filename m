Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916D9C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351532AbiASI2w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiASI2v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:28:51 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA30EC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:50 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id p12so7537838edq.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mjbgMHiA1cxPYev5O1YzrcPtrxBPz/yyR/eXbJYVM0g=;
        b=mifnsNAomrlNM+muVrCLPPInO3ngxRpXOYpywBEkGDTMkhEUkJblGkLwcfJHXh7COw
         huKp0xUEtiX2uPcWeW4ZErz/vilvooUQCqCW8kqGSlEqPvazcZ1maJd02JWcdmeXr2xo
         OJnaOJFhp4vdILR+XRfk2VNNL5Ednqw9vzx7Ha1az6yEqR/Lg81mqXNBkcTzPbNYs98V
         5rqqGJRapZAMc9PNwAU36AyVv1qCd/IlWnLT5v6sGcPFNglQ6vLvc2afKY7X7t/qrDCa
         nRNIqJJMn3VHzEfeCzWI49EZBXj0xPknIFPewzQtlLJHenj0xMKb/xqLbVH9B1k7fQ9/
         lYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mjbgMHiA1cxPYev5O1YzrcPtrxBPz/yyR/eXbJYVM0g=;
        b=q27SzHVrFSUMDXcRU2UGSng8usmsj085w3ZocMvGQR5yvFiFH6qTzJ+ZM9c3SU3d83
         11V5BDjJWmAO+0sfwBsV3ThuQ/DFy1KZYVTmdSeo8Q5xDL2hZLIjHP08Mqe9uDxioHEI
         lPbnKBqlYG+UoXMr06iBwuyEcMOP8siXyWJ0hdbfV0698W/vDdP7Bm9PoDYTEsW6s64Z
         d6d9meHiWVXXQULwGOwn3tDIxpcVXpFwPXYh4ArXGSh5Zt73HmkHAqqfL7BTU6rAqhJp
         UGt3VN3OduRpYBkefmnH7ap2olZ2/7hN3JwkACoi4n4Xs5YRHi9g67SkL6xeN14GxxGH
         i9Ug==
X-Gm-Message-State: AOAM531kAICpuBwnuuDky1dKqbhQA4QqAJQddV+qd9vx9fVwjcD72Uuc
        2dIxbjivHSdEDeRMEYclAAtKylt8HH8=
X-Google-Smtp-Source: ABdhPJxarGaofPqMG92WzYbkak1QEd1HtteH01G7a8jfp6oVBQ8VQXrupKn3cw9Fmb8Ir6l6Qth6SA==
X-Received: by 2002:a17:907:3f93:: with SMTP id hr19mr1083255ejc.57.1642580929587;
        Wed, 19 Jan 2022 00:28:49 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t14sm860838edq.24.2022.01.19.00.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:28:49 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 3/9] trace-cmd library: Copy CPU count between trace files
Date:   Wed, 19 Jan 2022 10:28:39 +0200
Message-Id: <20220119082845.245993-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082845.245993-1-tz.stoyanov@gmail.com>
References: <20220119082845.245993-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_copy_headers() API should be able to copy CPU count also,
as it is part of the headers.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 27064fce..d35be370 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4820,6 +4820,35 @@ error:
 	return -1;
 }
 
+static int copy_cpu_count(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
+{
+	unsigned int cpus;
+
+	if (!check_in_state(in_handle, TRACECMD_FILE_CPU_COUNT) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_CPU_COUNT))
+		return -1;
+
+	if (!HAS_SECTIONS(in_handle)) {
+		if (read4(in_handle, &cpus))
+			return -1;
+	} else {
+		cpus = in_handle->max_cpu;
+	}
+
+	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
+		cpus = tep_read_number(in_handle->pevent, &cpus, 4);
+		if (do_write_check(out_handle, &cpus, 4))
+			return -1;
+	} else {
+		tracecmd_add_option(out_handle, TRACECMD_OPTION_CPUCOUNT, sizeof(int), &cpus);
+	}
+
+	in_handle->file_state = TRACECMD_FILE_CPU_COUNT;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	return 0;
+}
+
 /**
  * tracecmd_copy_headers - Copy headers from a tracecmd_input handle to a file descriptor
  * @in_handle: input handle for the trace.dat file to copy from.
@@ -4918,6 +4947,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			return 0;
 
 		ret = copy_command_lines(in_handle, out_handle);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
+	case TRACECMD_FILE_CPU_COUNT:
+		if (end_state <= in_handle->file_state)
+			return 0;
+
+		ret = copy_cpu_count(in_handle, out_handle);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
 	default:
 		break;
 	}
-- 
2.34.1

