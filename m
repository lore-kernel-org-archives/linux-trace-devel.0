Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A62BC2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4A422072F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmDcEh1s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgDIN2y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:54 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42494 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgDIN2y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:54 -0400
Received: by mail-lj1-f195.google.com with SMTP id q19so11402769ljp.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P5zIt2o5bsqrwBStNHt6WbiT//vKo/fn+Rl7EAUsap4=;
        b=SmDcEh1sAQiqkmm6dejHI4Dbc+09B7et7lvE6W5y5e48mL7Z3j9CtsOWSXPpY1uJkw
         Rha61TPQv3R5l1428+5C/V0kTpQvU+qsa72lRADwRFwBDRNyrs8amwCQKZwnL38jrOxx
         O1qZU1ugihcdYsInUKP7PyrflrTQ2sXXycz6yyupaAvIvQ/ANoBNpdc/PLGVnUM62kyq
         BHqqwv+ucS2LNqEyTR/npbI6DTptTFdCRTXtCtYWDN0a3p47fy3BjnWpyp4UYf3PgZRQ
         Zy3mhdplYUMrKHgms3z5zlaEntvCpaRqUQugo6v/dJifFXM9DszAc5nZZsc4w/CipvPm
         wa6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P5zIt2o5bsqrwBStNHt6WbiT//vKo/fn+Rl7EAUsap4=;
        b=hpB1RWLuK/i77Pb8C3vjCMRBNkpcWmNx+EYuvIeyjnGVDTs8iGUy9+xTcVORnEh87W
         QW0w1SGZ7Uq0wynM2U0ZbSMzv1LA42FwcbYa8d3PdINbY1982clhbqSM10FnlRvGgkJX
         PVjRCqOis9qWWNJ1Xv9UEk+nljHz/+0kAYRTO6BXJDJNEi5W3HBBBLJccQOEIQg9sI+6
         iqOZCA5XX0GbZnJBjTC6twcRF/iFzhPOwrX37Z4VtpC6A+GvSBoIOjlk9Az8O48rIbQ9
         wUtXPdPTBqkbNk5AIJg1HNctnvKlXJ2pCcXb0t802aMtQMydvBxo1Zz3n/GsO9a8xikH
         BeeA==
X-Gm-Message-State: AGi0Puba029NKABk/DsTVR+Krs8/pTjZhjyMpIGvNcfE572YuRZs9BNK
        qjhf3ZCATp18jd92ETTCc1CXO+se9hY=
X-Google-Smtp-Source: APiQypK71hpVj6akyiunalp1oC3ROfvljXJCIchuKnaBifT4k3+7i+JqtX1+jofiWoIDRWT1zDcBDA==
X-Received: by 2002:a2e:9c9:: with SMTP id 192mr7622242ljj.77.1586438932502;
        Thu, 09 Apr 2020 06:28:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w16sm3716849lfk.49.2020.04.09.06.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/3] trace-cmd: Add a define to enable per CPU timestamps synchronization
Date:   Thu,  9 Apr 2020 16:28:46 +0300
Message-Id: <20200409132847.79592-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409132847.79592-1-tz.stoyanov@gmail.com>
References: <20200409132847.79592-1-tz.stoyanov@gmail.com>
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

