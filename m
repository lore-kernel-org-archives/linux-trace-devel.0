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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D179C43216
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 580BC60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhG1NeJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbhG1NeI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:08 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEF4C0613C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:03 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hp25so4596778ejc.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zV0CqwA9/wXmtBv9QTZRvsjfkc0zh38RvP8876u1PMw=;
        b=uYpMLTyLuF3Zg0rJ8MyRPlSXumraHB8oBdwuRDETy32ROxEhMWcch4NFXaF+5HN39w
         tac7FO6RwdHle3xrjDhtYuiMiaw8B5LuCbT7wdJR1a2yhURfsh8SA5WfCoK8q+FBZHFW
         hVqRPp2fsGbz28BEEKPigqSzqWp/T4lnSUb+Se3AR5sB2ySChEn/wll5PL9MCjwoBsI+
         0DRkjot0LFgNxGjx/DEe/MBTUNEoJ2njOcQMNNSoCjPD7FOZ4GVEqztBfHtWHYZHypNk
         ziL8XVoGEcK1iPa3iVuzBMgUlQJGm9sSzkXCvlYBw5bVrqmSAjd/foNsAc+HBSuLDxF7
         jugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zV0CqwA9/wXmtBv9QTZRvsjfkc0zh38RvP8876u1PMw=;
        b=Re6ADAjqUgT3WeUUIoUrk1jUPNtY837/Nq8ng78o9pIUwIScDuOn05kPKn+Gg6yFJ2
         7e23jjROuScDHEdhKQ5AsYbc3OrMRSW/W+/5Y6NR2kUfov4ASOsb/Nv9+Ol6s6cH87+B
         3JNFXr2BHdc5AuqdDVRFFHCIFsy8XpG14L/FR2REgld9ACB8Toz28vKY3ZXEFZIY9Uw4
         t3pGk+WWuL+jscmzX439qRMNMPTn6RQP3PzkuxLXLYv8EzjbdrWQlll2av5n1U4nN1q8
         /M4oZllwHvq7UXqAaSUuGZqxes6Vz9BxtXkoBtndpUtM9XoIMY1rDc6zNa6BhDVcXlQc
         eSIg==
X-Gm-Message-State: AOAM533g61cN85wn9cCVXoBqlcOyc34YtspGZDFiGwsXbtOxzKxp9ddr
        ReoLnmxWLCVQZlbpF4zDIPRRTNEofYQmvA==
X-Google-Smtp-Source: ABdhPJzfUVvdh4YoeK78+rSYB3uwCgAU3ob+52mfW8pE07nZz9W4g1n1BgPjidQlb+98KyG2GQCOwQ==
X-Received: by 2002:a17:906:4103:: with SMTP id j3mr26775778ejk.526.1627479242619;
        Wed, 28 Jul 2021 06:34:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 64/87] trace-cmd dump: Add helpers for processing trace file sections
Date:   Wed, 28 Jul 2021 16:32:27 +0300
Message-Id: <20210728133250.234140-65-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new local databse for storing sections, found in trace file
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index e6f774bd..010a8188 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -43,8 +43,18 @@ enum dump_items {
 	OPTIONS		= (1 << 9),
 	FLYRECORD	= (1 << 10),
 	CLOCK		= (1 << 11),
+	SECTIONS	= (1 << 12),
 };
 
+struct file_section {
+	int id;
+	unsigned long long offset;
+	struct file_section *next;
+	enum dump_items verbosity;
+};
+
+static struct file_section *sections;
+
 enum dump_items verbosity;
 
 #define DUMP_CHECK(X) ((X) & verbosity)
@@ -723,6 +733,17 @@ static void dump_therest(int fd)
 	}
 }
 
+static void free_sections(void)
+{
+	struct file_section *del;
+
+	while (sections) {
+		del = sections;
+		sections = sections->next;
+		free(del);
+	}
+}
+
 static void dump_file(const char *file)
 {
 	int fd;
@@ -748,7 +769,7 @@ static void dump_file(const char *file)
 	dump_cmdlines(fd);
 	dump_cpus_count(fd);
 	dump_therest(fd);
-
+	free_sections();
 	tep_free(tep);
 	tep = NULL;
 	close(fd);
-- 
2.31.1

