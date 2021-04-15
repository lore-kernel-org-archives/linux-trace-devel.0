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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E94C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8119F6124B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhDOIDo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 04:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDOIDn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 04:03:43 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A607BC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:03:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w3so35506495ejc.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oZMC7NoUg9LIINTegPsbuVUROEyAkRjeJaskAY2xw1Y=;
        b=nFj0Q6Dy062sip0DGgrCu5/0JhXSQC4UBAyo0fQE0UiKM1mUju7PHGlh9qvwzXf3os
         TfsPpVTJRAzZ4fYQI0m0g/izyL30sYvLn5YcnjRfgcch5KGE1Mj0+FkytTLYDN283emy
         scJgxwoKfeqJOaMuDtm2FB3IZSMLxgf5tG/ydoIbfgS4xipaX4hL71Z0nTC07iJiWtng
         qdbFpFMKAVTvyLN/8D0swZkpkuW7HF4nbvzbcy4q+ONiFzROM4JauKVOIgeozPdIav8J
         k5/B1MyYDXcLXxzosT3rqktV4/4bkL4xnitgwHfB4kfdN0hG/57EWuZS2lDzk9HOszg9
         Kxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oZMC7NoUg9LIINTegPsbuVUROEyAkRjeJaskAY2xw1Y=;
        b=kBnoQCHQqHbspkhIWpzTTPGmHWkgVlK+ZaOaG4/rw95l3FnlDLE7cMhLuvZa039NMj
         KKpOiuJgB98SSIV1z8pV+t8p5S1v5Px6D11u6C1gd7swfIvYHn2onANLGBG79OIUPqT+
         ceSK8CIBTeVbuYEVyRcXYQqMNeVSJPnJORFzF5Z4lU+GFMkoXYmFzzI33nPjeKqzdy9I
         BiZQfyWBml5aQzKeJ+eUf1sMaJTPW4aY9fNyygcVFrQbdw9DBOEBmyULLsFWtQAZp0k/
         nZrvNK8RY4olYLctTiWY2WUg8WwTW5CPkO/burd5P6mVPCQORMT73+I8KSdxI7HdVdvs
         GQlA==
X-Gm-Message-State: AOAM532YcyesP8MNo8Tvl1CdDFeZtsgdXALURs+0Ft/pJ6A+nGLlcI7b
        k+0fpkpNtprh0DwKBfQGz2IjG7MAZII=
X-Google-Smtp-Source: ABdhPJw5rwZk3yVrrrNrBHo1O68JBr1+yQocA1xTKdXsLQxjPsv3JGN5YilmCtBWlPbdqHQgqGmJcA==
X-Received: by 2002:a17:906:3683:: with SMTP id a3mr2120667ejc.210.1618473799477;
        Thu, 15 Apr 2021 01:03:19 -0700 (PDT)
Received: from oberon.zico.biz ([151.251.243.123])
        by smtp.gmail.com with ESMTPSA id gs20sm1327420ejc.83.2021.04.15.01.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 01:03:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Suppress trace library warnings
Date:   Thu, 15 Apr 2021 11:03:16 +0300
Message-Id: <20210415080316.3482986-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Suppress all warnings from libtraceevent, libtracefs and libtracecmd if
the trace-cmd application does not run in debug mode.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-cmd.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 7376c5a5..7de0671e 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -35,6 +35,23 @@ void warning(const char *fmt, ...)
 	fprintf(stderr, "\n");
 }
 
+int tep_vwarning(const char *name, const char *fmt, va_list ap)
+{
+	int ret = errno;
+
+	if (!tracecmd_get_debug())
+		return ret;
+
+	if (errno)
+		perror(name);
+
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+	fprintf(stderr, "\n");
+
+	return ret;
+}
+
 void pr_stat(const char *fmt, ...)
 {
 	va_list ap;
-- 
2.30.2

