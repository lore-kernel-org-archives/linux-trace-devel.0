Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288E7C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05FD161216
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhIQPYj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 11:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344241AbhIQPYY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 11:24:24 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D3FC0613A8
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 08:21:51 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id j13so31381323edv.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 08:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qdRP+S5joetPVUch9/SeJ+zgj23hWt4gtcuRnFZANnY=;
        b=Yy76MAmFbH86LGAjWgHE0rRMwE6b7PCd3bT12Kn0ifmfCCeM9nV+dC9k9JSpo+b52W
         9/5SQVuc+eRiCvtZJDvyKxx5gCOHozFmb/KKpWuQxdgfRu7rcDh+nGDx4LkiKdVfdjQy
         xZ2j+1GIzRzHbAcrzTovc+0+tynDqx0SoC4pcuxOqX5wNwauPlj64TtjvWNnoohZMS/e
         EGaRa56aSHUF1baBUeegH5mUkb/FMtSamqlSL2nhErFoEg2oBbLTb9H/K0QIqk7M0bBJ
         x5xfaWX/cu20QbyAcwwrH9V1IjBeXVQ2OX8PiJFV8LM3gzX6qKiJumdRj8njObwu183z
         YwOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qdRP+S5joetPVUch9/SeJ+zgj23hWt4gtcuRnFZANnY=;
        b=2u8RygYBkI1rukyMC8EiJLRF22w9OjwAs2BSoY+a1q+X+J7EhDLKsFod1npSTWv1BK
         LV5yC62HuXtqwP6TqDoWsh/Ev27zC3DetJL8GfWsre0VIIqR8oWOwdfdkWrQ6LYOBv6V
         ZFuEdruLNFhRbkxvWiuI2qCcF2mbo1GB/JBI+QUlaakZfpgdXV113VMHC/wrd1ow8LMD
         LHqsaQB0a5eGhqlk2Py0xvwYH1J+QHVEWD9LJ8Q9DbIOnRZyq1tHO5PTMiuFuc+aJMan
         gq9qGBlandWrhBAcNrzuDUo5HFjYkqBpLKlp0+53Ztb+0xZdZRcHzsV6HWH86ubf6n9w
         UKPg==
X-Gm-Message-State: AOAM533qsep5TyFwSu8DAfOO/5IS29xRioVWvik1E1gnXLWBfATAoiQi
        aBbf+slAixSyAQYrMO+WH9J8U2BCT3E=
X-Google-Smtp-Source: ABdhPJyQUhP7SIgjcZzlO7VA4Q5UTEczcD89WfhAv3CVWlwxswpNHBMjKoZeN1tDUzQWpgJqbV+5Mw==
X-Received: by 2002:a05:6402:445:: with SMTP id p5mr12971526edw.208.1631892109960;
        Fri, 17 Sep 2021 08:21:49 -0700 (PDT)
Received: from crow.. ([95.87.199.246])
        by smtp.gmail.com with ESMTPSA id p19sm2407464ejo.81.2021.09.17.08.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 08:21:49 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Fix get_comm_from_pid()
Date:   Fri, 17 Sep 2021 18:21:38 +0300
Message-Id: <20210917152139.574350-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make sure that the buffer string is properly initialized and that
the new line at the end is removed.

Fixes: defe053 (trace-cruncher: Add generic methods for printing)
SignedFixes: -off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 58f543a..7b1ff1b 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -384,10 +384,16 @@ static bool init_print_seq(void)
 	return true;
 }
 
+static inline void trim_new_line(char *val)
+{
+	if (val[strlen(val) - 1] == '\n')
+		val[strlen(val) - 1] = '\0';
+}
+
 static char *get_comm_from_pid(int pid)
 {
 	char *comm_file, *comm = NULL;
-	char buff[PATH_MAX];
+	char buff[PATH_MAX] = {0};
 	int fd, r;
 
 	if (asprintf(&comm_file, "/proc/%i/comm", pid) <= 0) {
@@ -409,6 +415,7 @@ static char *get_comm_from_pid(int pid)
 	if (r <= 0)
 		return NULL;
 
+	trim_new_line(buff);
 	comm = strdup(buff);
 	if (!comm)
 		MEM_ERROR;
@@ -654,11 +661,6 @@ static int read_from_file(struct tracefs_instance *instance,
 	return size;
 }
 
-static inline void trim_new_line(char *val)
-{
-	val[strlen(val) - 1] = '\0';
-}
-
 static bool write_to_file_and_check(struct tracefs_instance *instance,
 				    const char *file,
 				    const char *val)
-- 
2.30.2

