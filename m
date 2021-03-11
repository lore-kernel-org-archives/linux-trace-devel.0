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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F558C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 596F364FA8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhCKItS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbhCKItR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:17 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A055C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:17 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id p8so44502971ejb.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cIjLZ2jxcnzei4wiiNaWxNAYYBrYURdLiNC6d2iRrmM=;
        b=izfFGSaU0DD7l7U4p2PdbtdnGmWrr0ize4Toc+VUTFDT9OzkY4HA40O1mFYQBXWxRN
         vXrW0Qjx4qgJHLApvAMvyD7jdZCNmhuMMQeto4xhMm/KX+wvDb1MRNPxDQS+4wF5FB0C
         6TrbJf2+2tPkNcT81sUUognfZQq2kyAdWWY+n7Xbh7ymsi7bhVAa9SN720+h3DtTqFXJ
         KA6woGlmJVvclmAN/oeQtfaSoBxa2xrOKMOrgWQ3CWR2gEUn9Gn8VFDGy1LNKV+SoxBR
         FBlqVlJftZxq/UwEnMgJqWxuzpvfAdoTiYo0ldAsl1vas8eZVC+JMCqoUUow96TRkTws
         0vLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cIjLZ2jxcnzei4wiiNaWxNAYYBrYURdLiNC6d2iRrmM=;
        b=e4bOZh1OXAG5WReKarYpZVXzin3RFXNfmQGSbzCR1CUsgJmJt3RZGzU2bHRiGIPoVx
         gPVf/Kse8prVFaCHD7lh6ecRELzJS/FZQXLuzpS8STWY0ubEgdmzsIB798rEE/rbwURp
         6w8OoldM350K1opbngSlOD/lLaxtOUX6+HQKLc+wPJkpiP3+NnXxeWD4AMMfLhClrDze
         QyD3N8tuH8qObwb8oOSY1/++dbQkmU1vHRdM88g2BajsLZunKg5TF+xaahgrqY4crCjn
         63nopF5sNBF3TnnLmspGZ28m+oySuu3M833jHzEonh6E33U4+O+5kKSt5l3Ox0qTHoqQ
         FW+Q==
X-Gm-Message-State: AOAM531oKBvbhJNGeExMuxX3/YeWTuZfMGeIraC8LgRMwFoCBhF8c8aY
        5toUos6GsTmIybJL1sDejHf8h9kvKRy4aQ==
X-Google-Smtp-Source: ABdhPJzFCZRc/a9s4eeuehlVnzQ7tfbdM7zOPabkbM71w/38bfosglmShxhP9LytQYVEvAvsGc/kvw==
X-Received: by 2002:a17:906:3849:: with SMTP id w9mr2084518ejc.7.1615452556060;
        Thu, 11 Mar 2021 00:49:16 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 10/16] trace-cmd: Append new options into guest trace file at the end of the tracing session
Date:   Thu, 11 Mar 2021 10:48:51 +0200
Message-Id: <20210311084857.1919805-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Moved the logic for appending new options into guest trace file from
tracecmd_write_guest_time_shift() to host_tsync_complete() context.
The guest time shift may not be the only option to append, the right
place for this logic is when the tracing session is completed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync.c | 1 -
 tracecmd/trace-record.c        | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 7514766a..3a70eedd 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -974,7 +974,6 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 	if (i < tsync->vcpu_count)
 		goto out;
 	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, vcount);
-	tracecmd_append_options(handle);
 #ifdef TSYNC_DEBUG
 	if (count > 1)
 		printf("Got %d timestamp synch samples for guest %s in %lld ns trace\n\r",
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 38428c8d..15521d0d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -681,6 +681,7 @@ static void host_tsync_complete(struct buffer_instance *instance)
 		if (!handle)
 			die("cannot create output handle");
 		tracecmd_write_guest_time_shift(handle, instance->tsync);
+		tracecmd_append_options(handle);
 		tracecmd_output_close(handle);
 	}
 
-- 
2.29.2

