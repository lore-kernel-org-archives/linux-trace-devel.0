Return-Path: <SRS0=JQUT=5S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2ECC2BA16
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 10:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F31620658
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 10:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JYZIxEPH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbgDBK6m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 06:58:42 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41758 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgDBK6m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 06:58:42 -0400
Received: by mail-lf1-f68.google.com with SMTP id z23so2322538lfh.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Apr 2020 03:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P5zIt2o5bsqrwBStNHt6WbiT//vKo/fn+Rl7EAUsap4=;
        b=JYZIxEPHI7FHYXRaCpgIBFrvVZqzWinadL1CcqsRRs2ovY5rVN9OPJSmkUSJ+zMKpi
         x6CQVmL4/lQetvjgWetP16UmkP+VnBGuwM/K9lkPRJN1oDBIgBVgXJF3q0v3iNLKvT3o
         lu/kBoSSKPUzcN9eV4S9u9WKz+WAelxmoV1N2EeQeA2C6TRIe/yOVwfMOC7nooCXcKfT
         wXOexZBKO0RwB2qttlFye5eZUIRnxOumeEdWdcZEC6F39YEAyy8fvigYIpGKTNmZ2I8+
         4Ad5nDp01GUes8W0umrC6+4RjSxk1EQx6sku+xbe0IPlQogh1qcTyob3jldJ2tAvObmS
         p9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P5zIt2o5bsqrwBStNHt6WbiT//vKo/fn+Rl7EAUsap4=;
        b=oAOBmHqxx/BXt6P9mOycqr/62m/c7TXWC8ZL4PP/fQiqvV3GiQmfdN8RM/1qnn8MOi
         WI+G7tddD83tViJUmVEiQgEil5sxqPUgpt1ayUpf8ZiZlGlT07mGASKc1IBKR+65/O8F
         a30J95PWBHWOiGGIWPQ3s6UWKi9s6zLp5l2fTziRv4phMRKLuwI/AdKMG09rXHTziibZ
         6Hmnp6Q3y/Zqx/tZGEjZx4nqUPav3z0uZyNqstxe3HYVrOTQStJP/W8AbZgtx0pok+xe
         sBwQGugw6sOaiuBlmlf8iMoepdyT2AGHp5KQ8yQk/sG8zvqSR72wv1Jvd5Pab0ihD8JS
         lOxg==
X-Gm-Message-State: AGi0PuabTGNWOpi7+uFYYPDIHI2dd2MGWLNhlIkkm/+GE3SI5TsQDqXr
        Y4955tdxVSPw3vMpifRoO78=
X-Google-Smtp-Source: APiQypL//P6Fisbb/BE/9P7ojdirdj+eq+kYxukui5HY2bQZki+AkPJ5JJCI9nRWduYdfqmZwxcyww==
X-Received: by 2002:ac2:5183:: with SMTP id u3mr1844139lfi.26.1585825119663;
        Thu, 02 Apr 2020 03:58:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c2sm3779803lfb.43.2020.04.02.03.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 03:58:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 4/5] trace-cmd: Add a define to enable per CPU timestamps synchronization
Date:   Thu,  2 Apr 2020 13:58:30 +0300
Message-Id: <20200402105831.263753-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402105831.263753-1-tz.stoyanov@gmail.com>
References: <20200402105831.263753-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new define TSYNC_PER_CPU, enabled by default, can be used to enable
the per CPU timestamps synchronization. It is mostly for development purposes,
to compare this new logic to the legacy one, where a single CPU is used.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-tsync.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index d44c3850..8de846e1 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -31,6 +31,7 @@ static void *tsync_host_thread(void *data)
 	pthread_exit(0);
 }
 
+#define TSYNC_PER_CPU
 int tracecmd_host_tsync(struct buffer_instance *instance,
 			 unsigned int tsync_port)
 {
@@ -54,9 +55,11 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 		goto out;
 	}
 
+#ifdef TSYNC_PER_CPU
 	ret = trace_get_guest_cpu_mapping(instance->cid,
 					  &instance->tsync.cpu_max,
 					  &instance->tsync.cpu_pid);
+#endif
 
 	instance->tsync.msg_handle = msg_handle;
 	if (top_instance.clock)
-- 
2.25.1

