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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55DF2C07E95
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3177A61026
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhGGNIR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhGGNIR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:08:17 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D97BC061574
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:05:36 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id ch27so3251765edb.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fBedZIro9PWHYXf5d5nOCKc1HFL7IaRdB3Bg9nBknBo=;
        b=Jx89jHIYtIW5pGjSPZTnDvge4XHZFWd8Ggyg7LGdRJ8rFM37OscVxj1hcQCvy85q6K
         bX0gW9VpK6JouvPRm/JV7OYCNg+W5KZP9u82O7fF1qEsIg1kFs2VtKYHxWxT4Ax/wkni
         96NEF8a0QHCbCN8OO7aAu1y8A1kgGoaz4y8ELeK7ejktsBgsWzgaMXHXesAW7tL2Pzdv
         xoB2cNSLQJIBO8OZgmHmSvhcywDw27P/O/s9184eVG9Oc00D7kBnvpqpWSvnlNF4AgvW
         oCwBT/gXKFz5Ck3QaAkKCpIBQHoB8Du9z8iIy9/0fng+0FkiLaezljoMkP0lJIkcQLdr
         vL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fBedZIro9PWHYXf5d5nOCKc1HFL7IaRdB3Bg9nBknBo=;
        b=mxbPDJDh6phmFLZLsNi/0FXeBCg+UKei6HeX9UqpgtXwxN0l3oV39F85kV8SP52aWr
         rMtXQkhamICR+u833BTKDMBAFLTNximcyZbO2kqORTCxlF0LMM3v75zy5KLh5bMsk9VW
         Fp7xddqSjLkuEynUldYiNJZ21KMh5+UY+20KotgebQ0rH14ccNMgoNu3bcIJn1DMndKs
         /AyOogK9KxDwyeLoMjiepFu2PJ14J+Vsfoux7e60CazrpIZawuWFJNXEgiP0HGVLRvxm
         nPn6F2tszVlLEH6Xgk7bkPuuJDG+xPXmfbClYhL3tnAhHeWnWbAdu2pSscvrQsMuuGZL
         Griw==
X-Gm-Message-State: AOAM531XlaVFY/qnPddVxjxhKkw7225ZCOZEOdcM1DG+HhK3c/FfzJYi
        YfkV0VTb5O/2MzgQLdTktB8=
X-Google-Smtp-Source: ABdhPJxVAEC8eUgwEdedGqCY/d/em8jE1WD0NEc/kReMZWHMAQOg94tKxxH5RoPu5DdHHM40mhOIZQ==
X-Received: by 2002:aa7:c4c7:: with SMTP id p7mr1184114edr.290.1625663134659;
        Wed, 07 Jul 2021 06:05:34 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id q11sm1385174eds.86.2021.07.07.06.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:05:34 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Fix bug in tracefs_instances()
Date:   Wed,  7 Jul 2021 16:05:23 +0300
Message-Id: <20210707130523.67268-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The empty string is now made of two elements, because of the hidden
first element that stores its size.

Fixes: 056a177 (libtracefs: Restructure how string lists work)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/tracefs-instance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 11fb580..d601db2 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -694,7 +694,7 @@ char **tracefs_instances(const char *regex)
 	} else {
 		/* No matches should produce an empty list */
 		if (!list.list)
-			list.list = calloc(1, sizeof(*list.list));
+			list.list = trace_list_create_empty();
 	}
 	return list.list;
 }
-- 
2.27.0

