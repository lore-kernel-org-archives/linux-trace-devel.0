Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11D4C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A42D20685
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731888AbfCZPoD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:44:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36542 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732089AbfCZPnk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:43:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id y13so14969901wrd.3;
        Tue, 26 Mar 2019 08:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lW5yG1sGsyFAaf+D4sbXrnx/PaBrBMbCRvcHmfxct2A=;
        b=TdeI3xdtJEFxtg+DpTtiTzt8FNHcR+ViFXDnHRh5Q8ErzB59IdJLVycZ0AOHWU/mAI
         C9ZqFlNBAJasPPifsS1aIenP5GuiRkdmsqS+LJwsyY1yKwSEyY+2jgAynh6A9eDboi73
         KskNF7NcGcoBqrD+IRSpEN6sXgGRa2o2LSdS6NybTIXy2ksMT6GG+CWcrNrATQA05ywU
         BQQG/z4UjXW9Z4KJeYqNGSr7y1RyXCJU1pcRdw9ve3+/rL1LeGh7mgDYmVbrfh62IhQR
         x+5MSw2DNIoBmiZtCYHJuhIFtGHxkNWy1W9QHWk4+ttAEUq0Kq4qNAVuLwTznqiBCdC+
         HFLA==
X-Gm-Message-State: APjAAAXJmMJCEwSBdUxYE1raZvuE5eAHaV4TBnd0PH2k+w63vXnEwnc7
        IOhqbVzhhJFRdoQvLCl7DMA=
X-Google-Smtp-Source: APXvYqzmNfDsqKaf2Fa2Z18+c1lPGiy2mb2Or9YOzSIGhQRPe+q/ZzTmtIpBvl4gY3Acj7QvqM+8gQ==
X-Received: by 2002:adf:cd90:: with SMTP id q16mr19459932wrj.75.1553615018906;
        Tue, 26 Mar 2019 08:43:38 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n11sm31927685wrt.63.2019.03.26.08.43.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Mar 2019 08:43:38 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] tools/lib/traceevent: remove call to exit() from tep_filter_add_filter_str()
Date:   Tue, 26 Mar 2019 17:43:28 +0200
Message-Id: <20190326154328.28718-9-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326154328.28718-1-tstoyanov@vmware.com>
References: <20190326154328.28718-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch removes call to exit() from tep_filter_add_filter_str(). A library
function should not force the application to exit. In the current implementation
tep_filter_add_filter_str() calls exit() when a special "test_filters" mode is
set, used only for debugging purposes. When this mode is set and a filter is
added - its string is printed to the console and exit() is called. This patch
changes the logic - when in "test_filters" mode, the filter string is still
printed, but the exit() is not called. It is up to the application to track when
"test_filters" mode is set and to call exit, if needed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/parse-filter.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 298694356277..552592d153fb 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1346,9 +1346,6 @@ enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 
 	free_events(events);
 
-	if (rtn >= 0 && tep->test_filters)
-		exit(0);
-
 	return rtn;
 }
 
-- 
2.20.1

