Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD15C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 16:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3179C613AD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 16:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhKRRAc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 12:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhKRRAb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 12:00:31 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6374EC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Nov 2021 08:57:31 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id e3so29951145edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Nov 2021 08:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h1V2wO3pNNS2UrfcFTkUy/F9Aff3otX0tAL9YWal/00=;
        b=M5HP3Ugmx6MIg9ExVODQKMDrQcmPPCfh563uMvaCtMSViDSeFzBQYhA/Mabr8eIWV/
         ICO2F8BxRHlYTYessMV6zkxj1BLrsk/OIv28rVEHxPs48QTf1c533WiujY6S8r1vhV4c
         c6JdQyoERKTUxb1vKk0tqGqHc15G+dKngIEnVZEHn8KgKO00l537Ch8VR/5bH+2WpfAD
         J2HAwQRX1uOovRfluWLN96uJ+LX5PG+bVmQTjCgqNiQ3Np1hqLhNEjMvghLtnSBiftug
         rnSjner9dh7JMd/Im+/b3vFiDOZqNWQUxImjUDOHRLOIEvguOeB+d8BUvvsr1JuKxhtv
         Z/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h1V2wO3pNNS2UrfcFTkUy/F9Aff3otX0tAL9YWal/00=;
        b=Q+864OsS7MrM0aFdXXCU+hFsQixhXccbSSoMDinsBbuyHf3HeWYBm2DUEYqEB14JX+
         GDDBY/shmCgJ9AR8PyDzqB+aMsYc6kCW/ktfxb6JySTGnYuen6BrjZSiz+yNjgWS0yLw
         CthFjfjJuOaAHiGP6j/pv+3nHjKPP5u0887V9t3U7DSHwofmD2bFJ1YvOQQUl+eHQg6c
         +9pVUC7kNkFtodG9PBe1Ov6Aot/uznpduHda3qbRr6vk8tXY4Wm6YJbd0hRMD5R30zDf
         e7GLm1YfokaYdV+q2O/S+JmgtF4aoq5qQ8gGbNkre7BBzwVjQFKoOrd5XMXk8ywFL/ob
         JiXw==
X-Gm-Message-State: AOAM531JUwTYDQoEGb1QozUs7Bm4DqGevfFfIMkcXE2e8YkEUgreWc78
        UE02QbPlEI0rKij0HlFfiY7bAmgoK4V5pg==
X-Google-Smtp-Source: ABdhPJzLUSSnK60dUFPqeGVCtrMGmO7O+g8+zi+7JP+4W3RpPk0NX21DXsZZ8WUe/Cweh3wy09Wiuw==
X-Received: by 2002:a05:6402:3551:: with SMTP id f17mr8542086edd.129.1637254649999;
        Thu, 18 Nov 2021 08:57:29 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z8sm256189edb.5.2021.11.18.08.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 08:57:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, amikhak@wirelessfabric.com
Subject: [PATCH] libtracefs: Use getpid instead of gettid
Date:   Thu, 18 Nov 2021 18:57:27 +0200
Message-Id: <20211118165727.75994-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The gettid() call is not available on Jetson Nano running Ubuntu
18.04 for aarch64. This function is used to compose a random seed,
replaced it with getpid().

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203871
Reported-by: Alan Mikhak <amikhak@wirelessfabric.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 005fa8f..085c10b 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1121,7 +1121,7 @@ static unsigned int make_rand(void)
 	unsigned long seed;
 
 	gettimeofday(&tv, NULL);
-	seed = (tv.tv_sec + tv.tv_usec) + gettid();
+	seed = (tv.tv_sec + tv.tv_usec) + getpid();
 
 	/* taken from the rand(3) man page */
 	seed = seed * 1103515245 + 12345;
-- 
2.33.1

