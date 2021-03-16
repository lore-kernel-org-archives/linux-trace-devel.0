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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE71C433E9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 17:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0ED56512C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 17:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhCPRjy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 13:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbhCPRjo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 13:39:44 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F987C061756
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Mar 2021 10:39:43 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id a18so10897029wrc.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Mar 2021 10:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4H9q+iXjlXfW0gWSEa13+4A7UFWUDS1+n+dDaO1xfPg=;
        b=iqS+gDoLQDmWGYD7RFk2jelaKAYdlbrCo3oIK3ongnN1xlsFn1VIFuzctFnhfPtJKz
         RnzKwMiHt4KEx+60Tt7zs89DjSeCsc9Ds70TLsYGGNI682rj/g5kWgm0pIPkhshPUDX4
         jkjorFghUZQpGb2KnmRqWetaRX27PB3UnDGls6jTMMQZGcbMeNDEJo5gP0P29kQfR50m
         fWYK8N34qAFitnbCjRhmRnnVYJZX8iHaNtWTziynhqMZd27sTh78k1cBNZh2X2PQhGHg
         JNS0LbqSsCV+87JOJ3mSLUjSfn9hQj2AN/dIQYTyqTGxYLHP04LyCo4HZBGitKomBqkJ
         dhug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4H9q+iXjlXfW0gWSEa13+4A7UFWUDS1+n+dDaO1xfPg=;
        b=kMDfytpgSYggdQGa/YSgcwECs3jxy28y9jkNxKTiNXgqbVzicl/RqUJo6IBnLlt+1r
         3QA8uZzitXZeQfqJKMvMoRz3kKr574kuYUnvzNlZjzqczY7gsZ77dPD2U2h7eAxbwMsC
         TQOysq2pQY2ueRj/BN++xdXi+6oiWWriFc7Gc/CeUPXuvILb3qHuJb/RXQvFQSFfLmAn
         puoViuxroyzJRR36/Om/lNkGyHVNJZ/k9jwBC0JhQiBTGucggbsoxySVKmT0iWv01s5g
         1lBdlDIDPWdErHrRY9PfQirqJqBiiZfMuFRefCeoQDdo2v7zYsobcIuIUB8GA5qup7XY
         xjQQ==
X-Gm-Message-State: AOAM531UmLUYjsO/T26FenALfxooKYCM5gWVVEvn8P65w+6FQfdC906J
        3FRG+M/5kLSqZlU0W3tX420CtPYnCoP7hA==
X-Google-Smtp-Source: ABdhPJxufrYvUUV05FvKJJJAbAVfHo74M5auXAwlF5k5YIz7sAyZpsN5/2hqeJBm5/S73eJ42CQaxw==
X-Received: by 2002:adf:f186:: with SMTP id h6mr171692wro.290.1615916381790;
        Tue, 16 Mar 2021 10:39:41 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.162])
        by smtp.gmail.com with ESMTPSA id a12sm21890191wrx.5.2021.03.16.10.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:39:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernel-shark: Build "dataplot" only if OpenGL and GLUT are found
Date:   Tue, 16 Mar 2021 19:39:21 +0200
Message-Id: <20210316173922.657865-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316173922.657865-1-y.karadz@gmail.com>
References: <20210316173922.657865-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "dataplot" example depends from those two packages.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/CMakeLists.txt | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index bc17635..c2f4c01 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -20,9 +20,13 @@ message(STATUS "confogio")
 add_executable(confio          configio.c)
 target_link_libraries(confio   kshark)
 
-message(STATUS "dataplot")
-add_executable(dplot          dataplot.cpp)
-target_link_libraries(dplot   kshark-plot)
+if (OPENGL_FOUND AND GLUT_FOUND)
+
+    message(STATUS "dataplot")
+    add_executable(dplot          dataplot.cpp)
+    target_link_libraries(dplot   kshark-plot)
+
+endif (OPENGL_FOUND AND GLUT_FOUND)
 
 if (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
-- 
2.25.1

