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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4094C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA7164EA9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhBARZu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhBARZn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:43 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CCCC0617A7
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:26 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id p20so6260319ejb.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=77/C7IL9bwjDIfN6W1HD95rM7DeBqtf9m1fmX4fHhKw=;
        b=XwMvJZh6GQ55s7pcMUUbw0I8PDoRmnN9TiibXKlwNBgpVvLBpB9ieHsj+MFFL98QgY
         AWzYkffD+qwIExo3G0ncqcfE/knSJbCD/W1KB78IlWKR9AuFNpX2njViZx2iQsv6ywe3
         xTbCN35FkZF093IRZA+PXxa+KDnopVMF7CUxUBvLvO1bxup/lDnX7s5BNdEchrjBrvRs
         T6MHa3QduxxrxmVph1Ej/ZZSBRNdiB402y/19SJ6H/HnnUiM9rSZC5nYxzhgJB4Eh2Zk
         Aga6z8nLskz2BVZtcTUqSFn/uN0jNu0FC1NXJPa32PpST+lUKOICT2WfIT8bE6YmNDLf
         D5qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=77/C7IL9bwjDIfN6W1HD95rM7DeBqtf9m1fmX4fHhKw=;
        b=OODV3/4cObHrMimvSXjXQLVKmq3pEu5HTOHlAHkslnpWJMMWRJ0EF3YMxwoxV6rs+Z
         +pAPpfaAeEfwZcgwHb22uSzNv5vUNE6JoD78fMoKvLceH9FPhXAKJ2cro7haGgxj7ZDX
         ndke+Gf7Kr5nbGcERcykUTU26r/7iLysWUX362Uy8CKdS9WyaoxpixZSyABjeDA2FHix
         3D55zLff4UIJYGfn3wgsbangihXTOr5r6TuJwurQx1ANdTeSS+fDh3bWfwJTK+/J2LE9
         1x7PzviipnNevdYLWskf6/vnwX0BWsZpJvQUM5eqfFBB2GUWegcK9sg1zJ2ARRARoL+m
         JQag==
X-Gm-Message-State: AOAM5317OhtW0nkmSvnMmr9X/Oa6oOKkLdgd9Lwaa9YfU7Wt5G2eREME
        sDmOk5eTzI7jbcdkntL1fHQ=
X-Google-Smtp-Source: ABdhPJxj1H9F47lBSy4STWUa4qR4OTfuD8lCJ+osOvbSYHtrkTshV83uDhRzSA/R3o1oe5IcDTOPHQ==
X-Received: by 2002:a17:906:8159:: with SMTP id z25mr3289476ejw.270.1612200264962;
        Mon, 01 Feb 2021 09:24:24 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:24 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 13/24] kernel-shark: Add new methods to KsPlot::Mark
Date:   Mon,  1 Feb 2021 19:23:47 +0200
Message-Id: <20210201172358.175407-14-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new "get" methods are needed by the logic of the GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.hpp | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index a9a5ba8..1725926 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -395,12 +395,24 @@ public:
 
 	void setY(int yA, int yB);
 
+	/** Get the Y coordinate of the Mark's CPU point. */
+	int cpuY() const {return _cpu.y();}
+
 	void setCPUY(int yCPU);
 
+	/** Is the CPU point visible. */
+	bool cpuIsVisible() const {return _cpu._visible;}
+
 	void setCPUVisible(bool v);
 
+	/** Get the Y coordinate of the Mark's Task point. */
+	int taskY() const {return _task.y();}
+
 	void setTaskY(int yTask);
 
+	/** Is the Task point visible. */
+	bool taskIsVisible() const {return _task._visible;}
+
 	void setTaskVisible(bool v);
 
 	/** If True, the Mark will be plotted as a dashed line. */
-- 
2.25.1

