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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B73C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 23:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8F5A61465
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 23:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhDWX17 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Apr 2021 19:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhDWX16 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Apr 2021 19:27:58 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A2FC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Apr 2021 16:27:18 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id e5so21183833wrg.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Apr 2021 16:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zWzqlEre8YII50jdVeygNLpfodVE7YTqXibOjKTO+5U=;
        b=M18YqSN3uXmkp1dwQZgqxqxvxZBsirB3+pEcuchA4q4juI7qHtSIt+7svvHFAwiSvR
         d28GUlbbN8JAqu4hm7PgiMYN+AG31zzyO/Xu27kFl5L1uxs+9sv7wXyuZSHJWhEoyz41
         MQjPgBGNq1E73u0PkuOlPtBNGvLn9BIJsFolg7kftDQtJr+10cJ7vFORkmmMuQ4Otg2Z
         YcJM47jVh0kKu+yspySS6515UTHZ4tyFLa3ErqmjHrYcSsdcDEI4tBK89t/1c3ZpBWSg
         jEO1y7SaQsrGwMJLntqOXEYexPEOX/j1mkjf7brT1hUOW+JpZuiOPR/C7DGVJbMZe7Wf
         XjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zWzqlEre8YII50jdVeygNLpfodVE7YTqXibOjKTO+5U=;
        b=WBc9YEyUGaxQNdpCJAAtVcxA2qezagygMz7zhw7u2eT+Izd4R2E6sgxJTfV22rMLM8
         9dhz2RIalfUpBX6MVOZmg4Si3B8ge8G3TwsYpjcnJATI86qcal4DRa0rT4+nCaR/Czfn
         DXBnLJezUfj1mnDrRRffK/B+2DTjowIeMGdjFu+AJgb/gu3dep8iykNM3wS0CL/9y+3J
         E3maFPU1tgOGuUHxjX6c+N4u9MB48OAzRWGoCXxYdoLR1kzF94pSNfjbblnMfgPcq8sf
         lForWIusT2+Ln82lrGTLh4/33OxWKIjwWpfgwSARfiIOi55Cy0ES/nNdiwBm8rjxMjaW
         WLcA==
X-Gm-Message-State: AOAM531fhxbwPx0jQv6z0H2r0fneJYjLN6s8aFPk3Vo79J00yQp5wLJE
        7KM+KVXmK02cODrVSEWAQAY=
X-Google-Smtp-Source: ABdhPJxH+e/iMEtDH9pZTfU1+iCdWYNpHV3WfgL0CvJ0Z2ebgj5hZq5CAg+wKiRK7WhJXk+b6TFGYQ==
X-Received: by 2002:a5d:678e:: with SMTP id v14mr7628413wru.156.1619220437065;
        Fri, 23 Apr 2021 16:27:17 -0700 (PDT)
Received: from debian.lan (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id h10sm10558764wrt.40.2021.04.23.16.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 16:27:16 -0700 (PDT)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] libtracefs: use mode with open()
Date:   Sat, 24 Apr 2021 00:26:48 +0100
Message-Id: <20210423232648.1197063-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If -D_FORTIFY_SOURCE=2 is mentioned as a buildflag then the build fails
with the error:
In function ‘open’,
    inlined from ‘copy_trace_file’ at tracefs-utest.c:1032:10:
error: call to ‘__open_missing_mode’ declared with attribute error:
  open with O_CREAT or O_TMPFILE in second argument needs 3 arguments

Mention the permission with open() when O_CREAT is mentioned.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 utest/tracefs-utest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index edb3a3d..0965363 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1061,7 +1061,7 @@ static void copy_trace_file(const char *from, char *to)
 	fd_from = open(from, O_RDONLY);
 	if (fd_from < 0)
 		goto out;
-	fd_to = open(to, O_WRONLY | O_TRUNC | O_CREAT);
+	fd_to = open(to, O_WRONLY | O_TRUNC | O_CREAT, S_IRWXU | S_IRWXG);
 	if (fd_to < 0)
 		goto out;
 
-- 
2.30.2

