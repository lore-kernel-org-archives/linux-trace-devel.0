Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E3CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F76461052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhG2FKs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:48 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59E2C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y7so4162475eda.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qk8+Go0Ovg7RA90EQ0E+q9ajl2qchmgE4K3YKj1ocOg=;
        b=JEz3PCh5NmRuT7q9jHgvnBF0GH6ibp0XTMG4WpBQI0tzEAz9ySCBlryOd3x6JZsEgi
         BPE7ULZ1OB51HZqlQ5XBGsgdweYV0gpa3lFg1vDG0gHmgiK3qtKM2qAOecl+Y5xvcy9t
         ILoMnjCF/WgAasAwPmtGJo+QgDnZK0kIpDLyATSk2DsVFnm6oJ1G7Z4I252qhWnH8fdR
         Jh+iiZyLDLtrYbmTNdyoHDuIfOS5AG/N3f+UYdLMlYBuVeokxHRgqtV6A+I/09DKiSce
         mxX/tIOBzpOj7LfAdeXGw7q/98EbvFLWl+5Jvb2/tZ8/th3OyJRuuMWjL5tQ8kCJZerI
         33Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qk8+Go0Ovg7RA90EQ0E+q9ajl2qchmgE4K3YKj1ocOg=;
        b=DFG2ccAd6Ab88c8k8GZ943B6hJKZAHDOdxrae12WpAheGLvdRdNbgjPHR2fECAlfjQ
         iD0r3gTUmL8Wnp1h4eoBKFDmv1o9+Ha18V65Pyr/55ZUL/KRBEX0ED8pykfBHqfEXwto
         rIm402JqxQYtrQKp1fSoIA9/kGz97b5pTTCf+Qt2mVYm6Eu/ej8KrXS8DVigepq7b4bV
         nQYG/sBHNNlkaeJfEr6L0OmBEHYHgCZmBDQsaorGgWlDTgB9XjuNhQREujMuYRy0SUwi
         nO2hwY79+d/5/FE8zg4ZkJdhsmsGU7y0k6Tnrhc4Tt2W7Ys3GZt1mxkwrc1Q49TlvI4G
         O6cQ==
X-Gm-Message-State: AOAM533R1dm9UoUsGQ2Yz1tHH9ond3lXAYdM2HIr/rcU+mAeLZw4XYrX
        Inq9sfs0lHT0gqvZt4Hl8r8=
X-Google-Smtp-Source: ABdhPJzzyWc8W7lS/NIoLiA8H/TWoB+4pJVG+ci3iVyITgq3VqQvQAVC1b+ii7D30+2N3LxDMGQglg==
X-Received: by 2002:a05:6402:1118:: with SMTP id u24mr3925861edv.229.1627535443613;
        Wed, 28 Jul 2021 22:10:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 43/87] trace-cmd library: Track maximum CPUs count in input handler
Date:   Thu, 29 Jul 2021 08:09:15 +0300
Message-Id: <20210729050959.12263-44-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, only CPUs with trace data are stored in the
file. Each instance may have its own CPU count, depending on collected
traces. As the main input handler is used by the top trace instance, the
CPU count there is for the top trace instance and may differ with cpu
counts of the other instances. Added a new "max_cpu" member of the input
handler, that tracks the maximum CPU count of all instances, recorded in
the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 4324259a..41f95874 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -133,6 +133,7 @@ struct tracecmd_input {
 	int			long_size;
 	int			page_size;
 	int			page_map_size;
+	int			max_cpu;
 	int			cpus;
 	int			ref;
 	int			nr_buffers;	/* buffer instances */
@@ -952,6 +953,7 @@ static int read_cpus(struct tracecmd_input *handle)
 		return -1;
 
 	handle->cpus = cpus;
+	handle->max_cpu = cpus;
 	tep_set_cpus(handle->pevent, handle->cpus);
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 
@@ -2907,6 +2909,8 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_CPUCOUNT:
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
+			handle->max_cpu = handle->cpus;
+			tep_set_cpus(handle->pevent, handle->cpus);
 			break;
 		case TRACECMD_OPTION_PROCMAPS:
 			if (buf[size-1] == '\0')
@@ -4215,7 +4219,7 @@ int tracecmd_page_size(struct tracecmd_input *handle)
  */
 int tracecmd_cpus(struct tracecmd_input *handle)
 {
-	return handle->cpus;
+	return handle->max_cpu;
 }
 
 /**
-- 
2.31.1

