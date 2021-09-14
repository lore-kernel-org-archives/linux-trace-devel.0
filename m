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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2437C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB096610F9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhINNUp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhINNUp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:20:45 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01E4C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:19:27 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d6so20163671wrc.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Z+hJ43+HktIMXGAr2/HiD71a+OJ0wAqyjO0rQHrMxE=;
        b=Lk1MYW1zA4lvmHbwt/Ko37f1lFHRYjnh9E6shJ94pRTQk2nnN7ziPJjSYhGVgrF6Yn
         HaJXOzA0+Dff7YuWQ3aLrYwnAAxFvHSAsqjp16J07SJTze936uAhRtDt08x+zVOD8y5p
         XJtaDMiyLqCOCHD1PSDZu8O6in6CNtnz2XEZdJvzczLv7f7r8Rqzvp5XtdYvZBIzw4U6
         RitqXRJrm7KctCnv1uGEvbDaR+00aBkFNYbg8W/i4MDdM0mfUJ9hX0tvULdsgKSTX++V
         LB8O36vyUR10P+BfOFcl1Uhaafh1SmTXaXqOGL44DZwZO7I+/yG7nahtUXHTzwkTfQ1c
         DW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Z+hJ43+HktIMXGAr2/HiD71a+OJ0wAqyjO0rQHrMxE=;
        b=o/O/gI4BzkzmjFM49q+MHSHRmGKF/nnGzKfP+Z7okuylVe7b5KwSgpH/odbMqnzYDr
         Lo1tT8H/yWXjRXeiYYG7zeahEn5MzPVh+jD+q1wq1iXi6wG33mkre3FVghV924CN/FZc
         hI0xCEd46cWuh38jwBmORsy1X3dFA5a3kZTgaSHaNHu4CpvduMuQ0qEy/scMBcnMlu2V
         J18p1HsUGMZcpYZglF4W6uvB+Ly3jMCAuKEVc/8SHiGlR0L4TzAEx7pf1Q1GCP+ulzVo
         P2X76lz5yLipCE+/4/g11X2OimxoHeVMEZY2bAojK01TryBn12HUD5lb5CU3il1qIpDi
         eojg==
X-Gm-Message-State: AOAM532ZFt52PCWYKgfHhmjW0b5Pk9YwYiC/Oo65b0nstTaDosBXOaMV
        jtLZ2KQJq7rxfPRFWtqEbL30n+25XfY=
X-Google-Smtp-Source: ABdhPJxnlEESM+VHvBfzUHJY2XgZH2wegCmmMxUsmZcpM/gOh9qfyn9862uA5oif/LWCogSAJQe6Zw==
X-Received: by 2002:a5d:4d02:: with SMTP id z2mr13910940wrt.8.1631625566225;
        Tue, 14 Sep 2021 06:19:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f18sm4545302wrw.63.2021.09.14.06.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:19:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/8] trace-cmd library: Copy CPU count between trace files
Date:   Tue, 14 Sep 2021 16:19:16 +0300
Message-Id: <20210914131921.3967421-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131921.3967421-1-tz.stoyanov@gmail.com>
References: <20210914131921.3967421-1-tz.stoyanov@gmail.com>
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
index b241934d..9e3f4bc0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4754,6 +4754,35 @@ error:
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
@@ -4852,6 +4881,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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
2.31.1

