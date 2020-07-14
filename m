Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49890C433E8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21BE820BED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PLm6FLOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgGNKak (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgGNKak (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 06:30:40 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F53C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:40 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a1so20936101ejg.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JSoPXyxrIm+tixdsELABAE9/MeyBx9pK9pMJ0E0cn0c=;
        b=PLm6FLOWpimnkIah3cGmmCLQ8wwLM4Ra8o55UG613cCvijai5iM4Fc5u1Lly5MjUgU
         sCbEPnm8vWV8SfsV/JNwUU4QTCbDUj07lzJZ0wuXTIi/pnTaPpQ9pZTxTyLcDmyluChE
         tjUTJDvJZykc5nDGy/8U8ddSC8I1gOt4BJcliErxfuT2GXD/BerQOBWutg99cxU0rSMw
         B2pflsfD/Q1q83xEaTSdmWVvqMXG9M/4yxuQg6tTJBSLYRGjUHFomnEpuWpleoPdipvv
         xnGidbBYyDwG5xED6nwxqRJ4r/ACka5vpAODbceuxqGxdfsBmMV1gWj1Prw1b6y4JMBs
         Ki7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JSoPXyxrIm+tixdsELABAE9/MeyBx9pK9pMJ0E0cn0c=;
        b=EGvS45J4V1CT4+3E/AZG81uav9D/Kp4weEraBcI362UEzC/H6Fm/Zm7u24qV6XI0Jc
         YPiM7kdmzwRKyxjTB2doFh9WgbtQipI32lz0ka244Zi8c2xPW01JFK8RKMOu05r+8199
         H+AmCGNF9ocdcczlMhZcKwjnf+9uVdbpVHBTkMP2eF3iHc2kz0hAXFMXe+Zk96xB3q9w
         AycTN5hqS3fhgWsoXFpnuOZvliWhyJLuIxXNqhgUqHjFcnK+Gwm0kTmE3ao1aEjtJTOU
         fAq+Eauo3/myNxf+cumnNA1dsI1aMg/ZhpLA8zfghP2QJU/dIyssfWK50WmV0hH/fXRN
         beDg==
X-Gm-Message-State: AOAM531ROADvlPzOnQZIkMe3cik8d0+C5VvFU6TJMIz3XS/eNrbeEHJ5
        mu/tG8YUsE4LLD3MGqoi0/M=
X-Google-Smtp-Source: ABdhPJzSZUKhMAqdnQ1nd1O21m13T3WREK1x9Mj5JzJbnjzQbEv6drPR0z5V93a0HKwiDeI7MfF6fQ==
X-Received: by 2002:a17:906:ce3c:: with SMTP id sd28mr3749861ejb.382.1594722638777;
        Tue, 14 Jul 2020 03:30:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gr15sm11766034ejb.84.2020.07.14.03.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 03:30:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 7/8] trace-cmd: Fixed description of tep_add_plugin_path() API
Date:   Tue, 14 Jul 2020 13:30:26 +0300
Message-Id: <20200714103027.2477584-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changed the description of tep_add_plugin_path() API to reflect the
logic of the function. The suffix of plugin files is not hardcoded
to ".so", it depends on the custom plugin loader callback.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index aa868133..841e41c6 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -647,8 +647,8 @@ tep_load_plugins(struct tep_handle *tep)
 /**
  * tep_add_plugin_path - Add a new plugin directory.
  * @tep: Trace event handler.
- * @path: Path to a directory. All files with extension .so in that
- *	  directory will be loaded as plugins.
+ * @path: Path to a directory. All plugin files in that
+ *	  directory will be loaded.
  *@prio: Load priority of the plugins in that directory.
  *
  * Returns -1 in case of an error, 0 otherwise.
-- 
2.26.2

