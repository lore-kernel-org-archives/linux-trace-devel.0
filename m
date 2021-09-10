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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D00C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EED0611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhIJNtW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbhIJNtO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:14 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275D3C061760
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:03 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id x11so4460485ejv.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=krH9xYLpRPhC8RR/kAleVk3wlmz8bMAal1E10nfW/0SvPOlsg0uPC/F23A+4HDhLZN
         roF6d8ElD5tq4Sd2ln7jnHX3+glXK0kVMq/0qWlzviDLk/vz6E3hQg8MMcOLPkFJ2cDm
         m+km52yXrl6pMeuNhj1UCW5QMp2vwzDzMovzWJ7EvW2K0Ml68US955QsegkaAGCqryqi
         6GDKMBcqSq39hLybedfqWYCqCU8RF+vgeJ4LxQCpTlovZFc7ZbWdJ+nsSod8Rk5dllNL
         V3OjVtE3VUza3Ejx1//FPT0rBbGJ6JUGPeYDIWjMCGZulEadD3bVvzGvFOhjVaMwcYt5
         b2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rHEDizwZjviRdumQYx/LHW1ieeaoKb8L1up3BfvtlPc=;
        b=zzAX1TIwA1WWl/+uIfuWUDJjmfnAckC6fDS2cvpY+hF2N2mZumUh6Ky3uczK/X16CR
         aLANraz+vaX9bC8cFL+vkyqPQ3mkT4Fym7mh4CEIUoU3t1B0PjdE34kEV511C2xC2sPp
         gpw3JvI2VKGa77j6w671J8OfQwMKPA1yFhopPynl126yvvrdMh87TDTseYcK82nu5dU2
         x9QLaa/UWjqnGw7BVSRDKBvftDiqt71oKWoAC8d0X/8/Dc0XMHhM/LYEq+tTZHUXMCu7
         PufPkAA7yhE8T+nI8ST/6muE3dqYBw/tX9Lm6lJy5i2tgeSDMXWhqLne/HNtf0o3Rpu0
         R0bQ==
X-Gm-Message-State: AOAM530n0bCRKy4iWi2Z2dr34nflx6vGhZM9bsFhcJU0btWJ6omiHNZf
        TmNvv7yhQbiklPzITnucNOgqnLakOQ0=
X-Google-Smtp-Source: ABdhPJylGZMRI8wmo4liTwZPlOnrM4sfJAee0PMAeWDGaSz53LMgU+ZDeHMwgiPXxPnlIBmQ/2l6tQ==
X-Received: by 2002:a17:906:3f95:: with SMTP id b21mr9170306ejj.368.1631281681799;
        Fri, 10 Sep 2021 06:48:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/21] trace-cmd report: Fix typos in error messages
Date:   Fri, 10 Sep 2021 16:47:38 +0300
Message-Id: <20210910134757.2863982-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
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

