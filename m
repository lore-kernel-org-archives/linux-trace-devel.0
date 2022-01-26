Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FEEC2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiAZJxs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJxr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:47 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D064FC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:46 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id u24so22129210eds.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wtWPxN8Oue3QBL5BElSqeBvbJ4M85cZaC43Yh6M+LUA=;
        b=cLqUiQuvBDewWI7Nm6RZ8yXAED/LVV6MhseVx8LGyk0ccldzpACjgcDCLKgRu9xkid
         ZfrK8jTtPtBhd6YrByiEbYvC/3QLszMWWH6JqFibSRza7/zIFMfiHCy906Tsg3DGHXzJ
         fP31QpGxVyWltvSs+ZLkiGeZcGxucZk7LV2SCDLmdLTh3Jm8prqp9XTT0lPrbf/q/KPw
         B9sCgTlYIEtSeZD6F+2pbrt7J6ycEfpDfGRyNYLRmE8G/+6OvqZp/t/ra/SdTOpwlJyb
         N1wbMhbQ+tgPzLZcKRK2xG302hSAdpgSChjtCYH3uKC9VHoDNsgsnc933NGzFObIthcg
         T9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wtWPxN8Oue3QBL5BElSqeBvbJ4M85cZaC43Yh6M+LUA=;
        b=ao8EttrQTWfnRoL5wYq8GMtQhYwe8kvAm0bV9vzCk58jBaY51nVYbCrcOU4udhw4Bg
         m72nDyn1awZiCJlwmrYISIXbCLgt4d5oj7sNah/j8ZESiXrVG8F/fzX042koE08RnOF8
         mYVeOQMm6oUFDv+KDf6QVwf4d/T9h9VSNL4RvRKvGwyJoUZVeC7K1yZun4kJUNlqb1cm
         BR+emwnBlC7WMgflfTIpzi9nAPqcSLGkhiqM7T+OlCCmrKlh/zTLpEPDwB/fEU/Xt+I4
         6wVLtib/PgS36HqRrWp1s7fUfxlzXVhxxEk0mPWoW/fYM7GTbKsNdpYky9LjyIdHN927
         W9sA==
X-Gm-Message-State: AOAM531N3yc2WWSY1Gz5yogyA3m3WyEy1NpSCdjtrAie/+Yq/DmM2GK0
        tzPDFqpO+ZEnVHXUpGE01r4=
X-Google-Smtp-Source: ABdhPJx3fe7PrhgLHCBZKLUdUu1B3XxP4DN245BEgqyl/kDRzjFjjoG9X4Qhx60xLnaSiot4tjEOsQ==
X-Received: by 2002:aa7:d3c2:: with SMTP id o2mr24707074edr.207.1643190825402;
        Wed, 26 Jan 2022 01:53:45 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:44 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 03/11] trace-cmd dump: Add helpers for processing trace file sections
Date:   Wed, 26 Jan 2022 11:53:29 +0200
Message-Id: <20220126095337.570867-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095337.570867-1-tz.stoyanov@gmail.com>
References: <20220126095337.570867-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new local database for storing sections, found in trace file
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 6dad0fef..c4ad6c5b 100644
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
@@ -773,6 +783,17 @@ static void dump_therest(int fd)
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
@@ -798,7 +819,7 @@ static void dump_file(const char *file)
 	dump_cmdlines(fd);
 	dump_cpus_count(fd);
 	dump_therest(fd);
-
+	free_sections();
 	tep_free(tep);
 	tep = NULL;
 	close(fd);
-- 
2.34.1

