Return-Path: <SRS0=eJz3=7Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7732BC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jun 2020 12:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5805720678
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jun 2020 12:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2hww1H9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgFCMPS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jun 2020 08:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgFCMPQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jun 2020 08:15:16 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD33C08C5C0
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Jun 2020 05:15:16 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id c3so2084819wru.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jun 2020 05:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=htfbpX7ynYv/JgvVIRP+eb8rrLa2+6NzfEu12G4x1ns=;
        b=G2hww1H9H4GJtBMXhCGldlCeULhyX1Qit7HaYF9MlMuFkNBwS8ABLsbuCt8atENfYA
         518yBklaJM6wVXYIfU4wO86oZxMDCPLfJYKGxwQul0glpbIwtNy1L3xXtHGUzwmvAdbZ
         I87JIJuooIhxF/Y6hGosytIb/KVLBTMjV6p4AoCZwlgcFTygbWe8OzJaTdEugbFM4l7m
         Ahr55PNii6Tkp/INhEwE8onjHL3rbDMMvS6zqrIzEWmz8HzoQ7glOJSEAgmdR0JKvfSU
         Je4zNh6J4Z2jfihpVQSc21hoGnRoNHUiGYG/5EoDC4xtuKdUzEEOUYMqcbMmeAlk4m2m
         dPng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=htfbpX7ynYv/JgvVIRP+eb8rrLa2+6NzfEu12G4x1ns=;
        b=rS+KMj6OHqWWfZKg6NSaap74FVOt3yihqKXXS9bBaM/XwHHLxc+rKm/nchDMOUcUB5
         gdvfHMguDTdqtq7xkBXfoelXZ4MP2j6iFNYJja9vhMTkwJjwDgeIQ73jB1LB1EISi9iB
         Wio4brjQvcBJ/3nnxi6y5mSvdjUqHQ3V9+JPt3ua1O3vkA7D2xENlHF1C9NKIc4U0BNA
         2z5J6dtQSVtVRN1eNXMHt69v/B5tjDv3jXPIjtds2lYLEOPHQSEUh26CAiSuGL70z+fs
         XeTk+YAgNvUhcdnuse1vptbgPgZE84PI3FeTZltMD0RVz+NkWYZoH9F9NPdQYM74huTJ
         l/xw==
X-Gm-Message-State: AOAM531Iw2HfoKgO5LAkJEQEfvpDNA4uf06sZwg8mjmPxU0kGqhgdFG5
        7k9yz9jnVsEIDkPJe6m3NEo=
X-Google-Smtp-Source: ABdhPJyEOtlG9go5/vBWXnyK9V+Xchu2oL4mugwJe2e4n7eFEuopTxcObOcYjW+6J0YwIPEi1pl6Kw==
X-Received: by 2002:a5d:5001:: with SMTP id e1mr33241628wrt.56.1591186514846;
        Wed, 03 Jun 2020 05:15:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm2657042wmg.38.2020.06.03.05.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 05:15:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 5/5] trace-cmd: Add description of "-G" option
Date:   Wed,  3 Jun 2020 15:15:06 +0300
Message-Id: <20200603121506.49992-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200603121506.49992-1-tz.stoyanov@gmail.com>
References: <20200603121506.49992-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented "trace-cmd record -G" option in man page and in
the usage output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-record.1.txt | 4 ++++
 tracecmd/trace-usage.c               | 1 +
 2 files changed, 5 insertions(+)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index f5ecad5c..99d1a156 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -312,6 +312,10 @@ OPTIONS
 
     See trace-cmd-profile(1) for more details and examples.
 
+*-G*::
+    Set interrupt (soft and hard) events as global (associated to CPU
+    instead of tasks). Only works for --profile.
+
 *-H* 'event-hooks'::
     Add custom event matching to connect any two events together. When not
     used with *--profile*, it will save the parameter and this will be
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 96647a1e..8036ac7b 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -53,6 +53,7 @@ static struct usage_help usage_help[] = {
 		"          --module filter module name\n"
 		"          --by-comm used with --profile, merge events for related comms\n"
 		"          --profile enable tracing options needed for report --profile\n"
+		"          -G when profiling, set soft and hard irqs as global\n"
 		"          --func-stack perform a stack trace for function tracer\n"
 		"             (use with caution)\n"
 		"          --max-graph-depth limit function_graph depth\n"
-- 
2.26.2

