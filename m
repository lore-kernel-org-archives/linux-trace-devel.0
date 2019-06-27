Return-Path: <SRS0=Hh4L=U2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4E2C48BD6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 600FA2064A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DkpvBIpC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfF0P1Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 11:27:16 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:53450 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0P1Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 11:27:16 -0400
Received: by mail-pf1-f202.google.com with SMTP id y5so1768882pfb.20
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jun 2019 08:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5v/hQydlmPHFrqtmzwxy/3jvZiELDO/xotb7PRYOapA=;
        b=DkpvBIpCR9TkJ7FAOhNcmdrer+2Fi1ovQXCJ15oT7up28GojnVB7QdXU3uzhlQjfRu
         wj+Ffexw3IxzEe6ymTMIPFbP31pMxBOm5hYgvmxaP1LQgljjzxutvU2ycoYIcOBqfqAE
         9ZpxLXws2sKVioZ+2Hf7lv7YrjUwggdDyai622mDa4mUrmbKt3tOI7Z6Px87iBAUTeCW
         ktqrOVUmbgFCMY5ugLCvnOD4B01KfFwatoI76D85daEe54oql/wlx6UkeNB9JApcBTSQ
         Dj6R2j9wNzyXCXUSWZ5eqlesS4UCTGsR1gGPkOLA/T46i3TCVVHWCe3v7ifavcLq+XNp
         cWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5v/hQydlmPHFrqtmzwxy/3jvZiELDO/xotb7PRYOapA=;
        b=V0PbgxYALpQ0ZHBEeKEOD2KTz2Xq90c92gkz1+UM41eLWiRTwxy2nbZ//wPcKCPbpS
         swL7bhtJV044F4F/7QY/sskwVsCt9EcrC86k8phIcz2FiazqhX0xWD9oUD47igGGyvZ7
         ONbrLClJrrWssem4BLHJOOqoHvJpNyvzCsvn5G/cthK1zLrKA4k0c1IB6Xaas59dFoKA
         Cyzx4CCNwMDW09InyMCiHOTkKzreJP9HXBdiyfj9Y3g+cI3Z6v7Apy2MYyeNoiittvME
         oEemnM9gw/RsaSY14mM6Lhm7TfrBfzFdwZdb5xMBNd75/Qn2IpyuaYSWT5dRw6P9mFWw
         xR0A==
X-Gm-Message-State: APjAAAU1pZAfxScHQuoy7PQkKJfuoN21sISAfCy+mqZWtfxI1Oqzx9KF
        l3iZTTm9eqHu7Wzm/OhQjhuETAz89NCl
X-Google-Smtp-Source: APXvYqwhqkuLpg68sYrvA8vs9l3uONCW/MZuX6bFh2xdb/WVe/Vum2sq9YtJj+bE77eyOLvitcE9JPZnJQqJ
X-Received: by 2002:a63:246:: with SMTP id 67mr4287998pgc.20.1561649235181;
 Thu, 27 Jun 2019 08:27:15 -0700 (PDT)
Date:   Thu, 27 Jun 2019 08:27:10 -0700
Message-Id: <20190627152710.177848-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH] trace-cmd: avoid using uninitialized handle
From:   Greg Thelen <gthelen@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The put_together_file() 'out' error path uses uninitialized handle.
Unconditionally initialize handle.

Fixes: 9ed499fccef5 ("trace-cmd: Fix record --date flag when sending tracing data to a listener")
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 tracecmd/trace-listen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 3106022eeb39..9132582768ac 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -626,7 +626,7 @@ static void stop_all_readers(int cpus, int *pid_array)
 static int put_together_file(int cpus, int ofd, const char *node,
 			     const char *port, bool write_options)
 {
-	struct tracecmd_output *handle;
+	struct tracecmd_output *handle = NULL;
 	char **temp_files;
 	int cpu;
 	int ret = -ENOMEM;
-- 
2.22.0.410.gd8fdbe21b5-goog

