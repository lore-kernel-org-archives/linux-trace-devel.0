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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00402C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD0E623356
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbhAUHrD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbhAUHq5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:46:57 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40046C061794
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:08 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a1so734370wrq.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hMq9nQeSzosYGpQsRepfvrukWUuTkBSj01DDphxOECY=;
        b=P+yPSzNPSe8vfW1hewRX6rosD7pY9Aal6tMgRLNl7Rthn4Y5rheS0hE40C6M0jeK/e
         75Y41Fk5HBeHQf5QZ5klcFkXZJuMTL3Bj3yAAjrvslEtUG/SM4JhBYk3MXtJIeA4CyjR
         9NnnWfjq2CwR0AWD0BnCfL85apGLz16Q02KivsvbP4LgVKKg1EXikvLr9IdUpX8JuL+T
         kZUWGO2SN1lBxZoq21dK8hWwewOmuJkpjYjwrlZLl08flyaB8YejSuAMG7avVy+/MO1Q
         uQyWZJDAZW185Mq27MyBGOKcvbqi8zj3xcPfeIDkd2MpSMoPrpSaSYDnKUd9/d5h0rJ4
         IROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hMq9nQeSzosYGpQsRepfvrukWUuTkBSj01DDphxOECY=;
        b=bh4h1OH1zHgj3GxcfvlnbLIbQoSyBP88lddDqRz5P6+eL3bTRvhMbEtlYKZYuHvDzi
         xH6G0rux/Q7CiRMTolV4gVdM9VRAWPJnJs2Z8JXyZu12lday96sY0p1ElPqned8Us6Fg
         hq/r8SwdUquilTcOTM1GKiHrsw52fKa8jYHhbVu46Qb6A2+QwQtejvFeGJxuEYoqOy4H
         hdf5qIlXds+avbCUm3GE1TsPZhyUCfwbGOZ5UyrkCwvDTFsCrSDXiQ4+c61RUwtTL6vf
         U7rbTl/blrTi8i0E7SWsQiRiZnDqC5DyLTIZHod6roInyNFMBMIfNMmkPFYC7ZbxRCBO
         1Zqg==
X-Gm-Message-State: AOAM5338jwuX7niEelAimAkesotIDAXYcH861tCE6BM667qroy5S7iFq
        nqGczo829XaD0jvmTYacRL4=
X-Google-Smtp-Source: ABdhPJxA6i+k5dRNKZ8+gxFUjp0ec/ZuwENecQQrzzBbrsvOTPQl3LsVa5o3Etw2s6DwDcP7BLBgoA==
X-Received: by 2002:a5d:44c6:: with SMTP id z6mr12790266wrr.306.1611215107026;
        Wed, 20 Jan 2021 23:45:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 07/15] trace-cmd: Add guest CPU count PID in tracecmd_time_sync struct
Date:   Thu, 21 Jan 2021 09:44:48 +0200
Message-Id: <20210121074456.157658-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_time_sync struct holds the timestamp synchronization
context, used by the timestamp synchronization plugins. Guest CPU count and
PID of the host task, running the guest, is important information which
may be needed by the plugins.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 tracecmd/trace-tsync.c                            | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 685abf13..ce7d87be 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -432,6 +432,8 @@ struct tracecmd_time_sync {
 	char				*clock_str;
 	struct tracecmd_msg_handle	*msg_handle;
 	void				*context;
+	int				guest_pid;
+	int				vcpu_count;
 };
 
 void tracecmd_tsync_init(void);
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index ef20651b..3d67f5af 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -77,6 +77,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	cpu_set_t *pin_mask = NULL;
+	struct trace_guest *guest;
 	pthread_attr_t attrib;
 	size_t mask_size = 0;
 	int ret;
@@ -84,7 +85,11 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 
 	if (!instance->tsync.proto_name)
 		return -1;
-
+	guest = get_guest_by_cid(instance->cid);
+	if (guest == NULL)
+		return -1;
+	instance->tsync.guest_pid = guest->pid;
+	instance->tsync.vcpu_count = guest->cpu_max;
 	fd = trace_open_vsock(instance->cid, tsync_port);
 	if (fd < 0) {
 		ret = -1;
-- 
2.29.2

