Return-Path: <SRS0=n4q8=XU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA7FC4320D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Sep 2019 11:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9004B2082F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Sep 2019 11:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TeOGuUkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbfIYLIa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 07:08:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54722 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404293AbfIYLIa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 07:08:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so4880627wmp.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Sep 2019 04:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cZ/aOnWwCD89QYkOIYb9nBbkD7csPYkLem8bSGqJdRg=;
        b=TeOGuUkfy+DkYXLGOPVSJOPxzuLj4k2yLM+6jFvJP4o2O429oVgl+VDxpfM6SEF3Gi
         hHXuGFKY1qDp96/83/q6OqxP8sLvFi8DbjVN6fuqra7shWSfpFO+dpgzvM3R+6kkGxgD
         6pk3J0g0gfBsgZJ4QVTKJJCv4cRcWhqY3qeLTj1i8zzinK77VPFQ/fEC2odtrCMWs8I9
         TdzHayJT6tKncnUW1c/xL2ShvWuekfAkLigfWVUfFY8XVam5klR8+7126bhdaAQuWi17
         yBgtLvLzPx0DHK7jCsRXIEs3yLBC6B/XT2jpMfsPX1LonlmPnCWkRWFAxb8R7FKUfAvr
         SilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cZ/aOnWwCD89QYkOIYb9nBbkD7csPYkLem8bSGqJdRg=;
        b=i6BVsPqyIzNVM3AXr4iSY3ZHL9gHD2DquYGHdkQlAQa1khs18mvSAGPKMXyIYZ1/vI
         7QFlVn2pfv61RFa93aev/gzMPYa4stziAALaF1EPyWkgsdaimgFik+aStHlB7WnKYTf4
         AWEqv7mlUs/PD8+t8V8KhhQbBx/o+SKoSC6DXeFV3nOFGEKnRvG3ezfIbRbnm/BgzSMh
         /PdQ+/OPCAqFZJdciy5Xnt2ccISTRIxz7sn6phVA0RYMOaTV6hEfeqkpUD+6rmX6AC4S
         gfUkawk8zQ28+MCtnG+VYt1e8d+VKkMaRYcaV9lw2hvyX0CqOvtUr79UN6xZigi6bjXT
         P62A==
X-Gm-Message-State: APjAAAXHkWPzVQPhp4zkqxsLZZn3EH+m/KvURhYYjrzAlJmFZLG6irFD
        2ZEq2+2nim3WQFsb3rhAxdHy6EH9
X-Google-Smtp-Source: APXvYqx5E9fv//nGEg66XPNxlsxjbEQzhyBivZRtB5PWK+HxDI1KjEI1e0lq+rjIQYQymmPhxCl5pw==
X-Received: by 2002:a1c:4846:: with SMTP id v67mr7009537wma.120.1569409708036;
        Wed, 25 Sep 2019 04:08:28 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t13sm12277619wra.70.2019.09.25.04.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 04:08:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Reset CPU mask after setting it in trace-cmd record with option -M
Date:   Wed, 25 Sep 2019 14:08:22 +0300
Message-Id: <20190925110823.1242-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190925110823.1242-1-tz.stoyanov@gmail.com>
References: <20190925110823.1242-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When trace-cmd is run with option -M, to set the tracing cpumask, it was not reset
to its previous state. The trace-cmd record should put back the original value
after using -M for the tracing cpu masks.
Fixes https://bugzilla.kernel.org/show_bug.cgi?id=204941

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 96d2c1a..69de82a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2403,6 +2403,7 @@ static void set_mask(struct buffer_instance *instance)
 	path = get_instance_file(instance, "tracing_cpumask");
 	if (!path)
 		die("could not allocate path");
+	reset_save_file(path, RESET_DEFAULT_PRIO);
 
 	ret = stat(path, &st);
 	if (ret < 0) {
-- 
2.21.0

