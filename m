Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C698C2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3007E24655
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uEuu2PGw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgKQHqI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKQHqG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 02:46:06 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35278C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:04 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id j7so22131247wrp.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oMosMhE87bIpLkn48IzM3WB7EtZLgtcP35DD/3E2Vsc=;
        b=uEuu2PGweEVm6IEWrgUC6yl5DweTPGMNN7Mb74dadRuv/rxqUInJYpveWlliFN23Kk
         fLqrdL6eYEPJZvcyaqQZCKc1ApmUIRzXufBYIWzLJkfafrB1FzW1Lxpa4/smibmsOkyG
         ZGxJzkjVRnsRgpchOaOi8Yxf5QCLHjqmykE+W2TX34wfqIGZLesQv2kApA8SupeVdh25
         jN63zlI19PBYByEVTTLYxTGIndcPnb8W2cTtB3dnrTiUMe4qc+Vl/f8WpzQxX22yf7KG
         mHqlkQWGUZm32xodQLJRFXYRHoVAXRpHJfZqLyesfwtxcHs8Glt0tsBFsgJ89OrV3lU6
         ElNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oMosMhE87bIpLkn48IzM3WB7EtZLgtcP35DD/3E2Vsc=;
        b=Bbe/+/1rnkXBHfXaffTFgtZ700VOz+HLLcexH+YcPjYFgK3/i1C4LjB8GQUecbRulX
         MTieTqE8xTSBfqnDzviuo1N3f86tmhKa6p7ET2H+dhEOu2Xd70wkiUD2HR6dxqHGckdS
         fN7JRjlasayLRnmLLENtiJDwCSZ2f8ik4oFi1IM1KGSv6JlVlBcsiCqOSoe9+84SExxm
         PQ5FQM3oxuxzBq00OsLzdw8/vaVm5ssOrlLE8b5dwLTnVLNcbZeBJAib/FEnWc+G6CVH
         pBEmx2+mialzvEV/7rXhvDXOwfRKhjSWAj9PxF+Zov6CaFJIsFAcMlimW3rWmWZA/IFb
         dyrw==
X-Gm-Message-State: AOAM530YLzdOs5ee62zR4cAJ5eJ5qial6y5qA5wyQv3x+TVjzbteHghj
        y3efvuxPw7I1+v3fF0bPRvs=
X-Google-Smtp-Source: ABdhPJzBuILNdYtwf9TIQZyN6zmOXcq1R1Ck6Ec2I3hfkCbsSGTEBbOpAneX8t5nd76J3u0ZMNw4wA==
X-Received: by 2002:adf:a315:: with SMTP id c21mr23232221wrb.272.1605599163008;
        Mon, 16 Nov 2020 23:46:03 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d3sm25752046wre.91.2020.11.16.23.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:46:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/8] libtracefs: Use tracefs_list_free() API
Date:   Tue, 17 Nov 2020 09:45:52 +0200
Message-Id: <20201117074557.180602-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117074557.180602-1-tz.stoyanov@gmail.com>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Use the tracefs_list_free() for cleaning lists of events and systems,
returned by tracefs_system_events() and tracefs_event_systems() APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/tracefs/tracefs-events.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index 8e825f50..6b796382 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -481,11 +481,7 @@ next_event:
 			failure = ret;
 	}
 
-	if (events) {
-		for (i = 0; events[i]; i++)
-			free(events[i]);
-		free(events);
-	}
+	tracefs_list_free(events);
 	return failure;
 }
 
@@ -564,11 +560,7 @@ static int fill_local_events_system(const char *tracing_dir,
 	/* always succeed because parsing failures are not critical */
 	ret = 0;
 out:
-	if (systems) {
-		for (i = 0; systems[i]; i++)
-			free(systems[i]);
-		free(systems);
-	}
+	tracefs_list_free(systems);
 	return ret;
 }
 
-- 
2.28.0

