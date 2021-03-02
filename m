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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9428EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B5BE64F16
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhCBX7B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574564AbhCBKRh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 05:17:37 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95290C061788
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Mar 2021 02:16:56 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id w1so34193155ejf.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Mar 2021 02:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C7mp7XdDB/nO4nMuvkuJk9MQRoIREPJegOBcCLV/44s=;
        b=oPvSewqOYxG64OKOIfo2QWUFo3H6ila8h15CkRG0vZQUuk9iqsSWVKXl8trYusLQOm
         8litKhnJKAW1r6BH5PXUtZ74MP+dI+9sGnMxQlC9yxV7WGwnEpGN986rf4KV88MVc/co
         fmNqvJ4bqQCfMlCUB2+W97zZkZ1t1Rm7C9HlOQgx1TTjfvJ+qAVUNVUNrgCEIjEvSVtC
         VLsWc9T/gRV0Jm/CRJyovC6J+nff7hJfa8rFfY2nZyABpShELGXAxldvmQceTwLqE/L7
         EEEoH9R0yb4bblkS98xPn9AZ9MbCP/V341wg87BY703+NYb+0wpW6CN42ccH5qHWneHD
         8GwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C7mp7XdDB/nO4nMuvkuJk9MQRoIREPJegOBcCLV/44s=;
        b=UsjdD635bJ7QVO/VIHQAxcj0xd1qpFSBnzRV9pjg/Ppld2j6JJcSQemHaKh0y2STcs
         5wh45a8+4WIUD5rYEJcDz3w7oHRJrFnJFV0GoqpcdwzVhmCQraJzvLRPAGXDqdWUKl5P
         3iGRoJGy2IR01vU0Usup384CId5f0xjMAak2edGFYKF9Yd6L0JHvVo1DMODtvbMQnygS
         f5C42O+xtpRJEOdm3G1nocK9XqYSnVolpGjoesUyhm0D5JPCneKG1yGVqUVrFnsSLEDV
         EMH0jXIRWCmX5OKic/Bf8kzt5sf2EEy4rAp6wcPEZp8+fxxFI9i4goO83DtCCdamgxQP
         wuYA==
X-Gm-Message-State: AOAM530aRUDtGjsdiXE2boIRVNTnPIj5ILvkddOQ1nsxbI+hQ2BJNSG9
        MizAX1A1jkDeI1S3csCagcLWkKrDd/SNJg==
X-Google-Smtp-Source: ABdhPJw7CqewL8/iNnlLQMdPgLyQ4apiQeulF2BWKxhA8C8xS2Hakowke9szVJhCB8s8P00HaPne2g==
X-Received: by 2002:a17:906:f912:: with SMTP id lc18mr18811560ejb.159.1614680215310;
        Tue, 02 Mar 2021 02:16:55 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j24sm4502359eja.61.2021.03.02.02.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 02:16:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fix trace-cmd split command
Date:   Tue,  2 Mar 2021 12:16:53 +0200
Message-Id: <20210302101653.377770-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd split command seems to be broken with the changes moving
the writing of saved_cmdlines after the trace session.
The call to tracecmd_write_cmdlines() is no more needed in this command
context, the cmdlines should be copied from input to output files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
This patch depends on "trace-cmd: Fixes for trace-cmd restore" patch set.

 tracecmd/trace-split.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 7c9863d4..8366d128 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -384,10 +384,6 @@ static double parse_file(struct tracecmd_input *handle,
 	for (cpu = 0; cpu < cpus; cpu ++)
 		cpu_list[cpu] = cpu_data[cpu].file;
 
-	/* TODO: Fix me, this is suppose to come from handle */
-	if (tracecmd_write_cmdlines(ohandle))
-		die("Writing cmdlines");
-
 	tracecmd_append_cpu_data(ohandle, cpus, cpu_list);
 
 	current = end;
-- 
2.29.2

