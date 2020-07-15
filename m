Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77407C433E3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 553A42070E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rmykWWkG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgGOCaS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgGOCaS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:30:18 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2B0C061794
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:17 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y10so580737eje.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2QU+HLFlO8+nysBQDHQpB52tLg2EAJkPPWRtC4jBvuQ=;
        b=rmykWWkGK7AjH+m76DfCLoyFuph8tnGy7kKOAZ3yZcQLQtfkz3DU1Q7SYjogTvtkEt
         VjlyXO9Vj6KFcP8EKpP969X+/CLaVfIkGixV0SrS68vVyyTMepNyVXxOppPMCsIz4JRn
         ZIROP1jsUCVzhUfrz8qXCjCD6MwkKdUStY5rXyF4z6oDdn6tkGhb+sk1wNS9L+G9XTJB
         cSiRLLpW0DJrJIkgW++P8py5x3x5EDJkBm2eEmyGLI3Pfg/0MvajDg+m29N+5i5W8ulq
         fFk2E/mqFoC5WRpDboIj/8VvT2HGKHwQ+cV3/aZuoRDiLFyt2ytA6IXLt6H/r7+SMc+b
         UUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2QU+HLFlO8+nysBQDHQpB52tLg2EAJkPPWRtC4jBvuQ=;
        b=nAQm8QFiwENFPbLdekmqjdreCWIEdpGDy6u47/eX7Vf+L+bpbqPAc9xjHN5TNwNoUd
         ZoPX2w3lKpcQNT40JaWBvK9VA16LcZT76O/vL76aoRpPFQfVPBfVqDD1UhPgeMLqpl/3
         EFRZkB2BFUSc4rOaXWYKIs3TG8TcP2+r8r5Xjc1QuTpxHWuxAi6kZYvbQNlQHGy5BzII
         KfXJOy1L/VeSAS39WCVRK2Wg+9xMr4++1VNs6nn8RmiQAw8KBT0g9OBpPxYiVsYBlrLR
         O4Fn21YJ3TlC5N3FjGvSin+4eBnOd68EWiHyDqoYsg/PMucliqfhqOGKvicZcJkUs3pK
         iIBA==
X-Gm-Message-State: AOAM5316F1frT4W3BjCrB2NFdyVPzRV5vfpEb7uqZPJF2V7Nr2Fm08hb
        hooHSuLOAgmcNSlXNGIollw=
X-Google-Smtp-Source: ABdhPJywZ9F1Zwk7V44Qrldkh45UhteOI/YwxTfLEbi7witeuPJVRyubJFKzaYd0rj7lIXqDMKIqJA==
X-Received: by 2002:a17:906:c30b:: with SMTP id s11mr7452724ejz.263.1594780216473;
        Tue, 14 Jul 2020 19:30:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d24sm576474edp.83.2020.07.14.19.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 19:30:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH v2 3/8] trace-cmd libtraceevent: Fix typo in tep_plugin_add_option() description
Date:   Wed, 15 Jul 2020 05:30:04 +0300
Message-Id: <20200715023009.2503879-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A typo "optiona" -> "optional" is fixed in description of
tep_plugin_add_option() API.

Link: https://lore.kernel.org/linux-trace-devel/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com/T/#u
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index b97d0c7e..03f26c8c 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -310,7 +310,7 @@ static int process_option(const char *plugin, const char *option, const char *va
 /**
  * tep_plugin_add_option - add an option/val pair to set plugin options
  * @name: The name of the option (format: <plugin>:<option> or just <option>)
- * @val: (optiona) the value for the option
+ * @val: (optional) the value for the option
  *
  * Modify a plugin option. If @val is given than the value of the option
  * is set (note, some options just take a boolean, so @val must be either
-- 
2.26.2

