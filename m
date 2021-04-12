Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3894C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE846023B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 04:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhDLEYq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 00:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhDLEYo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 00:24:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2308C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:24:25 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w23so2168341ejb.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 21:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jHRS2+wI5lI/yMB4GQhUYrmmcab+xA5RqwSN0Xtse3Q=;
        b=F/m6dDyN/2P6xlBaLNionQSYzuAXBkJN9hZPZhtcjsvqrmxISAI54jG4xuoI6DPGrq
         hjRgS7a6SAYKvdHvE/yn3wn3KNWEIwpSkNg2apYubFfoqJV6EnUvtrB4rkMswGDGgDDq
         gTK/7eWV2NGDowGs9WUmywPy2Kod0vf31eFrGuvoUOhd9Dt3mzyzhFfOfeiMimphE/vm
         C9TjGXsL2X0TVYJmJnQN4imrrhuITI1hFTvcx0xdyCyZdEjQqs5bpdxYI7JV+tWKMndP
         UwVYt3liwi7e4Bjggt/tRQrgCxn0SQl2qpn5Ljw5xPjOByFUcL6az7NDOf5xRqSXUMiW
         m1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jHRS2+wI5lI/yMB4GQhUYrmmcab+xA5RqwSN0Xtse3Q=;
        b=GtrAR6uroAmcibSonzUrYJ6SiGAKtRmtQFIxBc402fUVSpyQ+QXhvFMgPt0iVsgZaQ
         hQKp7rmbFVf02b7T5kMGmUYd/CFikJrhnO6vNfW4Pcl+cnw0HTB1YPtfYl0JakAMrtXV
         EspbHEKC45+Z11PXhLEf/uml7nIlpzS7GfhgdtbeDqsGqC/TTkVDLiUJsuPWKvGAG8cK
         yDIHG5+fSy2/i5d2o0VPPnxYPciQcpIT7fvF8H7Rih9XS2G+5g2usgjEKJzbygMoJlsQ
         I8QOX7iNVhlAQsa7w+jU6NgEwvqVUY55wpvVDrLG9MNf8ZrxkzjAJ7AOTXS1LxpuBwQg
         /Xsw==
X-Gm-Message-State: AOAM531RL9xAKDKsMvKHe/mpF1jvU2PxC/n39okQaDhrWNSwiuiuUAMV
        KsdD6OW9RJb/fniEPfZk5jg=
X-Google-Smtp-Source: ABdhPJyYJNKBR6ODpWVu3nIuOYcGFujoMh1Nf197ayUAerEJwmLMImu+MVYvGqyTx1yorj8q1wD1VQ==
X-Received: by 2002:a17:906:80d6:: with SMTP id a22mr3938358ejx.277.1618201464488;
        Sun, 11 Apr 2021 21:24:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id bh14sm4926786ejb.104.2021.04.11.21.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 21:24:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] libtracefs: Fixed trace marker unit test
Date:   Mon, 12 Apr 2021 07:24:19 +0300
Message-Id: <20210412042419.3295237-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412042419.3295237-1-tz.stoyanov@gmail.com>
References: <20210412042419.3295237-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracefs_printf() and tracefs_vprintf() APIs do not write the terminating
NULL characted of the string in the trace marker, as it is not required
by the kernel interafce. Fixed the unit test to not expect that
terminating NULL while verifying the result of these APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 04b5e81..d675c16 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -287,14 +287,14 @@ static void test_instance_ftrace_marker(struct tracefs_instance *instance)
 		CU_TEST(tracefs_printf(instance, "Test marker: %s 0x%X", string, data) == 0);
 	}
 	asprintf(&str, "Test marker: %s 0x%X", string, data);
-	CU_TEST(find_test_marker(instance, str, strlen(str) + 1, MARKERS_WRITE_COUNT, false));
+	CU_TEST(find_test_marker(instance, str, strlen(str), MARKERS_WRITE_COUNT, false));
 	free(str);
 
 	for (i = 0; i < MARKERS_WRITE_COUNT; i++) {
 		CU_TEST(marker_vprint(instance, "Test marker V: %s 0x%X", string, data) == 0);
 	}
 	asprintf(&str, "Test marker V: %s 0x%X", string, data);
-	CU_TEST(find_test_marker(instance, str, strlen(str) + 1, MARKERS_WRITE_COUNT, false));
+	CU_TEST(find_test_marker(instance, str, strlen(str), MARKERS_WRITE_COUNT, false));
 	free(str);
 
 	tracefs_print_close(instance);
-- 
2.30.2

