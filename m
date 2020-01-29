Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055A0C33CB2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CADC720708
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZH3m90wz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgA2Jye (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:34 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36407 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgA2Jye (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:34 -0500
Received: by mail-lj1-f195.google.com with SMTP id r19so17756864ljg.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8+jjHJvLvbui4mYPTlH3obXmaqZw7jC24PU1x6Bgi7c=;
        b=ZH3m90wziERDVRSiN6PunfkeXrgPI4X50X2p+PMpKWyVcBZi0yP84FPwzIydza7IA4
         XYcnrtPDvhJwl0J9tHxO+AP3+cELN/wgAgD5DCP7slSjodJR22El/jG1a5EIESycRJAZ
         vQXRTYF1J3QfpSb7Ys+ZL2tfTLOyDIOaU1Mm01fplun0kTIii63tZT9MOtdzfMfbumdh
         gG/eIbdqOw0+lV7iZqF9/rQHG2ZZ8my533LnFMSXbZFTtYfgXq+NdNn9AiqMnGKVGxav
         +7xYhbzo4cMqmcEBp6ryFV8NFxUvhXKtFLn52CZtJeCEx3HfzpE1GhrXwGhehBqW9if4
         8EPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8+jjHJvLvbui4mYPTlH3obXmaqZw7jC24PU1x6Bgi7c=;
        b=r0ltjYrZNydC4/W9bKyBCNuvaxEtPz04bxv2Oixz3xjyFVb4xK6TrP3pd53x1niiUv
         W/pjUSWMuhm2CjHlarc2jVJf3MjcHs+pqDm43gAPq/ZTlbrNYoCX0ghrOrf05fO7IXfc
         JhigzJUp2aTMM8SuQ0LxQF+nDFzgVnFl4XAb7fF2xOpxIQfsNkAf568VJg6/cfzhq838
         km8AdcY8q8xQSxN1eVMbVOIkM+wnx6LH2/mNER3+Zyeh4rcjzRTVajH3499BAmsFe4to
         LSp7UKwf+ilNNd8rfOy1SuRLZXtCR3ofzb8TIF5ysqzK4mwTxNXqCFYFwRZrg3Tgi5ch
         dqNA==
X-Gm-Message-State: APjAAAWMV/TCG9aySSJnq4yjAZL04jPUj/JmOFj/DalLSONr0P5ynb65
        504vYI1gaURqTybDCIbpOB4=
X-Google-Smtp-Source: APXvYqzD3kNmH7bvdD0APvtlVtti5TdxdqKtsYlI5vDLtfha3z0s15uDDcNkPLp0TzeO7jRAxZ/Rxw==
X-Received: by 2002:a2e:b00f:: with SMTP id y15mr4047781ljk.290.1580291672758;
        Wed, 29 Jan 2020 01:54:32 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 8/9] trace-cmd: Unit test for tracefs_tracers() API
Date:   Wed, 29 Jan 2020 11:54:20 +0200
Message-Id: <20200129095421.881786-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129095421.881786-1-tz.stoyanov@gmail.com>
References: <20200129095421.881786-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A unit test for tracefs_tracers() API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e4ab64f..1fd7f09 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -322,6 +322,35 @@ static void test_system_event(void)
 	free(sdir);
 }
 
+static void test_tracers(void)
+{
+	const char *tdir;
+	char **tracers;
+	char *tfile;
+	char *tracer;
+	int i;
+
+	tdir  = tracefs_get_tracing_dir();
+	CU_TEST(tdir != NULL);
+
+	tracers = tracefs_tracers(tdir);
+	CU_TEST(tracers != NULL);
+
+	tfile = tracefs_instance_file_read(NULL, ALL_TRACERS, NULL);
+
+	tracer = strtok(tfile, " ");
+	while (tracer) {
+		exclude_string(tracers, tracer);
+		tracer = strtok(NULL, " ");
+	}
+
+	for (i = 0; tracers[i]; i++)
+		CU_TEST(tracers[i][0] == '/');
+
+	tracefs_list_free(tracers);
+	free(tfile);
+}
+
 static int test_suite_destroy(void)
 {
 	tracefs_instance_destroy(test_instance);
@@ -365,4 +394,6 @@ void test_tracefs_lib(void)
 		    test_system_event);
 	CU_add_test(suite, "tracefs_iterate_raw_events API",
 		    test_iter_raw_events);
+	CU_add_test(suite, "tracefs_tracers API",
+		    test_tracers);
 }
-- 
2.24.1

