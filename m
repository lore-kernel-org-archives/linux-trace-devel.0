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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53591C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C2A7610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhINNQM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbhINNQL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:11 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B664C061767
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:53 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id b21-20020a1c8015000000b003049690d882so2039139wmd.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffE30IdThPAC8ILnbemopf/bsn2jueqRCO+D2m9I5Kc=;
        b=J9y9DxfPPh083n+yON9wiTVIJIw7EWmRfskLlFg/AD7SJWMEZuEhKZ13Ef5+EVRVHJ
         yfG+kZiEImfxPFMuPjnGI2bDxGE19q605VC3MMu0H7r5zNNkLAOkvdU1DQJX/MjmmRjE
         /g9x7xSU1V8JdqKLvCacKX/1PTAFcFQCdTvEOc/jvvX6DRk2EXKp0UGDE9JbaUAwB81F
         Ta8tmd75+pncG7bLtMsFuCvnf7fOfEDb6PCJLDEjDLP8Cb9APd+olw3QGO1h0wQ0tNfS
         Vo5io+gB2s5kMR3S6AefRMXFkip4Lt6josrA1Urkq8GEi77uZSmNh1c3mGMpuYFPkBC9
         TahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffE30IdThPAC8ILnbemopf/bsn2jueqRCO+D2m9I5Kc=;
        b=iFREYiT+hoBwvlhszM+PFs30zMo0I80q1a1bpac6FFqFA9YJaCRtO5XbULGXtX01we
         kLuQF7hcqYiD5Zp4sMzYlONBrjbRa0P17Vbomo4ZA2c/5J0gBNn+EdZe/xEKAs4z9DFB
         IrpcHPpbI1tVmLrlI5NAH6b184H71/SlR1MJG4SwUyfBDJjdX9syR1Rh2qmjl659jSbD
         e0jxh8e8d2qntWZI/CNgzvxaeNbUjYRrq9orZVJIGVBBVXnKpTVbJcUEWC4Nh6fflugc
         THrJCoY/1GILX0e4ESCd2J780utr8oqagcizInb6ZxYu7tMYMhj1IT9IFMvSlPG2ndwD
         s4EQ==
X-Gm-Message-State: AOAM530cMyVexmoqUQJvLCnt3uODx2pdQWH1aekCQ9SKJN/M9pcqC4wK
        KR75iNITJyAWB4j75pNMAoeOT1yMnaU=
X-Google-Smtp-Source: ABdhPJyJAMQxdjAga5v3w23Vn1/JkAednEN1hC/TIpER/prcUFZ1GUjXFPmIR9jyMrQYvZquRDmaig==
X-Received: by 2002:a1c:a713:: with SMTP id q19mr2180774wme.42.1631625292230;
        Tue, 14 Sep 2021 06:14:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 11/25] trace-cmd library: Fit CPU latency trace data in the new trace file version 7 format
Date:   Tue, 14 Sep 2021 16:14:24 +0300
Message-Id: <20210914131438.3965484-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  | 26 ++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index d85a4b3b..d8a981af 100644
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
index e0bdf47f..c62fcfca 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1788,7 +1788,9 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
+	enum tracecmd_section_flags flags = 0;
 	struct tracecmd_output *handle;
+	tsize_t offset;
 	char *path;
 	int fd;
 
@@ -1811,7 +1813,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
-
+	if (tracecmd_write_buffer_info(handle) < 0)
+		goto out_free;
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
@@ -1821,23 +1824,40 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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
+	else
+		close(fd);
+	unlink(output_file);
 	return NULL;
 }
 
-- 
2.31.1

