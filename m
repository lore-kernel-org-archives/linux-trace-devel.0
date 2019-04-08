Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AD1C10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D93D20883
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbfDHPXs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34642 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbfDHPXs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so16946737wrq.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:23:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RMN9VrMGvotaixfpZjp9eD74cKEt8lcwuusjVXXoBVE=;
        b=fRulNCIYa17YLrIjAZx27DoczBfMuQ9lFKeqplgB4vJSFlKMUE+tfPR4310uZaJ+SZ
         5jLU7ZUvPa8LIzSPTGsI4hojkkBplE+hDxebyXfmboqawkCvHoqxP+l+0nxtioAGwbec
         nC7VW4g4OWCvUrzc4bI5XISJOux3CHKZjteP1urYuwxZCp+PlK8XP5XyLgxCxbB+2aJS
         JDo5sFzhDmrncUGlHBLdYbHOWy/X6urIFZHxi1k8RtAJwbqPK5ZSMe8ko9IZ4ZfeKh2N
         mHwWRkpxCJexkbK0Smr9hHJKBI33/5Dsc303plsoxQEQ6T3zsacDXUHyXR1/kpVR2fps
         34hw==
X-Gm-Message-State: APjAAAW9DCYiQLiJrfjXfxGTy+yDOwopk3IjskxAWjFdOpTuf3WhDrkm
        45CgKLdcJXMDpiHU62kyEFq3ti0z
X-Google-Smtp-Source: APXvYqzBnMEmpEYqMY7rVLethFcCwuTcXEZysuahhPhW93f5502dH/MgtXm4/1Quzt9HpwppFH0pGQ==
X-Received: by 2002:a5d:6b10:: with SMTP id v16mr20353192wrw.294.1554737027078;
        Mon, 08 Apr 2019 08:23:47 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c6sm11142498wmb.21.2019.04.08.08.23.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 08:23:46 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 05/10] tools lib traceevent: Remove call to exit() from tep_filter_add_filter_str()
Date:   Mon,  8 Apr 2019 18:23:35 +0300
Message-Id: <20190408152340.12450-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190408152340.12450-1-tstoyanov@vmware.com>
References: <20190408152340.12450-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch removes call to exit() from tep_filter_add_filter_str(). A
library function should not force the application to exit. In the
current implementation tep_filter_add_filter_str() calls exit() when a
special "test_filters" mode is set, used only for debugging purposes.
When this mode is set and a filter is added - its string is printed to
the console and exit() is called. This patch changes the logic - when in
"test_filters" mode, the filter string is still printed, but the exit()
is not called. It is up to the application to track when "test_filters"
mode is set and to call exit, if needed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20190326154328.28718-9-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190401164344.121717482@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/parse-filter.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 4ffd8b2..3320c0a 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1346,9 +1346,6 @@ enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 
 	free_events(events);
 
-	if (rtn >= 0 && pevent->test_filters)
-		exit(0);
-
 	return rtn;
 }
 
-- 
2.20.1

