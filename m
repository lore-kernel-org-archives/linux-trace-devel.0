Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D502C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2261961A63
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353450AbhJANfo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 09:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353417AbhJANfo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 09:35:44 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FFEC06177C
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Oct 2021 06:33:59 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dj4so35877306edb.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Oct 2021 06:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R8icoEkGb41zqL0B3PZP6RAv/SRyfl25n9bUPYsbBTM=;
        b=Gvi+oFIC+a64ZPimAjun3guoDS5xmlOyq60UR+MeVU0MHigHx4uNGXS5fINVfj7wF/
         kqbZ8P709VIRas4ksSH9aRTJ5L8uwECwHZJPqvgrRfXxdFyEHOJa3tGSX12m2ROWJ67/
         l1Cwh0FhR3k3sI2/i4UK/MbZXXj5ZEOssVUOle7yJBAO2XOxo+C6L/p/gnMq/nVWQMql
         ysUQLla82AhtImA6jascKlu5LlyXBwUZ8fUJhQ9ID25WUuYN4TfjN3p9rfTe1NfR4cBf
         AvneictldyLimPT8vaahIaQayV5xtpsREirhZU7tBmm+TEfNBucadA6CJMhsHyRmYQVo
         Ezwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8icoEkGb41zqL0B3PZP6RAv/SRyfl25n9bUPYsbBTM=;
        b=Z1FHPoYBVBG5YoxK0OJJ+VOJjin0HWDS2wEdBhpHP0v/B96iIAQlN2WFFLHqBW+wzI
         nJYOOgnJL/AWf+UtE2QbN9VAuOE6FM6tM34UvFsVh1YdSLgIVBBgCUu2Qhl/t9baWDNP
         zIPhuJ7fyhrIgL12fvJBhhc9SLJo+A8MCuj1FD9sMxDskPkXt5A0pVJcGH0ZUWvkjgH3
         lpycTzJPQ3SGWQt0IVdAlZMLjVqFuo09ptCIREegIKH7E3udTai/hOHXSsq/pFjcImBv
         0cVAyJSfUtCl0vW5zGuo0m2rmZdqP1F+qh5Ma99etcYV2haWPTskeN9p56RV2Yy/nnNn
         7pwA==
X-Gm-Message-State: AOAM5325lDBEviH/cir5gwHJ14ayN1R0G8i96TG3fTxDR6KVXccg13E9
        wQFNuDDd44sXVl31jigs7NGs1PXsClw=
X-Google-Smtp-Source: ABdhPJxA14B0Y855eeCgLayS0i8REU5DDDWEP0rs2b6y5Hy56PM9EqgtMMdkVgHCp4NmOa0lnVHUjA==
X-Received: by 2002:a17:907:7ba8:: with SMTP id ne40mr6246452ejc.517.1633095238204;
        Fri, 01 Oct 2021 06:33:58 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id ne24sm2993250ejc.46.2021.10.01.06.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:33:57 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/5] trace-cruncher: Proper labeling of the libtracefs errors
Date:   Fri,  1 Oct 2021 16:33:45 +0300
Message-Id: <20211001133346.8217-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001133346.8217-1-y.karadz@gmail.com>
References: <20211001133346.8217-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

'TEP_ERROR' is supposed to be used with errors coming from libtraceevent,
not from libtracefs.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index b0f5e0e..1a8a136 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -68,14 +68,14 @@ static void TfsError_fmt(struct tracefs_instance *instance,
 		vasprintf(&tc_err_log, fmt, args);
 		va_end(args);
 
-		PyErr_Format(TEP_ERROR, "%s\ntfs_error: %s",
+		PyErr_Format(TFS_ERROR, "%s\ntfs_error: %s",
 			     tc_err_log, tfs_err_log);
 
 		tfs_clear_error_log(instance);
 		free(tfs_err_log);
 		free(tc_err_log);
 	} else {
-		PyErr_FormatV(TEP_ERROR, fmt, args);
+		PyErr_FormatV(TFS_ERROR, fmt, args);
 		va_end(args);
 	}
 }
@@ -86,11 +86,11 @@ static void TfsError_setstr(struct tracefs_instance *instance,
 	char *tfs_err_log = tfs_error_log(instance, NULL);
 
 	if (tfs_err_log) {
-		PyErr_Format(TEP_ERROR, "%s\ntfs_error: %s", msg, tfs_err_log);
+		PyErr_Format(TFS_ERROR, "%s\ntfs_error: %s", msg, tfs_err_log);
 		tfs_clear_error_log(instance);
 		free(tfs_err_log);
 	} else {
-		PyErr_SetString(TEP_ERROR, msg);
+		PyErr_SetString(TFS_ERROR, msg);
 	}
 }
 
-- 
2.30.2

