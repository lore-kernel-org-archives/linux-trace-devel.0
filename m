Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F6EC0650F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDC012083B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wijpw8w9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfHNIrV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50414 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfHNIrV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so3841863wml.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WKJd7vwppU2A3MhUVsiKoIJntC1IGKSnIaai8zjmnpg=;
        b=Wijpw8w9gDzB09oCkMsQTXGuwoLBLBqu7OqpA6gtHIW4jUPIcmzDKW7ApmNysKJkbg
         MTE47zNYpcmFTrxR5MmG3sbqiuTeAVcVOQgP03rt3rR12UIQAmLVK1WWZMfTPqjd7mlE
         yl2a7Pxycx04YLqmZZMUEdAR5Eu0VkXCfHINJdo/YEa7OomBIXj/Cg92VguGE5Q7M1CD
         Cdnr4ttAdXy8Pz5Eci0elj56bWQ0nqkBNuzBE4/RmTyG+T/m4rgon4R6mn9wirXN6ijy
         kNOtU0TnisjRFXoP2zmW1YAE2qqcUmPDbBRBRM7NSKuzUoV+9igWRykkneZMD4RWXHuo
         1J2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WKJd7vwppU2A3MhUVsiKoIJntC1IGKSnIaai8zjmnpg=;
        b=c0lm+afEa4sFc1R7kdWd9K8dJ97OFIJ+Y0p/b5eJGDZFF3Ye3vl+U2E9xiIh6MeXpB
         A7QWvM1HAptFiHW7qboATAvgmB0B90DiUwGf4lUiQDMdufUZ/L4ee0Va7R2Pjf2Xxoo9
         h71Ep7fjWr/CJ6m4t3QrhWgrvBcjexCNCYMQaoli8rXon/OVRAZ4nT7x4fNq7r63kIlU
         kwjzGPyfOEswjTyE0N36Qez+btEkyrkqjax1zoVeCiTem6l/g5gFwgLNd6Dn0h/DIQhB
         eM4Imizn4+OjqVl4hw73aleyL2286vkW6S5h/MF45kST1l7mwpTwR2MzXytZMxEIPvBJ
         GtFw==
X-Gm-Message-State: APjAAAUVmYAaW2XlKB1nB+whgKOTH8JlgSpD+Ya9+JSmL6+VWbvawcOL
        gOKbX9xStwmJSWq/RG7ouNU=
X-Google-Smtp-Source: APXvYqzSgFkruHabqlq/eEq6ZZlEyYqA5S6rucNywDWNgYo5/GycZ8oexrzctB2oLzzRNG89AAjlwg==
X-Received: by 2002:a1c:9ec5:: with SMTP id h188mr2152692wme.176.1565772439145;
        Wed, 14 Aug 2019 01:47:19 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/8] trace-cmd: Move trace-msg.c into the library.
Date:   Wed, 14 Aug 2019 11:47:03 +0300
Message-Id: <20190814084712.28188-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Functions, implemented in trace-msg.c file, do not depend on
trace-cmd application context and can be used standalone.
The file is moved from trace-cmd to libtracecmd.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 {tracecmd/include => include/trace-cmd}/trace-msg.h | 0
 lib/trace-cmd/Makefile                              | 1 +
 {tracecmd => lib/trace-cmd}/trace-msg.c             | 0
 tracecmd/Makefile                                   | 1 -
 4 files changed, 1 insertion(+), 1 deletion(-)
 rename {tracecmd/include => include/trace-cmd}/trace-msg.h (100%)
 rename {tracecmd => lib/trace-cmd}/trace-msg.c (100%)

diff --git a/tracecmd/include/trace-msg.h b/include/trace-cmd/trace-msg.h
similarity index 100%
rename from tracecmd/include/trace-msg.h
rename to include/trace-cmd/trace-msg.h
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 0543b91..78875e4 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -14,6 +14,7 @@ OBJS += trace-output.o
 OBJS += trace-recorder.o
 OBJS += trace-util.o
 OBJS += trace-filter-hash.o
+OBJS += trace-msg.o
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/tracecmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
similarity index 100%
rename from tracecmd/trace-msg.c
rename to lib/trace-cmd/trace-msg.c
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 6968f83..d491aae 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -30,7 +30,6 @@ TRACE_CMD_OBJS += trace-check-events.o
 TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
-TRACE_CMD_OBJS += trace-msg.o
 
 ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
 
-- 
2.21.0

