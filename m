Return-Path: <SRS0=L246=YS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10A4CA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C7BC2070B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:41:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DINXLls7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405207AbfJYGlz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 02:41:55 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:34340 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405128AbfJYGlz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 02:41:55 -0400
Received: by mail-pg1-f202.google.com with SMTP id l11so1046364pgg.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Oct 2019 23:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KUUaELA8d4HXU2ZHMkdW6TzhI4sH2z4LqT7wNCk5f/c=;
        b=DINXLls7tg8HXdxf0tn78Fsgts4N3Fpn6ZZ9nQcFuZb7vay7A1UlBhQfF1EfbM/OBv
         NTI+2734rVqNsYv8PtVj3csTaKgdq7RHJocaqK5rr04MHb6SDbWPIh/4NSX8AvDu8huj
         FqK6WX8OR3cgUPZp0Sn81/MIxIdEkKx8gYIlKxaTL4SwCRE5c5zZEGdIedch02niLXSO
         u0zmhTjAMqccz4QKOH2YihmI0p5tbJdz4YsHEuf/1YURmeEHhVLb6e2o0CsTGGvIiYdf
         pTofuPSFGKGU3N60AbWWUHq4K2Y/Zp6iajC2s7KiffkvpUxMQGpB3+Fkfqp0Bif3xmQj
         lIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KUUaELA8d4HXU2ZHMkdW6TzhI4sH2z4LqT7wNCk5f/c=;
        b=ZvwH+301B35+2ig/7I9ZLxYLV50zhkKgiqqS0JyF+t0i2V6z+ahpbaEm8yvRr/IwjK
         jkftG54h1f75g6vfAJCnylFvOTHY1iYVaYwcK3PGug3GvNG+rlsq2+rBI0ByBtKcuvty
         D0I86RcVvZJip0vBPVSgmdQEGzSOiymyg3q2bDcKy6X460XH/oUmi0myRC0Pqp5CT7kR
         k6MRG3YOg2mxTS0GmzAXZzB8/yqDJVZtYiG50/HSYMbIVPNuTAxJKIokBEpr8dqB6VM6
         hjTc7yKvFVAminB+vrcODUoGyI66ahSJCmsW4/2ZRjAGJofft2sB3mMlfcFiKc9R3gba
         9lLw==
X-Gm-Message-State: APjAAAUJAui1B3Ul0zh8aWQ7CmXljVBZRej8sxwGh8NHRrHJKal4AZM2
        J2lC39z0SKo7SMXRxqKJ3IFiS9bylDHx
X-Google-Smtp-Source: APXvYqzxKhLOpQHW6ZGjLtbxfY2kwv4aTQ/RhvqL1Jz4WYf2NA59ZqvIuprkcBYbVV0eAEih4cM1T3M3qDHn
X-Received: by 2002:a63:8f5e:: with SMTP id r30mr2424783pgn.146.1571985714019;
 Thu, 24 Oct 2019 23:41:54 -0700 (PDT)
Date:   Thu, 24 Oct 2019 23:39:56 -0700
Message-Id: <20191025063957.21558-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH 1/2] trace-cmd: refactor print_update
From:   Greg Thelen <gthelen@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Match utils.mk convention and use a conditional macro for printing
'UPDATE' messages.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 scripts/utils.mk | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 98d7b3c726d8..8e4e4b5f3a4a 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -22,6 +22,7 @@ ifeq ($(VERBOSE),1)
   print_plugin_obj_compile =
   print_plugin_build =
   print_install =
+  print_update =
 else
   Q = @
   S = -s
@@ -33,6 +34,7 @@ else
   print_plugin_build =		echo '  $(GUI)BUILD PLUGIN       '$(GOBJ);
   print_static_lib_build =	echo '  $(GUI)BUILD STATIC LIB   '$(GOBJ);
   print_install =		echo '  $(GUI)INSTALL     '$(GSPACE)$1'	to	$(DESTDIR_SQ)$2';
+  print_update =		echo '  $(GUI)UPDATE             '$(GOBJ);
 endif
 
 do_fpic_compile =					\
@@ -96,7 +98,7 @@ define update_version.h
 	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
 		rm -f $@.tmp;						\
 	else								\
-		echo '  UPDATE                 '$(notdir $(strip $@));	\
+		$(print_update)						\
 		mv -f $@.tmp $@;					\
 	fi);
 endef
@@ -106,7 +108,7 @@ define update_dir
 	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
 		rm -f $@.tmp;						\
 	else								\
-		echo '  UPDATE                 '$(notdir $(strip $@));	\
+		$(print_update)						\
 		mv -f $@.tmp $@;					\
 	fi);
 endef
-- 
2.24.0.rc0.303.g954a862665-goog

