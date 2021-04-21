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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634DEC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319A7613B6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243691AbhDUOwc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243684AbhDUOwa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 10:52:30 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DD5C06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:56 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r12so63948250ejr.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gJZkAsO0gHBa89WOAtQTVzOJl9oNL7w5A8P2P33dE7w=;
        b=My8bLCe6By5Sxx4UgNAuj50CzJcb42C+ZyM6nQfOSmKHzJz8GI5VTXakOFkdGJnxYB
         5lhh+5TMirirOuvounh87w2LOyVFx4hWGy/cazczT76yjQz7NT5MIMjZ403hUfAFlCq9
         V+xRYmMBrkLhbztilg6nF4MEXEym58VW34ONZJvoOv71pzWw0hbkHm6DEJgsfpoai3qp
         IPozuCCgX2w2lG5V1H8Tv/YLbsPjdpasYUnteJZ6U12Jsa2RcwPFfal068zgyGT8oWwG
         K+mCnO8var7cF77PRlPXAS556aXR3Ay4ieGUyMgXhG40c9c40AYiUFAOcOouSaEBWWpn
         acYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gJZkAsO0gHBa89WOAtQTVzOJl9oNL7w5A8P2P33dE7w=;
        b=OjeeuCaVNqcPoGaOQGCSPP8syPRP8OmBKb1gg0xz9ijRBwQfvY9wqfBng02UvJk+ty
         XGuD8BuZ/YUb1qNxsThaa7HNYxCz0qu3WrmINAjxTpIAkWGgKA8MG3mH0mXAYA/YmBfP
         e9rIxZ8VIBVRu2/MqXjWI6rOqvVjeWmGMx+fcFMmc5LxJdNPtIipS6crwuD4V+b4EEjn
         0ZaR3qVMshnRYyTiEAMgy8ZLwXwAmu6BcKBBP7DNlm4v/73amnI1fUtWV/cEofTASgK4
         DX3VrKCTdr2P8D8SvysHrgJoqjvTOgWGUhBFNYYnd/HWTYZueLsB86rqFDM/RifONAn9
         HmzA==
X-Gm-Message-State: AOAM531pARXZympoUXg+qWmgCPE9Sio6UCcYU+GrSfx0IQWNdg3a+wHh
        FskBJClQvmzmU6uhL/RA1+5NTjKJiq4=
X-Google-Smtp-Source: ABdhPJxaq7EruM5dhxw6O7dIGPN9VUzOpprbrJLbVPNasD7i+Ke3S2QdyyhMN1XROJpOt4lB7iR6ow==
X-Received: by 2002:a17:907:b1b:: with SMTP id h27mr33705036ejl.421.1619016714792;
        Wed, 21 Apr 2021 07:51:54 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id ke14sm2730325ejc.1.2021.04.21.07.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 07:51:54 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] kernel-shark: Exclude libkshark-plot from libkshark-devel
Date:   Wed, 21 Apr 2021 17:51:39 +0300
Message-Id: <20210421145140.95517-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210421145140.95517-1-y.karadz@gmail.com>
References: <20210421145140.95517-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The library that provides the OpenGL plotting instruments, used by
the KernelShark GUI is remove from the "libkshark-devel" installation
component. In fact this library was never a true (functional) part
of "libkshark-devel", since its header files were never installed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 4ab0af2..f3c4e0a 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -21,7 +21,6 @@ set_target_properties(kshark  PROPERTIES
                                   SOVERSION ${KS_VERSION_MAJOR}
                                   VERSION   ${KS_VERSION_STRING})
 
-
 install(TARGETS kshark
         LIBRARY DESTINATION    ${_LIBDIR}
             COMPONENT              kernelshark
@@ -58,18 +57,10 @@ if (OPENGL_FOUND)
                                        ${GLUT_LIBRARY}
                                        ${OPENGL_LIBRARIES})
 
-    set_target_properties(kshark-plot PROPERTIES
-                                          SOVERSION ${KS_VERSION_MAJOR}
-                                          VERSION   ${KS_VERSION_STRING})
-
+    set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
     install(TARGETS kshark-plot
             LIBRARY DESTINATION    ${_LIBDIR}
-                COMPONENT              kernelshark
-                NAMELINK_COMPONENT     libkshark-devel
-            INCLUDES DESTINATION   ${_INSTALL_PREFIX}/include/${KS_APP_NAME}
-                COMPONENT              libkshark-devel
-            ARCHIVE DESTINATION    ${_LIBDIR}
-                COMPONENT              libkshark-devel)
+                COMPONENT              kernelshark)
 
 endif (OPENGL_FOUND)
 
-- 
2.27.0

