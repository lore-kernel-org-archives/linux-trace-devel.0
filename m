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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510D4C432BE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34C7161051
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhHaMzI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 08:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhHaMzI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 08:55:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E695C061575
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:54:13 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id u3so38346302ejz.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c9pp2YjBs7uw+inFCfj8LpaWJy3nC58Un7gERWT88QY=;
        b=A2gMvLv20mqcToFJNaJ7aLXdUoVV/uApC4TBky7AgVfg6Hzf2kwEFUA51Z/gVEPYN7
         dg0vQZBKU0yvubAQxCXViMJEn+pnjrixf7fI/cRI+G0wEkJkRyqo16sI8h9jC0MOFKSP
         rSo+UerjrsF6TsukTnj2LqLak5JEm5c2oW9/PZJOPCg4ouY0Q8SA9qVtjv6oc3EQc0ao
         KWixBuas00OIScXKfKO6okOFaPJnqHQ6l0YKd2DCwiza3jZxBrCiDGQ2PiLo0DzpCWAL
         GDJshl3A/BAuPud3QLCYseAxvXR5Gn9yhJKRXHSuO244Mq8HLnT1sgAn5+xTHUZDu33j
         C7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c9pp2YjBs7uw+inFCfj8LpaWJy3nC58Un7gERWT88QY=;
        b=bJ4Rz9EbzqY15zRW5BG+OSg+pywp9QqZjofkr1sNUmKdG+RPi2MVLJfW79WGCKLmLN
         WgH1dIN5BB5TOWPdyXpDbvN57ap6OyOzuNw1P9eS3o7CqKoAJy5xoPA8JNqBDIxf35wo
         x2TnCSxAGlltpyq8rCFfv27gCjcZAY1uGOaSdRyUEtW5xysYkQpvfsY314MtUuf8oT+W
         9JyeawgUpquyZp4KzL7hSpD5VGSdCSrAU4og5SyBHSn6wJAD4MIVhKtiU3uBbloHetfs
         PzsFQTsxXsESc0rscFM+H12E3ERjFDPvzYKvwTYTs92TwRpt7Fz36FaNcC4ouV5vuB0Q
         m37Q==
X-Gm-Message-State: AOAM532AtQBX8wxJwgs4PMYuwU/r1sl9/BKYSTiQdC/jFIQM5kQ6vA/1
        z79SO4L3wAgeBaVLvsc/rkqCBUia/5s=
X-Google-Smtp-Source: ABdhPJxgzGuyox6sNYg/J0DMtaFNfzr6cBWfn26zU3+wbLoGe2puvE8l1m1GFmXe0hRTsVu49NwZag==
X-Received: by 2002:a17:906:ae4f:: with SMTP id lf15mr29792057ejb.124.1630414451556;
        Tue, 31 Aug 2021 05:54:11 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id be5sm9346976edb.57.2021.08.31.05.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 05:54:11 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] trace-cruncher: Add optional sort to available_event_systems()
Date:   Tue, 31 Aug 2021 15:53:56 +0300
Message-Id: <20210831125357.56862-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210831125357.56862-1-y.karadz@gmail.com>
References: <20210831125357.56862-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

An optional parameter 'sort' is added. If set to True, the returned
list of system names is sorted in alphabetical order. The default
value of 'sort' is False.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index f884106..b94745d 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -717,17 +717,29 @@ PyObject *PyFtrace_get_current_tracer(PyObject *self, PyObject *args,
 PyObject *PyFtrace_available_event_systems(PyObject *self, PyObject *args,
 							   PyObject *kwargs)
 {
+	static char *kwlist[] = {"instance", "sort", NULL};
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
+	int sort = false;
 	char **list;
 
-	if (!get_instance_from_arg(args, kwargs, &instance))
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|Op",
+					 kwlist,
+					 &py_inst,
+					 &sort)) {
+		return false;
+	}
+
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	list = tracefs_event_systems(tracefs_instance_get_dir(instance));
 	if (!list)
 		return NULL;
 
-	return tfs_list2py_list(list, false);
+	return tfs_list2py_list(list, sort);
 }
 
 PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
-- 
2.30.2

