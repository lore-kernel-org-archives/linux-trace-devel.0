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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF9FC433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D10720BED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWL4p0/O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGNKam (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgGNKal (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 06:30:41 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CB1C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:41 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y10so20987037eje.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktLVlDGtVkYPLfrfkJ5XmJPQ/WL9O6ZKzOLXj/WojVw=;
        b=TWL4p0/O9pagzFVa6Ir264f2saZwMa6t9nlMF9qkkfCMXqxjotvViXoUNHGItPZABK
         7qwaUE7u7wcjckz1TmSHtx8C37VXevrVFpE8H6AD0kkZqbRD9isLsmaEeFERV+YqYqdo
         r9A9RtxkHCZBnzkuuthkge3hc2Gel8foUINN9ns+/Sqghifz/nrUwnLTjQGwzlF2jVi+
         PcTIuwSQ2iWsDLNiHGIBluQTuQWWh0tEM+NqAo31bBLCYkZna4lFqcAngGOtQi/m8Zpn
         3jUe1ZaFZtFJtgRhSaxvsR0oOLkZ6WZWhBvIxAvgdzHl7QfJlCnRmfJGLO/T5lljTHh6
         L5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktLVlDGtVkYPLfrfkJ5XmJPQ/WL9O6ZKzOLXj/WojVw=;
        b=LeMdWPAeyjqevAy32Ag0Abbn1UP8htYjnJJ4piFBLS63o5yxIYyGSFaVB+aTbd1OW8
         gtzpnXVo0tZJtFmg2vx/FjAmtM3Tk4/kDKmtWs01JurY8+O63eYFbOYehqHfiWJtqFh5
         gHqBneGxqkIe1qmv2bicL4cFBILlNeol9N9KsEPRwx/kSkrGU8f6obSc650ApfWzcU7u
         BfBINmlVqHKt1dSwTyTEU4hHSExtz6uTuvKxex4KLbXid1vnLDetrSzDj0Afo2gNX7Xy
         cV+oWOn62m4gK3s8IG3LuACHGjG2E1o52lMf+Daz3AZtF58F61XzUVDIrs0Xqw6JoZpH
         eztA==
X-Gm-Message-State: AOAM532jRv80hUP8PyN9ihIeq1mCf1zT7rEXWhAv9ZftT4PB/vtj9bpL
        4rITEBPG/B9+TeJOzgfVn2E=
X-Google-Smtp-Source: ABdhPJwoqaM9Wbxd6hR2XJcmhClytgoXruq2+DN+5RXDYo4NFyIIi5/NW+SuVKkV6qgeBvlEZr6W0g==
X-Received: by 2002:a17:906:69d3:: with SMTP id g19mr3997402ejs.402.1594722640231;
        Tue, 14 Jul 2020 03:30:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gr15sm11766034ejb.84.2020.07.14.03.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 03:30:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 8/8] trace-cmd: Handle possible strdup() error in tep_add_plugin_path() API
Date:   Tue, 14 Jul 2020 13:30:27 +0300
Message-Id: <20200714103027.2477584-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Free allocated resources and return -1 in case strdup() fails in
tep_add_plugin_path() API.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 841e41c6..4a3f7d3f 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -666,6 +666,10 @@ int tep_add_plugin_path(struct tep_handle *tep, char *path,
 		return -1;
 
 	dir->path = strdup(path);
+	if (!dir->path) {
+		free(dir);
+		return -1;
+	}
 	dir->prio = prio;
 	dir->next = tep->plugins_dir;
 	tep->plugins_dir = dir;
-- 
2.26.2

