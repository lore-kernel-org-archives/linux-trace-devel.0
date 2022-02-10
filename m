Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93269C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 15:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243601AbiBJPX6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:23:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239865AbiBJPX5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:57 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5211AF01
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:58 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id i19so2253637wmq.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DaeDeIlvTR8pOfJDnV2woQKvIBUlLhgbH7bFxMwWYRc=;
        b=O5QOHdEO8PKGHpGKgJ9kYJwG3Nr+n212tQyPon/8ZGna/flt7izN5lUa+5WBzZc0ce
         QEsCBCu7dCx0gvVPi5jxARL7Vhq0MM/wStVMO1XZ/fC7C3KpWaBKRlSxXTa8pHwsrUnU
         ncdWYoRzwrWjjLpWHP4Kn7RTXzCLk/LCEolOq/vLbV/u/9DnFh+phZOX4Kl2aa3ebhXi
         HVkNfxQXcHtDu2WezagpIcdI9XqACncUOQ1ihjIE04DVduGw2aAYHURLs6c3uKxWtyLD
         Urya3WjVcqS5BXbqRsq62ntDMM7fcT2imlEygbv9WlmiR6wEE26lU/IHnwmSBsMTo3kt
         P+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DaeDeIlvTR8pOfJDnV2woQKvIBUlLhgbH7bFxMwWYRc=;
        b=QRO9ftfHyzsVnflfCK+AUHDsju8hdIDoNhV6hJnZXGrBp4TMN3GNu0NRBO9guTPVIo
         GroDoPIUEyw9rsNzUlGLaEj04nbcdmyhFBk/a3tE1b2Ap0w6OyKPzIl+x907hiz3IuZm
         d/lafMcHMOKG5ifx0mWH5Y84FuekyNAbE42Ae15Q8cDYMX9CSWjAlfSH4XoNwHsS89Jf
         O2YA4KEo/5PFHkpImpmvsxWDbvBjY5GRb96wyyv8HbpumIrj+SLJjCKH/iH12XSEoTXk
         +FyGqPSoa3ftR6EEupmocSThZ8n2W7c6MEgAC6Lldf9N2sNyjHjKcJJzSlJmtEIxo2dJ
         cv4Q==
X-Gm-Message-State: AOAM5339EbBCLl1CVx2F2TgxkQSUFJX2Ji0u79PNXJZjHr/L4UmTlM01
        iEGEhm4jRESCJG7mTFXi0M3CHA4XGbA=
X-Google-Smtp-Source: ABdhPJyiFGnOfazjrDOWwB1sZ5Y3iIwDKMg3Uw0Qu+DXCXm32+hGMyfK4TUD5j3P4OjgGF06rP4sHA==
X-Received: by 2002:a05:600c:2143:: with SMTP id v3mr2553640wml.81.1644506636409;
        Thu, 10 Feb 2022 07:23:56 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j15sm2245301wmq.19.2022.02.10.07.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:23:56 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/8] trace-cruncher: Code cleanup in the constructor of tc_synth
Date:   Thu, 10 Feb 2022 17:23:35 +0200
Message-Id: <20220210152339.363943-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210152339.363943-1-y.karadz@gmail.com>
References: <20220210152339.363943-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

No functional changes are introduced. Just simplifying the code and
making it have more pythonic style.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 6db426e..67e020f 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -331,24 +331,16 @@ class tc_synth(tc_event):
                               end_match=end_event['match'],
                               match_name=match_name)
 
-        start_fields = end_fields = []
-
-        if 'fields' in start_event:
-            start_fields = start_event['fields']
-
-        start_field_names = [None] * len(start_fields)
-        if 'field_names' in start_event:
-            start_field_names = start_event['field_names']
+        start_fields = ([], start_event['fields'])['fields' in start_event]
+        start_field_names = ([None] * len(start_fields),
+                             start_event['field_names'])['field_names' in start_event]
 
         self.synth.add_start_fields(fields=start_fields,
                                     names=start_field_names)
 
-        if 'fields' in end_event:
-            end_fields = end_event['fields']
-
-        end_field_names = [None] * len(end_fields)
-        if 'field_names' in end_event:
-            end_field_names = end_event['field_names']
+        end_fields = ([], end_event['fields'])['fields' in end_event]
+        end_field_names = ([None] * len(end_fields),
+                           end_event['field_names'])['field_names' in end_event]
 
         self.synth.add_end_fields(fields=end_fields,
                                   names=end_field_names)
-- 
2.32.0

