Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251ABC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Nov 2022 16:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbiKRQVo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 11:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbiKRQVn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 11:21:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B9061772
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Nov 2022 08:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668788440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4/lZAnOXPkFaHnGFixuznrXc+fqvh+fQumPEYd2UgBU=;
        b=IIyGdZO8zmsQJLbXAxVeaZQbJ/Ktu6kyspmmnDtdTa3mPBSiHcoOsMQHXiig4qzuss4jLr
        5aO1gszgBB+3de0U3kJh5CJCCVQbmQMKvVPdNeIj+Q2kjN/+5edr/EtxO85SjXihgayFMq
        yEbWhqnDUT1Qng4EPlCvdGgbPQu6V9s=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-307-0XGXj-__MuaHBqEgstHidg-1; Fri, 18 Nov 2022 11:20:39 -0500
X-MC-Unique: 0XGXj-__MuaHBqEgstHidg-1
Received: by mail-ej1-f71.google.com with SMTP id hr21-20020a1709073f9500b007b29ccd1228so3287760ejc.16
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Nov 2022 08:20:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4/lZAnOXPkFaHnGFixuznrXc+fqvh+fQumPEYd2UgBU=;
        b=WJy8THH5zYMQbqItVVpv64iEBglHG0X3J37mxUWAooEccvQQin581OOy3/F7KzLm35
         noZuAX/dXGQtsSDvdOkd6s0/XkcUL4qDGYpJPX0UTeHoN3PATdgHIu6j/5hXfxY2M0lH
         iu6SmMiOSHO8/O3jF8HJAtdUr0q6LO9i6DG2tBft236fZIHSi6l43DXCCyPDFUzcVNXK
         m8qh1OQu5utJXTZq6tRqXhPep2av3C6rFExNMOQTyKvQHaF2Z4Yxpu3dxw2O3071Gwia
         CzpHlM8Y9rhK0cigUMQHL2Z4HCY3jBj89VQWSJhSkPxl+WYesr8b/8ddktF+riOI17mg
         msFw==
X-Gm-Message-State: ANoB5plLPkqaiVLm/2BIw39hpEVp6U7or7KBGTrSg8cb2mQD9Aa4yY4E
        RoBGgSzQvRERW9kbNVN/hAtPsnqAEz5mlXUbagkLUiD19VWNdrQboINx8yhS9Ic0bPMYrO3Hias
        Q2YkrJNO65/y6OfmNluwxyVkM0vhnKpsb7wssuBVbLAk/MVwGZOTZ9BtOnS8akwbCkdZEXYvXLJ
        yEfo2Ha6E=
X-Received: by 2002:a17:906:32c7:b0:7ad:934f:abc2 with SMTP id k7-20020a17090632c700b007ad934fabc2mr6130453ejk.690.1668788438035;
        Fri, 18 Nov 2022 08:20:38 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5dOX+eRhJ/tb1LGJakd/27nqemCeDsScZdWGz9DaDQ6/kxFzvAd9jSwpR23iR8HrH0NlpRhw==
X-Received: by 2002:a17:906:32c7:b0:7ad:934f:abc2 with SMTP id k7-20020a17090632c700b007ad934fabc2mr6130419ejk.690.1668788437651;
        Fri, 18 Nov 2022 08:20:37 -0800 (PST)
Received: from x1.hqhome163.com ([194.183.10.152])
        by smtp.googlemail.com with ESMTPSA id l19-20020aa7cad3000000b0045bd257b307sm1970007edt.22.2022.11.18.08.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 08:20:36 -0800 (PST)
From:   Alessandro Carminati <acarmina@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     alessandro.carminati@gmail.com, acarmina@redhat.com,
        bristot@kernel.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rv/monitors: Move monitor structure in rodata
Date:   Fri, 18 Nov 2022 17:20:33 +0100
Message-Id: <20221118162033.66389-1-acarmina@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It makes sense to move the important monitor structure into rodata to
prevent accidental structure modification.

Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
---
 kernel/trace/rv/monitors/wip/wip.h   | 2 +-
 kernel/trace/rv/monitors/wwnr/wwnr.h | 2 +-
 tools/verification/dot2/dot2c.py     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/rv/monitors/wip/wip.h b/kernel/trace/rv/monitors/wip/wip.h
index dacc37b62a2c..9c0cd0ad5cd7 100644
--- a/kernel/trace/rv/monitors/wip/wip.h
+++ b/kernel/trace/rv/monitors/wip/wip.h
@@ -27,7 +27,7 @@ struct automaton_wip {
 	bool final_states[state_max_wip];
 };
 
-static struct automaton_wip automaton_wip = {
+const static struct automaton_wip automaton_wip = {
 	.state_names = {
 		"preemptive",
 		"non_preemptive"
diff --git a/kernel/trace/rv/monitors/wwnr/wwnr.h b/kernel/trace/rv/monitors/wwnr/wwnr.h
index 118e576b91b4..57dfb1c46cb8 100644
--- a/kernel/trace/rv/monitors/wwnr/wwnr.h
+++ b/kernel/trace/rv/monitors/wwnr/wwnr.h
@@ -27,7 +27,7 @@ struct automaton_wwnr {
 	bool final_states[state_max_wwnr];
 };
 
-static struct automaton_wwnr automaton_wwnr = {
+const static struct automaton_wwnr automaton_wwnr = {
 	.state_names = {
 		"not_running",
 		"running"
diff --git a/tools/verification/dot2/dot2c.py b/tools/verification/dot2/dot2c.py
index be8a364a469b..512c7a11830f 100644
--- a/tools/verification/dot2/dot2c.py
+++ b/tools/verification/dot2/dot2c.py
@@ -111,7 +111,7 @@ class Dot2c(Automata):
 
     def format_aut_init_header(self):
         buff = []
-        buff.append("static struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
+        buff.append("const static struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
         return buff
 
     def __get_string_vector_per_line_content(self, buff):
-- 
2.31.1

