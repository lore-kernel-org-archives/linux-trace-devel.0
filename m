Return-Path: <SRS0=xW9H=SA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F45C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 14:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A07C2184C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 14:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfC2Opu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Mar 2019 10:45:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35674 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729184AbfC2Opu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Mar 2019 10:45:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id w1so2949173wrp.2;
        Fri, 29 Mar 2019 07:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=woXlb6ivRqHuTA55bFh89ymhKduhc5nZwdZTGOtsw5k=;
        b=TfSHEd1htSKvXygSD0dqwl/2OQFh8MGzj7VgW5Xpp2JXr5DMrypikrfalXWUfNNFIw
         AvRnPXxqfwIbSQFH/fLXzmsi1ZKg4KGPzLVfDOrcLAszkAPKjfId4g7cFuo4nsq8PLQI
         fPwfrY5AbhN9Ew1rkIqOfC7JETiKV0R54/ClP5+GRmY7k0B2e8Qdwj6SjtI68gfH5nFE
         erjuL1n7zZ4Au2X0z+WPvDAd2HmHWvCGMm2nM5tLvYEUQqURpRm//Zx9Nioqlb5idR0C
         6Vy1N/l8ZKcCfsPvVSUIF0RH0ryFJ7ATzYsVSeNZR1clVcuVmQPaEEiTvrL+dIxr6rQO
         cVag==
X-Gm-Message-State: APjAAAUNWMDstTfq5+rdNd5DNmSBuoThGjGEbbSCmAJajO+O3aI/KvMW
        xUZXM4tX4GFTh7O1CfbiHTWMdppt
X-Google-Smtp-Source: APXvYqx6vccNWPXruElK/seOhQY77Wg+XYjCPYr7CAfJWa1/qSykdNOhPIM/eKW7xpfCqPHGea/log==
X-Received: by 2002:adf:deca:: with SMTP id i10mr6574315wrn.88.1553870748215;
        Fri, 29 Mar 2019 07:45:48 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 4sm1754266wmg.12.2019.03.29.07.45.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Mar 2019 07:45:47 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] tools/lib/traceevent: Remove hardcoded install paths from pkg-config file
Date:   Fri, 29 Mar 2019 16:45:46 +0200
Message-Id: <20190329144546.5819-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Install directories of header and library files are hardcoded in pkg-config
templete file. They must be configurable, the Makefile should set them on the
compilation / install stage.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Makefile                  | 13 +++++++++----
 tools/lib/traceevent/libtraceevent.pc.template |  4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 67fe5d7ef190..6419a24058ab 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -50,6 +50,9 @@ man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
+includedir_relative = traceevent
+includedir = $(prefix)/include/$(includedir_relative)
+includedir_SQ = '$(subst ','\'',$(includedir))'
 
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
@@ -279,6 +282,8 @@ define do_install_pkgconfig_file
 		cp -f ${PKG_CONFIG_FILE}.template ${PKG_CONFIG_FILE}; 		\
 		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
 		sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
+		sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
+		sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE}; \
 		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
 	else 									\
 		(echo Failed to locate pkg-config directory) 1>&2;		\
@@ -300,10 +305,10 @@ install_pkgconfig:
 
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-		$(call do_install,event-parse.h,$(prefix)/include/traceevent,644); \
-		$(call do_install,event-utils.h,$(prefix)/include/traceevent,644); \
-		$(call do_install,trace-seq.h,$(prefix)/include/traceevent,644); \
-		$(call do_install,kbuffer.h,$(prefix)/include/traceevent,644)
+		$(call do_install,event-parse.h,$(DESTDIR)$(includedir_SQ),644); \
+		$(call do_install,event-utils.h,$(DESTDIR)$(includedir_SQ),644); \
+		$(call do_install,trace-seq.h,$(DESTDIR)$(includedir_SQ),644); \
+		$(call do_install,kbuffer.h,$(DESTDIR)$(includedir_SQ),644)
 
 install: install_lib
 
diff --git a/tools/lib/traceevent/libtraceevent.pc.template b/tools/lib/traceevent/libtraceevent.pc.template
index 42e4d6cb6b9e..86384fcd57f1 100644
--- a/tools/lib/traceevent/libtraceevent.pc.template
+++ b/tools/lib/traceevent/libtraceevent.pc.template
@@ -1,6 +1,6 @@
 prefix=INSTALL_PREFIX
-libdir=${prefix}/lib64
-includedir=${prefix}/include/traceevent
+libdir=LIB_DIR
+includedir=HEADER_DIR
 
 Name: libtraceevent
 URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1

