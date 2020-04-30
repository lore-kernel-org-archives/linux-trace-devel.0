Return-Path: <SRS0=Wcha=6O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAB4C8300C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E05812076D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eQ+LEoBO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgD3MWa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726500AbgD3MWa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 08:22:30 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDCDC035494
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:30 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a21so6203650ljj.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fni3boaJXyriszWVM3CfKGyDpgww0el+dA3bYTKikKk=;
        b=eQ+LEoBO1FsG38aNlg+1F5Npw/fMXlRuJ4Z3+Mldt9folXIK/hu59eMJ2tSWgCaE0b
         XgGK1Mtj3coRFvEdZHtD1PEAj1ej5Bh1TaY7rnhdT7LH4nsMhB/kJOwrlKo5BJ8oKBgA
         8RZtaCXXlaz8N26hWiorNDNCbmiJEZQSz+1VTH+PWDBSsgSx7I55oAxCdtI7SuYchiP1
         E+0zM7L5aKStq2w1Sq6MLiVlNHL+QwJP5FSLbDpFWJTkZgrSsp3YSqRLcuQyaWeyB390
         OLLormLDOD9jstrxYBH2zIuqDRAGgdgCTxtnm9mAhAj+OjUPyujIjL1VBczQmnYONic/
         sIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fni3boaJXyriszWVM3CfKGyDpgww0el+dA3bYTKikKk=;
        b=H105m1vb/Sotu1URRcIrdBF/SIVeHPi0k2pHT2CRH+3jXT2g1PmLkqCRVveYgd55it
         cXcNlphSRa93fpOJFDpQBqW3QFYhcq+5NZb/GL4Moh/DrLxawwPO1HfLYoJHWHaF8Y9N
         C7cDLPqkAPiTp7cDeNVuaW8C9n6IhZSplzghJpzWXKB08pagqcm+JFdYj42GyA/bGw/j
         n/rMqfEDqoLouR9+0DHCqv9ugHTmKLsA6IJ6JTD7GdcmW7RuRoGjL2dPMYtsmxRBhLJk
         MMgdqXOMm6Y80sD8axA+bUerxaQQUJbMyk7pS3j/zoZr6pfP49eG1enHHJvS5Uvt1uxT
         CZgA==
X-Gm-Message-State: AGi0Pub+9LbgBrr3Y4JLvscsGdtJBLkKorCaZpB+W+FBuojrKDiwlwql
        SUgpkJmvVpAeHQJ7JafGIks=
X-Google-Smtp-Source: APiQypIV3hafq6UZsdTdSXlW8w8o0wZCa35bjXcOuE7bMXHCR5Ve/g8DHyStlGj3kkgHa0el+iwPgQ==
X-Received: by 2002:a2e:9207:: with SMTP id k7mr2048062ljg.124.1588249348596;
        Thu, 30 Apr 2020 05:22:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a26sm4793168lfl.66.2020.04.30.05.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 05:22:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] trace-cmd: Add "main" in the output of trace-cmd stat when displaying main instance
Date:   Thu, 30 Apr 2020 15:22:20 +0300
Message-Id: <20200430122222.101276-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430122222.101276-1-tz.stoyanov@gmail.com>
References: <20200430122222.101276-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

By default, "trace-cmd stat" command prints status of the main ftrace instance. When more
instances are configured, the user could be confused which status is displayed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-stat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index c5057978..dcf2789c 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -920,8 +920,10 @@ static void stat_instance(struct buffer_instance *instance)
 			printf("---------------\n");
 		printf("Instance: %s\n",
 			tracefs_instance_get_name(instance->tracefs));
-	} else
+	} else {
 		report_instances();
+		printf("\nInstance: main\n\n");
+	}
 
 	report_plugin(instance);
 	report_events(instance);
-- 
2.25.4

