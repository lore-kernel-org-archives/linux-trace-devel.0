Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E707CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358132AbhLBMZk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357941AbhLBMZ2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:28 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD452C0613E0
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:05 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so115166501eda.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=usoRzb9mGea09Q0g9f0I3Qcwp99e4ymNAyuEzNRzI6o=;
        b=NskHL746c/AmlDu1GZIEC81tASFkq2uqppBdRtqPpMn22OiSbXR5K+EmdbuDCY5TgU
         pE3B0wAg/wMf1Yscyb0Hau9t9yxa1s9rvWbzBsSZ/SnGo+GMYvS4hAjAVMxjWYFGLlbH
         LCExGtaG1swr+qL7xaoLgj2F/AUAD4pLSDzFAlXFqBFFCacisOR8qeFWP+y/pk9DAyIM
         Wi5lTsinYfqSjXcHtVAEy0ejXzXBVC0F/p4zxzh4qNSPJzwjYMzYD0mmYHui1Pxwsyka
         zHQ6CVnhQ+33cXM4eDRqHynK5mfU/gL9bhrwbI3vWuIP0oqHVQr89mOSy6TsxAdd7FJq
         LeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=usoRzb9mGea09Q0g9f0I3Qcwp99e4ymNAyuEzNRzI6o=;
        b=DpdbXt9L1gmb1ABGSTvFI/pqMsSn4VhYeubKTdi7+xcZtFXxCAuL2Rbd/bRREi9Zaq
         H5D9YCYwUvdU5eHeATWeCaMFCMpfrRORt30ItWWDBkuy2hsGV5BT0HKB4G93qgUVyUoF
         3ABizFgoZR1QtqQK7O4/jPxKjfzxPSpmbcQj9Fj6O9WY36uXtYPDU41iDrcqP4f/NWI8
         VxGrhaIf46MgjUXRs+fLTBajplyz+c7mEYpH12MwoYZ3VrT6EznjYsFPLcii0BcqcYM4
         pa5RtGsX38TtAdeP7KQW/R6n1kYXq3QF8jDOvXlnuHTMupYKajyH4SA+BQl5wR32zHMA
         awqw==
X-Gm-Message-State: AOAM5330oL/IhrA6JwQL7a9DyCE7yuF1wzEs5/59lGU1Xu7HwQzfTu3V
        XheTfUO9OMKlIWL2StnX6SzllDrCEDXRug==
X-Google-Smtp-Source: ABdhPJwQxRUdlg/2bHEaUEKodkP4UF1Kxy2+6ku7wpdNnbPVln8766Exh720kMAcnj3BsFoIIBpoQw==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr17338295edd.2.1638447724395;
        Thu, 02 Dec 2021 04:22:04 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 10/23] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Thu,  2 Dec 2021 14:21:39 +0200
Message-Id: <20211202122152.43275-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 format is based on sections. To fit the latency
trace data in this structure, a new section and option for it is
defined:
  BUFFER_TEXT
It is similar to the BUFFER section which holds the flyrecord binary
data, but has a latency specific design for text data. The BUFFER_TEXT
section has:
 - section header, as all other sections
 - compression of the trace data, optional
 - corresponding trace option, pointing to the section

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 24 ++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index aff838ca..a738a9e6 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -144,6 +144,7 @@ enum {
 	TRACECMD_OPTION_KALLSYMS,
 	TRACECMD_OPTION_PRINTK,
 	TRACECMD_OPTION_CMDLINES,
+	TRACECMD_OPTION_BUFFER_TEXT,
 	TRACECMD_OPTION_MAX,
 };
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index ea36fab3..408828a9 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1798,7 +1798,9 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
+	tsize_t offset;
 	char *path;
 
 	handle = tracecmd_output_create(output_file);
@@ -1815,7 +1817,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffer_info(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -1825,23 +1828,38 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 		goto out_free;
 	}
 
-	if (do_write_check(handle, "latency  ", 10))
+	if (!HAS_SECTIONS(handle) && do_write_check(handle, "latency  ", 10))
 		goto out_free;
 
 	path = get_tracing_file(handle, "trace");
 	if (!path)
 		goto out_free;
 
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	if (HAS_SECTIONS(handle) &&
+	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+		goto out_free;
+
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
+					  "buffer latency", flags, false);
+
 	copy_file(handle, path);
+	if (out_update_section_header(handle, offset))
+		goto out_free;
 
 	put_tracing_file(path);
 
 	handle->file_state = TRACECMD_FILE_CPU_LATENCY;
 
+	if (HAS_SECTIONS(handle))
+		tracecmd_write_options(handle);
+
 	return handle;
 
 out_free:
-	tracecmd_output_close(handle);
+	if (handle)
+		tracecmd_output_close(handle);
+	unlink(output_file);
 	return NULL;
 }
 
-- 
2.33.1

