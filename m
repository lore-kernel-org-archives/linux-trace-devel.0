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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E0BC433E2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF7276193A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhC2M7A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 08:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbhC2M6a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 08:58:30 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF52C061756
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:29 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id e14so19248826ejz.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NBH/q24YI2F1BzXYwy8rKR+joOw2u2aDBJdvfM4xY8Y=;
        b=RufbENARZmC/xPIoCfnJm718zeWLcHGl1twXMtX8ohFE9HciH9cyJUSGF3hbJU340d
         aqyRgjqyu8JMJMIIGw8Gmk8vB5Ihj8KfqGuvvzacnHJ+MarjD7zObj3G/wLTZJ9RWvQT
         nBtG+xMU1WBtQ4N9pSnwpay5MG7ZPdKOFs7XEAPfO/TL85+x909H6Jnn//Se59uJNp8o
         URSd4OYWA62803m/H3e9wCRp2BpEGCIozyZ+aA2IsMXGgrSEEtWA47UcAEoTylwmv/U/
         FUQH0z2BZIDphJ0okb798+FcD8Hg7VwywUKtI0q3zA2cTXS/P/hc4cMDnaBaTzOe1IG3
         F9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBH/q24YI2F1BzXYwy8rKR+joOw2u2aDBJdvfM4xY8Y=;
        b=NtLo1HZSpg3HPOVJsRLtRNtTv1V1MGGyJUrRUKO+4ta4Sp//fB7OwKBcXKYHtn7F4a
         OokrLWpIMpyYYQrOZswUtpcus6J48J2WnlceidVkm1vzMalWMvBFUBZe7wbZTEtvAlHi
         PjhelF0yvFtzpD+jgwe4UUphX5ruqDoJ2akcKZps8et3cP15MVLaGbsc3FYyny1gApwe
         nJK+CrfEGZmEAzBTCfQnvxm9+bG4QPaNo631l1Rx4tASRlAo5HWkxb2vZMsHGOIZVDtT
         bUIC38OCw4yn17iueK/1u1v8kDprUzLX2pn0K0uieW9oxZwPiDMx2C97tdwSYL72D7ww
         2gNQ==
X-Gm-Message-State: AOAM530oL05lsxKwc4crvQhEa/+2LN5qGcaJPC+nzuKmOBSTR/pYxI/1
        u20QXs0YvyvlAcE09WB40A4=
X-Google-Smtp-Source: ABdhPJzKLCCaqIO620U7hF8GIgyfHQ73sOphTRx7F++c/tlvPDnwzZQNmFJKGiLdXMKOehtmEzK8ng==
X-Received: by 2002:a17:906:2795:: with SMTP id j21mr28363234ejc.283.1617022707786;
        Mon, 29 Mar 2021 05:58:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d19sm8909075edr.45.2021.03.29.05.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 05:58:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] trace-cmd: Document --raw-ts option
Date:   Mon, 29 Mar 2021 15:58:21 +0300
Message-Id: <20210329125821.97496-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329125821.97496-1-tz.stoyanov@gmail.com>
References: <20210329125821.97496-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented "trace-cmd report --raw-ts" option

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-report.1.txt | 3 +++
 tracecmd/trace-usage.c                         | 1 +
 2 files changed, 4 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index 766c9a57..72b47065 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -309,6 +309,9 @@ OPTIONS
      Make sure no timestamp goes backwards, and if it does, print out a warning
      message of the fact.
 
+*--raw-ts*::
+     Display raw timestamps, without any corrections.
+
 EXAMPLES
 --------
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 386e88fe..98247074 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -233,6 +233,7 @@ static struct usage_help usage_help[] = {
 		"                     previous data file, in which case it becomes default\n"
 		"          --ts-diff Show the delta timestamp between events.\n"
 		"          --ts-check Check to make sure no time stamp on any CPU goes backwards.\n"
+		"          --raw-ts Display raw timestamps, without any corrections.\n"
 	},
 	{
 		"stream",
-- 
2.30.2

