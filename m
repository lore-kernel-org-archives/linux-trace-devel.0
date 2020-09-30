Return-Path: <SRS0=+svU=DH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29681C4727F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 15:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E28DA21531
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 15:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BsJYkKKF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgI3PIM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbgI3PIL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 11:08:11 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BDEC0613D0
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Sep 2020 08:08:11 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e2so2172124wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Sep 2020 08:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uYb2qQ/Gph+j6YD4dlLENswYbanXRiluH5G23HU+5Mg=;
        b=BsJYkKKFq8/XOXNamP7Y0e53HiCfO10EIUyTAts72VFC3Dnb4saXFQNIHGJ25fNwA5
         eDvQ9nbCl4q+KcrMkYPavs7L3dId6UQ7DurHs05eyw5Uh0eMwCu3Mgh5s31vNjqcjDaP
         9Pjyk+ZX7exvaXGlAGuQ8VQkCTzBnDXqqN7lD89COh+2a0nBF+RDniTslGdxIUjWOuUa
         kGkSyj/qvWQGbUjH73AQTr81T2E0MP6IH+EUrhjzDnWG7vXIDksrJl+yDjwc4XLqL2rJ
         +uHNSqdr4qtoWdzPC+ufqKcfS/oA1giG9RLnfTTbxWIY4NmB2Fb8eacjb1q1731kMoga
         Sl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uYb2qQ/Gph+j6YD4dlLENswYbanXRiluH5G23HU+5Mg=;
        b=MxVu92hrHcDO9TwxjeRO437mLlxZx6rVPNwuUB706L2NnUhRoBwcStWYra/4iQQZW4
         +ZqhaVeqAt3EY2JCmzuqfiDhOT4FQgxvA+nYKUhkb2+Vojn1wgppiQfyOiBaoE1fQMU7
         dgOFGV2bkLWNbLw/BnHTyVQ4JkaQSZhjcMTOfVARbjTW9jCEyMTGjvYcDn5eddd3B9Q5
         VIAsn2OS3Y1EYuX5AnYwQVfJDe1rWQ29uS9l8ZqmM/QQIj/ks+oMDmCo19RAKpFT+ziP
         zPceYImgNAX5Bt3AXCBOU+nsTHzT2jLjH8YclR0KNoYBBKU28M2IWKTgTTmu/pBDBapv
         bZ/A==
X-Gm-Message-State: AOAM533VmTahQeVVEu372qj/J7rfJqXdAGfJ9CE1SZZC/WmAwFdw8g6P
        SDIhVqz/fiGEjlt6neX1nZ0crA1Lyqs=
X-Google-Smtp-Source: ABdhPJyCHOxXf1P0vQf0Soobp5yetVwOkBaCRXxnYsB19AGcl0qrP3tZiti7Htva8TWlqBX3mJABMQ==
X-Received: by 2002:a1c:a987:: with SMTP id s129mr3453315wme.38.1601478490295;
        Wed, 30 Sep 2020 08:08:10 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id k4sm3613486wrx.51.2020.09.30.08.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 08:08:09 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/3] kernel-shark: Fix symbol resolving during linking
Date:   Wed, 30 Sep 2020 18:07:41 +0300
Message-Id: <20200930150741.224779-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200930150741.224779-1-y.karadz@gmail.com>
References: <20200930150741.224779-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtraceevent is the basic library. libtracefs depends on libtraceevent
and libtracecmd depends on both libtracefs and libtraceevent. Having
this in mind, we need to properly order those 3 libraries when linking
the basic library of the KernelShark API (libkshark).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 9666b18..457c100 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -7,9 +7,9 @@ add_library(kshark SHARED libkshark.c
                           libkshark-configio.c
                           libkshark-collection.c)
 
-target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
-                             ${TRACECMD_LIBRARY}
+target_link_libraries(kshark ${TRACECMD_LIBRARY}
                              ${TRACEFS_LIBRARY}
+                             ${TRACEEVENT_LIBRARY}
                              ${JSONC_LIBRARY}
                              ${CMAKE_DL_LIBS})
 
@@ -67,11 +67,8 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     target_link_libraries(kshark-gui kshark-plot
                                      Qt5::Widgets
-                                     Qt5::Network
-                                     ${TRACEEVENT_LIBRARY}
-                                     ${TRACECMD_LIBRARY}
-                                     ${TRACEFS_LIBRARY}
-                                     ${CMAKE_DL_LIBS})
+                                     Qt5::Network)
+
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
-- 
2.25.1

