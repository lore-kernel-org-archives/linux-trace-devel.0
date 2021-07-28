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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5EFC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFF1A60EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbhG1NdB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbhG1Nc5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:32:57 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A03C0613CF
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:55 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id nd39so4647510ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=s+mxQcOHtA0obfa5CDFGJmV6UX942cn+2iNJUXBFVaFifroGGpzzw56QewCclCSoae
         GBeatMRJ1LarqiYp0951SVdLJHQd8pfYrYWo2ZJsoeSj9kJ+NbsFn7iV8x+8y6YCAMiW
         3/Y+6vgDrcwtr47+MC0NwoaU8tVk0E5MHap3zEOqmUSNzjDOCbSEN9Zy4ltSORF/pJnF
         FnuTzh9noDKS0AthuaGnha+GbeBkbePCyeIKKltq+/bZjkEKJqa9eFjHIbf8V+IejH+7
         7jxE23p1jXTnyWrjyxQL+kp9bkpHr1Khe6B4fa8RWm/iL77FswMix2SEMPKlbcPRKBNG
         2mcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=jdkC8lTUHoNt2vJD80rjcZXfp9IqtSaJO5HUqyWELumLnWkou0XM1255UnT81LQ0Bj
         QMcWGgF6SW6w+WO464pjY7MtBg5tt/MtPGdo5o/GB7+1yNkTzkwH4G+y1/FBMVr59+0e
         +9PlpnQaWZAmPgygt87hAPoBGsmaqY7UyCoZYruDzhOgQ5VDVI4aYlVfuduFBTVkABjb
         x4lmArhPyU3ZLveHjB9rn/9Xz3LIB02yAeR8bp5NGW0YRZ56TMUqbsqeX9Csw84xnom6
         dvV6/PMRYO7SC6WXkR7du5IuZ1wGZTSchB3MzLh6yCoVq3YOmMbg/l4HSca8z94rSjA7
         Qv4g==
X-Gm-Message-State: AOAM532tsmgKY2EsWF7iis1gUUEGEFPguykqax1nBpkyNUoxdmnsrxjg
        LW2Kvd2WiB7u4KlocI07zNddvaQQy53S+g==
X-Google-Smtp-Source: ABdhPJzJAbO0xfNppGBZ/o1MkBXRxoGdfXz6BCgru6+G7gp1hQ+6CiEd6+KyviVoVQcQBXtAOfW0RA==
X-Received: by 2002:a17:906:4103:: with SMTP id j3mr26770196ejk.526.1627479174187;
        Wed, 28 Jul 2021 06:32:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:32:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/87] trace-cmd report: Fix typos in error messages
Date:   Wed, 28 Jul 2021 16:31:25 +0300
Message-Id: <20210728133250.234140-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed typos in "trace-cmd report" messages that report reading and
parsing errors.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 6f43c1d2..31724b09 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1290,7 +1290,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 					die("error in reading buffer instance");
 				new_handle = tracecmd_buffer_instance_handle(handles->handle, i);
 				if (!new_handle) {
-					warning("could not retreive handle %s", name);
+					warning("could not retrieve handle %s", name);
 					continue;
 				}
 				add_handle(new_handle, name);
@@ -1324,7 +1324,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (last_record) {
 			int cpu = last_record->cpu;
 			if (cpu >= last_handle->cpus)
-				die("cpu %d creater than %d\n", cpu, last_handle->cpus);
+				die("cpu %d greater than %d\n", cpu, last_handle->cpus);
 			if (tscheck &&
 			    last_handle->last_timestamp[cpu] > last_record->ts) {
 				errno = 0;
-- 
2.31.1

