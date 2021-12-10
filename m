Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B57C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhLJLGb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240191AbhLJLGb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:06:31 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5579FC0617A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:02:56 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y13so28309127edd.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8NPhI0F1vIY4v7WdkFRXq3mpA7Z27n3ltd/KtU3XOBo=;
        b=e1mL77W25FR/tTbWFGyukPsPDQ4omYufJjS13jYfo9hu8yXGLWVy+R5v1XtVTVgPAP
         /nJ1sSo4PIpJF5zsTukSHRVbkYoRitnozOxlUw93U6jq3zCvrzEysGF7tp2su5ra4oQr
         hyaj9gHzlGgjsp4CjJDqMQHgQrky697FbpGYJnfPWSy34dAkZglfmrUkKfLPQjqebdU7
         t/ZhhHgF9ewlOqWiPBhPe3ZAl4ISBvjgomBnn7oCX+RRQt/q8Fj04k5CHP4Tj1Xa6ppe
         LJ/etDTjvFjqt6Lsrevw11QiRhYxpsbZngH13vL9IJZH8xutj1v6IgDq4L6Agw1qRorU
         mldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8NPhI0F1vIY4v7WdkFRXq3mpA7Z27n3ltd/KtU3XOBo=;
        b=zoOizHSIXgQJcLdPMeGlajumczQ9gZnTbCq+sz+er20L+nuMpsUdHt5HHkZf4vnsZ1
         L0CJqdRoQPo1DZROY15SMIyeoFEhL5diNVjAbAAR0Bj5RT0wZ484anqCrDMqqN7GFHK/
         XbYps03HEIBQJJ8xR94XoJ3TOj26LBYF8FGwHwOFftx0xKI9z4bmuUda+/wEL5bxQLqY
         IcrQBBfzYxpkasTKZ3HXV+99TC3IKBdWqlwqiDHtewsYEIe60twquQuyJS9C/ds/ddmX
         vFwzBfmzxCSKjp0m23HRoskI6eHAtGJnX4iNEiNZvgtoD4Mty6ksnQ3vI7nhQtrriufc
         rp8A==
X-Gm-Message-State: AOAM530GHb24BQQLCh4ybxq3cOVgeyGP/M5r/SqoAKkL9sDg7RuZQDUO
        E8//2GVV4uCzg5bzztFtfOY=
X-Google-Smtp-Source: ABdhPJylwGzDCZAfT3l2vf6TOePwqkdSdnq1NuWFOEVFNfFms2STF4PkhY6cNJNzRNnylHTgxM5WKw==
X-Received: by 2002:aa7:ca4f:: with SMTP id j15mr36540346edt.178.1639134173701;
        Fri, 10 Dec 2021 03:02:53 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg39sm1275269ejc.66.2021.12.10.03.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:02:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 3/9] trace-cmd library: Copy CPU count between trace files
Date:   Fri, 10 Dec 2021 13:02:43 +0200
Message-Id: <20211210110249.98583-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110249.98583-1-tz.stoyanov@gmail.com>
References: <20211210110249.98583-1-tz.stoyanov@gmail.com>
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
index d441ad2c..4d9535b7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4809,6 +4809,35 @@ error:
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
@@ -4907,6 +4936,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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
2.33.1

