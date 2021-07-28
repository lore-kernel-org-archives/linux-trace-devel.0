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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22217C43214
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1120260D07
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbhG1NdX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbhG1NdW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:22 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC087C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:20 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id go31so4627770ejc.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ruQSmr4A+7GM4NyUiPKklpLP/hiISS6lwTBwiyDaCvA=;
        b=bGOciN+hSd+67JuQ7UOC0NfnRLOxQADU2tNPpoZl/zh8rZdzIYywphmANrJDQHdrEX
         avdcu+R2xVxEVP0AwKzY0ipk6UZsD03G8c0RNO//1fMmbBui92YvbTGfIK3fSlG61xKA
         EqB84cBW07onFCl60Yr67KFuXHjrU1ICnr9xG5lqhSGcE4trA//O+XQtka9Sr9icm2w+
         Kyt3Ws8dNy0ZhdmoSqCQuW3CbX2RGv0h0zXHnpEE7KLAswzdKe85Z1TqczKzuzYkFbUQ
         DmM2twd5fvZ+GuNROt7We8ItRhhz9EBWmvy3w30iJKGZPYlvB9VFRuJvWyHqBbxFtqe2
         RlNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ruQSmr4A+7GM4NyUiPKklpLP/hiISS6lwTBwiyDaCvA=;
        b=aC949iK16Hr0kccQXV9DeMrwMi0GRkz4tFK3/8BzTsNaKlIE0ineldDkT/CIE2ncqO
         MJ/VpLCxqPh/mjd/9r6vaCeVg9f3KagRi7YWmaRhfvzkRp6R8GGS4aGo7AnNLZ5kn6a2
         AG+emPzrzPICXN3TNnHdLZMld+VYmU6/eXBfuNIaetpBvWnx6WXOaLakAncvCficJ9gM
         hS2ygPKNOkjol8l7QVc6WCgj8cIhBaLcJ0mHIiXVL/J3IYsypmisPHiUbGZ9sKMDpdhi
         c0mPrkZ5QdtAUZ0Ck0thY8HVdspj1a2jbooKRUwwGe79Xx8pLpASl61jkxuuR3/EtCYu
         E2Dw==
X-Gm-Message-State: AOAM5325vhEobCeqcoUc5OJAEypTGzAG8cvgmCXVG5S76eG3FQepVwiW
        3wzoKwwXeFDs691m/b+uF5A=
X-Google-Smtp-Source: ABdhPJxBUyPXHAeO31o6NHwDoPnm7WCb6jM/HvJ0I/LhHhdOJ2sBKcBUQjJfiP6rfG0V6mlaeNQ/iQ==
X-Received: by 2002:a17:907:75d2:: with SMTP id jl18mr26591781ejc.238.1627479199256;
        Wed, 28 Jul 2021 06:33:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 27/87] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Wed, 28 Jul 2021 16:31:50 +0300
Message-Id: <20210728133250.234140-28-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Writing CPU count as a separate section in the trace file is redundant,
as there is already an option for that. Use that option in trace files
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 7613dc22..b7b7eb06 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1633,10 +1633,16 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 				 handle->file_state);
 		return -1;
 	}
-	cpus = convert_endian_4(handle, cpus);
-	ret = do_write_check(handle, &cpus, 4);
-	if (ret < 0)
-		return ret;
+
+	if (handle->file_version < 7) {
+		cpus = convert_endian_4(handle, cpus);
+		ret = do_write_check(handle, &cpus, 4);
+		if (ret < 0)
+			return ret;
+	} else {
+		tracecmd_add_option(handle, TRACECMD_OPTION_CPUCOUNT, sizeof(int), &cpus);
+	}
+
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 	return 0;
 }
-- 
2.31.1

