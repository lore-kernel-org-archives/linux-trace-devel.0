Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40FEC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C677320760
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HniD2N+z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgGBRuD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbgGBRuD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:50:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4110C08C5C1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Jul 2020 10:50:02 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f7so26516709wrw.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Jul 2020 10:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fXgHAINjmre3yMXwDPiFiHYy/aHkvIg3nUQGWVpojNE=;
        b=HniD2N+zQp+8bmGikZzOIrQlMM0NPcNjhn6b2jJtgw/+Cfvqu1PbaIuL+mllEkAILA
         1DTy1QsY0kLYdKLrY75uSZYhR08M69GdNkOPrYjltXk8M2u3KZ+AZaMxA53/Fi02gRAs
         ALlNB4/Ey5bOm5ODJhUw6LQGyFD5XsTN/ltUlSleLaBUruNCiASBrMAIqia+zARZUmPx
         4IdsRDphhd2Polf0R03EhpFxI0hXi2cxtPgBLXAMJPT1xJDietkzFq+r4HaponeyOFr5
         dCIeoMKd74a5KNW1RiGghF+cZtubxZWLIq3dmhdySffDfJp6HKE65SDCJ3/ndDsLAbe5
         3+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fXgHAINjmre3yMXwDPiFiHYy/aHkvIg3nUQGWVpojNE=;
        b=fNVBdnnUWbRlMABJPvkJUiWAaClJgK2u0SgrKRlYmqKBAUgPB92jWV4pyrTRqvyoiK
         7WhrSZ/o6CAHSJVK7BvejmSXMq2EEy2j9YJPKiDc7q8hrd6hb0u5i0ITH8usYoglTdLr
         hIdpBvbPZPIvsMhC4xrp6v9vHg0BGq1zzdt88oeUOvLIwi47Ik1pioVOYEvLfKlEiWZS
         zY437RnkfFsiobvijTqZ/k0q9t4G2S9BhTXUA98Ul9+2cHCey9z/IT7jKUP/n+AVV9VU
         xOlGg2ywvz7zlHcnHKZMarbau2XBAFdAgflQTvgJRgO4L4cd/J6DYB5avuzunhZ7gCAf
         drcQ==
X-Gm-Message-State: AOAM530iTF8ywr7rrTMAYcH/LU2bN2OyOHvB3kTmsE5XOdORrsPLfEdK
        lQO7E+F5P6FiFO18F8llN40=
X-Google-Smtp-Source: ABdhPJxpSpq4uk+X6y3LcRmkljZ/cLXOTLHmbjK3GTq4NsGhP/z+Ok6hwSwmJH4djZXRVgtmAZAdHA==
X-Received: by 2002:a5d:6809:: with SMTP id w9mr34902007wru.182.1593712201725;
        Thu, 02 Jul 2020 10:50:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g82sm9289319wma.37.2020.07.02.10.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:50:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 15/15] tools lib traceevent: Fix reporting of unknown SVM exit reasons
Date:   Thu,  2 Jul 2020 20:49:50 +0300
Message-Id: <20200702174950.123454-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702174950.123454-1-tz.stoyanov@gmail.com>
References: <20200702174950.123454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

On AMD, exist code -1 is also a possible value, but we use it for
terminating the list of known exit reasons. This leads to EXIT_ERR
being reported for unkown ones. Fix this by using an NULL string
pointer as terminal.

Link: http://lkml.kernel.org/r/5741D817.3070902@web.de

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/plugins/plugin_kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/plugins/plugin_kvm.c b/tools/lib/traceevent/plugins/plugin_kvm.c
index de76a1e79d9e..51ceeb9147eb 100644
--- a/tools/lib/traceevent/plugins/plugin_kvm.c
+++ b/tools/lib/traceevent/plugins/plugin_kvm.c
@@ -245,7 +245,7 @@ static const char *find_exit_reason(unsigned isa, int val)
 		}
 	if (!strings)
 		return "UNKNOWN-ISA";
-	for (i = 0; strings[i].val >= 0; i++)
+	for (i = 0; strings[i].str; i++)
 		if (strings[i].val == val)
 			break;
 
-- 
2.26.2

