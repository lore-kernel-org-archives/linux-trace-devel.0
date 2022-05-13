Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205BBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 May 2022 19:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357622AbiEMTlR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 15:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383913AbiEMTk4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 15:40:56 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD77C1707E
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 12:40:54 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so8676543pjq.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 12:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hNaej7mw9rDm6Hed0EC03uHvMwe880leTCze+kyK8NE=;
        b=BKjHpfbEzIIQSlT3oF723glpF+KU5Tub+sGd+2caerhFvaQzoffYdWYPW9dGB1ycOL
         J0s97DYWHY2GdYUFibxug7CVxSdCWQ0lXzaQ+bLjcbyVAP4ptdNtt7Nb43BZb+sJL82b
         nEtPWaiRfCGRlk1sfdfG0JunZhXJTScqPfWsIUyhVDlLLiJyzicI0Lmvm12e0Lhd3P2y
         3Plc8+xHfObbS2ro6Jh681Qb/VY37WvS7sq9EsvrRukASL6AhaChmnn+nd++PWC74gL7
         zQMkFeJOTf1vWuh/BPNFqGef3eSPod8tPw1j7HTuwXJvW19S5amHEIqDDk1/A/V10UuK
         6MBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=hNaej7mw9rDm6Hed0EC03uHvMwe880leTCze+kyK8NE=;
        b=24iYPSscylutU/Z+CaffXk/BNIhI01GjP9IlSi9erqTZy8C/M3lMO0fTHz7/m6iTms
         zbIxHLv7O2QEMN7CtGLMlIqvr65Z9ezMVbEy1U6BUnJs4JQYWlt/naxRrN/4BZlp4Cq0
         vK8oU9Osyd/KlvL31uupdsZv4CaflzGBKXdSISmhvRc1HpDyeoH8GWRoiw0hsTrvEkrv
         UMs9NXim9rMmUz54ybTE43fgP/PCxYlzBFvmKAp/IRjN/FiaONyhcqzLgVDdrbCgv4Gp
         AAS14CeeBqBe9e4NWFqRn2YznwCP2MTOMH2E9AZtjmOMEJMg+P2K9/+zy5eoM87WDfj5
         yitw==
X-Gm-Message-State: AOAM532Pr7sdrxqqQvxnDCqELbXKZ1rot2uXskIOAYhPapnPHy3m2WyB
        T4RsVoyx/S3n6obcZW5nTvz4/Ql3geo=
X-Google-Smtp-Source: ABdhPJxYIqAvHqw58dlJZ1hW9mKDJYpdqtmnK8iqdRgz95wGtBv2rNMS8tABf2bq00dO22touh/QpA==
X-Received: by 2002:a17:90b:3782:b0:1de:d04c:c934 with SMTP id mz2-20020a17090b378200b001ded04cc934mr6327246pjb.213.1652470854012;
        Fri, 13 May 2022 12:40:54 -0700 (PDT)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4f80:4210:966:88b7:2eeb:676d])
        by smtp.gmail.com with ESMTPSA id t10-20020a17090b018a00b001cd4989fecbsm3949870pjs.23.2022.05.13.12.40.50
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 12:40:50 -0700 (PDT)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtraceevent: Check type string length in eval_type_str()
Date:   Fri, 13 May 2022 12:40:48 -0700
Message-Id: <20220513194048.476326-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The pointer type check unconditionally accesses len - 2 and it could
be a problem when the given type string broken or malicious.  Also the
shortest supported type length is 2 (s8 and u8).  So let's check the
length first to prevent invalid access.

Actually this was found in a fuzzer test.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 src/event-parse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index f862f49..e4b337c 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2437,6 +2437,10 @@ eval_type_str(unsigned long long val, const char *type, int pointer)
 	int len;
 
 	len = strlen(type);
+	if (len < 2) {
+		do_warning("invalid type: %s", type);
+		return val;
+	}
 
 	if (pointer) {
 
-- 
2.36.0.550.gb090851708-goog

