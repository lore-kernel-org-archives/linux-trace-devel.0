Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9098EC46499
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6888820828
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:11:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IldIsKjJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbfGEOLL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:11:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34507 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEOLL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 10:11:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so7580100wmd.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jul 2019 07:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x2mbc7l1bVE9UmAOYo5p0EBGdm4NiN+7zexATRy6YZw=;
        b=IldIsKjJE1w/3xHqQdwmOhn6mhBzzUcfbBMFd9qUdvICJFKHlep/46Wn7JZwsekbac
         1QQXny45xRIdwjvxQBjKFKcp8BJEvyCnNjuSp3alc7Pt8KWVJ5mgSx9ZBlwKnUFKnhnH
         Itl6NiIDTOpmneGrjTBLzrT22hda3Mh+r8Nr3G3DuEV4wbufnhYJexO2zhdOJ+3BtYcZ
         uvg+k6Xw2tAGnKzo6B3dPPFeqkiiP4iSZg2cYz3kFIQGLwZ0lq+tFbTaCzt7RwoYCaAU
         Xdj1a4ngjsGPbaqiHR6t6Pd/uCguboDLF90h+I7NuQlS7OFNioDKg7E0GNEFYaEpkmIn
         p4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x2mbc7l1bVE9UmAOYo5p0EBGdm4NiN+7zexATRy6YZw=;
        b=GwVBYFNZxwr78hjcCllYpwkKq9R1gYXG7iThB6D7zZjhhWrRiZ15LFxxyB967Nrwte
         S/4uYgPXIaVtbj9hXDurmfY7GconkZ1u3u1imEAXgtqJ2mfTHm+n/0nKPS27FnteF2gH
         Y4SW16LoXq8rgDswvOojzx3rCNMB4EIN/vrINaJ78HTqlBST1WHV06s9bWUyJ6fmVCxe
         lLGhnutwBPcwnL2gKTib/UvZR+GSAnJYr/U9YKZNFQslZKV4Olpr8CCX4UG6X2kmPimH
         pcrI44bORVLF11mpf0g6vU0Xa4ngQBpXTf6ZPGjDCsi3t6PL/X0jqDf/o5GkvwByIQ4y
         EUVQ==
X-Gm-Message-State: APjAAAWQmGeLs1sxBQ/llUiY5Yxwy8lf2oCqLawHVcHJUsgxpsOPs/J/
        YkbZcqRKf8N+KyPGQQxpNS0=
X-Google-Smtp-Source: APXvYqyd8umtKRYYU18CRIdWqhcMVI6DvXyzpXx35KAlYbuMNVdfK3133+v+TN8E5H7UznrJIVdJqA==
X-Received: by 2002:a7b:c748:: with SMTP id w8mr3562470wmk.36.1562335869072;
        Fri, 05 Jul 2019 07:11:09 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f192sm1893715wmg.30.2019.07.05.07.11.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 07:11:08 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Separate the target instalation instructions
Date:   Fri,  5 Jul 2019 17:10:31 +0300
Message-Id: <20190705141031.20239-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190705141031.20239-1-y.karadz@gmail.com>
References: <20190705141031.20239-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Having all target installation destinations given in one instruction may
result in an error in the case when some of the third-party dependencies
are missing. This will happen because you are trying to install a target
that hasn't been built.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/CMakeLists.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 6cbc00f..1228993 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -14,6 +14,8 @@ target_link_libraries(kshark ${CMAKE_DL_LIBS}
 
 set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
 
+install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
+
 if (OPENGL_FOUND AND GLUT_FOUND)
 
     message(STATUS "libkshark-plot")
@@ -26,6 +28,8 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
     set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
+    install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
+
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
@@ -77,7 +81,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     add_executable(kshark-record        kshark-record.cpp)
     target_link_libraries(kshark-record kshark-gui)
 
-    install(TARGETS ${KS_APP_NAME} kshark-record kshark kshark-plot kshark-gui
+    install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
             RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
             LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
 
-- 
2.20.1

