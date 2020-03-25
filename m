Return-Path: <SRS0=JHVT=5K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3E8C54FD0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A54242078A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LeHMVkmt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgCYOIf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Mar 2020 10:08:35 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41688 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbgCYOIf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Mar 2020 10:08:35 -0400
Received: by mail-lf1-f65.google.com with SMTP id z23so1880581lfh.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Mar 2020 07:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SaRLco7nhJ/8U9CxMnyv9fdYM2DGUMOWhs0LicHLMYM=;
        b=LeHMVkmt3jKYBb5yXb/nKKeBQ+8r9I+3d/wmybRRDwZReic+jP07bnLnYQsVa7UiDx
         pJ44kkrbG5B7PMZd0IfP2Ud6OzVYqcGqEVrDjrsz757wQkhBgInVA01cyLMAlFy7v+mP
         xI++/dfz2kSLBqN9zHZZTgBNbpbaAFjfJzixWmPuIr+QMgyOVfIUrjoPottdWHraAfzF
         +6aovcanI8qH3vhXJMplYdm8Fq8jSGqbTC8ve7PGy36TnMQlaESvefOmL63FP4sXsMes
         sr+aYRwgIScx8MBw3Wrb71jTFQCwS4MSG4H+J1jeZorEe0BQ5vUcUcAEyRbkHWNbYyDK
         BZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaRLco7nhJ/8U9CxMnyv9fdYM2DGUMOWhs0LicHLMYM=;
        b=uKReFiWu7q3WIvsYgWS312yl+T3iLsckLiDvG0mQotIdyJH4sUcJT0rLNoeegX1Bs9
         LPVMnIXuibmD2FX3Bp1GrycOwDvRQeu85kds2mmikSHDLLKK2zgXZjyvUuJpXDO+HUfa
         7s9QPTIh5nopTlagYQP0/fr3zc4WKlUoRS50lBb5Z2jN/c4NrYuYKRcm1paWZAy/q9tg
         +GW/8/rJl7UmTMvBOhjVfN0I1Q7jNKVCJZUM6eD9Uh0YhHmyEVvnS7RNlVFOifjnfQoI
         g2gWGTSV4gdoi8Z1b68L8EgWh3U0vtxQutjUtfHiukVV3FXSKAqbN7QPDg5Rwq2W+HXv
         E2CA==
X-Gm-Message-State: ANhLgQ2lGsieIMuthXUBjl1/p2qZOwGt01VWoIttdFHJsgru0bda2M3u
        89J2kKyrLnFwNPPsNU2RyVU=
X-Google-Smtp-Source: ADFU+vuUaPLsIKSs1ARPyLTK4DhAr2eIGtOd9bL/7ZW/RXLb7rJOTY1+NYuBGmDZeTc8E2ST0A7JZw==
X-Received: by 2002:a19:5019:: with SMTP id e25mr2505602lfb.68.1585145313525;
        Wed, 25 Mar 2020 07:08:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v9sm12017301ljv.82.2020.03.25.07.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:08:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd: Fix check for trigger file in create_event()
Date:   Wed, 25 Mar 2020 16:08:27 +0200
Message-Id: <20200325140829.184651-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325140829.184651-1-tz.stoyanov@gmail.com>
References: <20200325140829.184651-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a trigger is configured on an event with trace-cmd "-R"
option there is a check in create_event() if the trigger file
exist, using the stat() call. It returns 0 if the file exists
or -1 in case of an error. The check of the stat()'s return code
is for positive number, which is always false and errors are never
detected.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c8c853f8..ec3bcae9 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2707,7 +2707,7 @@ create_event(struct buffer_instance *instance, char *path, struct event_list *ol
 		if (ret < 0)
 			die("Failed to allocate trigger path for %s", path);
 		ret = stat(p, &st);
-		if (ret > 0)
+		if (ret < 0)
 			die("trigger specified but not supported by this kernel");
 		event->trigger_file = p;
 	}
-- 
2.25.1

