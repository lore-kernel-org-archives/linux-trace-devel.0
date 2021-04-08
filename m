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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCFEC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C75A461164
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhDHIGH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhDHIGH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 04:06:07 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0711C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 01:05:56 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 18so1293519edx.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 01:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hztf21EhvGYB9i2XVM5L6KXMLhpuLG0Ok3EvG0OpRn0=;
        b=lgpUWElzgDWxwmdSGIB6svkvmRPdCgAxl79DEuaLj5rMcM5xhby5TwjmET7QBBMsjO
         VF+9C+H2DRWnn3VW0SPgaMn6RpIf1130gEG790Vke8GD7ulXQbCuOUc6XfquGOMdzqNr
         wWkNzSOl/tl5q0ck2IzAGKEIFPikeVHEHp70IisZctsxI15Vv6QkBJ+qEWUzFR1G7Tq0
         QAG9S8fkYjzZN6LaTTa4ehA8hcXEJ8mIIHgtql5+0kdeCwOmNXW7/Hs42QtMXjFHu69j
         AExbuTPkIuz4qY5GMVz4gpilUT1Z6HfsN+SH1I2XlLMt6PD5u3FB0+iWXkd3cN8VqyZQ
         rOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hztf21EhvGYB9i2XVM5L6KXMLhpuLG0Ok3EvG0OpRn0=;
        b=MVngb3pR7o4lnIZzqFmD8/HVmugC1cyIsKIG3hI9YQZAPIotobkpUOPiu8XpJFB1x5
         Dw5TDICXkrN5M2+eMTQwzNdDArZm98k7TjPwGygmo7KF2mT74pkeYzqLBEeSSTk2KONB
         RJCP5qZp138MbAZF0gEKfQE2q7r2w1imuyyOIl8tXysNlekCzHQIvNFM9zNGG8Kh+5Bb
         OwuMZR9mGWGdI0/AqdkLWmLUl5xZn1ZDRQfKPJ7eLQ1IE3JlATFB0SEvhU10Fe272btl
         jc9nzpSKoAIFtHJozfb9i/aazhvtDbC4U63ruCztgkEE+BBA26qDw7zm+X9NsnFqjAPU
         83sA==
X-Gm-Message-State: AOAM5338d1oXhHOTQz+gRb2CpfhYS30qvjVTSf9k2D9navtt5qDFqo8U
        4QkRRF04N/kKsmSP5U2Ts5KcPZzS6yQSpw==
X-Google-Smtp-Source: ABdhPJwIVZrxr35SsE1G4AWbBNIva8wHIolcCzX24wSDSMoCpkn4XlmvO3p/z8kUzDmn5s1Zf0oKZQ==
X-Received: by 2002:a05:6402:354d:: with SMTP id f13mr9726226edd.228.1617869155516;
        Thu, 08 Apr 2021 01:05:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t15sm17342935edw.84.2021.04.08.01.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 01:05:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Suppress library warnings during unit test
Date:   Thu,  8 Apr 2021 11:05:53 +0300
Message-Id: <20210408080553.3129648-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Implemented dummy tep_vwarning() function to suppress warnings from the
trace libraries during the unit test.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/trace-utest.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index 58d4d4e..ee11826 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -19,6 +19,11 @@ enum unit_tests {
 	RUN_ALL		= 0xFFFF
 };
 
+int tep_vwarning(const char *name, const char *fmt, va_list ap)
+{
+	return 0;
+}
+
 static void print_help(char **argv)
 {
 	printf("Usage: %s [OPTIONS]\n", basename(argv[0]));
-- 
2.30.2

