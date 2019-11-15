Return-Path: <SRS0=AXMx=ZH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7BDC432C3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02ECE20732
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uxwEil4X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfKOLgS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 06:36:18 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52364 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfKOLgS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 06:36:18 -0500
Received: by mail-wm1-f66.google.com with SMTP id l1so9328714wme.2;
        Fri, 15 Nov 2019 03:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P28Puxylk/r5Ui/pcuWbRKPEVXZgWJIsu42I+gVjMAA=;
        b=uxwEil4XOgtsR611mBvNV24eDCf+ZMR75XGXhlmdoxVKrrHrKzIOQZXuvIQA2DYQBm
         Z0BL8dmY817HualEeGNxl8fxwna16Bq2eWlXqZtFXtzPSdpp+KMqDOMn7JSzH2OSe8Cw
         4RlHqMORhUX4HF6QrI5GbhpKtLpKcDwd3IpFvNKfA5ZP3YFTiPB0BtmjrU8+i3Xb3/U+
         RuuSIGzr5UqP/5bs6NTFGxdylOUku8ulIj4CvyzeQzYQJ2oUlAvcexOPztLGIbk8aOGu
         LTqWa0GRh7kVj2E/iOlkyxYp7eugewu/hTYuPUYD3x30HEXvByjebdZ49E4NeA1NVcG9
         KrmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P28Puxylk/r5Ui/pcuWbRKPEVXZgWJIsu42I+gVjMAA=;
        b=MnVVRNhbr33s1UiH0DV+RoxP1m4MWamR6orFFvwVjQXF0NavvrirfnS7CliABn1HR8
         q6UO1uvCJkubD3JjCTu6gvAkI6okdR/ij7DaRVJeuh2u1fI3PYWlnjM5Sq9JJwJ9Ww0Y
         EyjctBH62/2Yw9UkhruKAPzQOiNceWC0rpNlUeaJQQqUvT8LFhdSauYcneTNS2uo/AWY
         3baHaRpgbejf3/Q+Sgwwu5YnRlTfZcORXQe3tKGOqIbbvyH21ChhurkmXNPhClH9xd10
         GD4jHCtmaQS5G0/BCf2y0eOybc8bmEo/JRUT4YTqtmzdqEXQ7U2NoPU0zs07IRyrZdH1
         SouQ==
X-Gm-Message-State: APjAAAVC/ALKDrNuWmv39MAEPQ8vrEbx/kJd4O+qLQW8XNrkDy+zAxCm
        nPq88E81jg7gfOn/4wULYj4=
X-Google-Smtp-Source: APXvYqytQ0ArvpkUnnkzBMKfqvfntQkUvu0xqJVGXTGHxC1ysOjODO93KYidDgPryjlvD/bFsznqBQ==
X-Received: by 2002:a1c:64d6:: with SMTP id y205mr12959002wmb.136.1573817775128;
        Fri, 15 Nov 2019 03:36:15 -0800 (PST)
Received: from debian.office.codethink.co.uk ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id 17sm8756962wmg.19.2019.11.15.03.36.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 03:36:14 -0800 (PST)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 2/2] libtraceevent: copy pkg-config file in output folder
Date:   Fri, 15 Nov 2019 11:36:10 +0000
Message-Id: <20191115113610.21493-2-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191115113610.21493-1-sudipm.mukherjee@gmail.com>
References: <20191115113610.21493-1-sudipm.mukherjee@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When we use 'O=' with make to build libtraceevent in a separate folder
it still copies 'libtraceevent.pc' to its source folder. Modify the
Makefile so that it uses the output folder to copy the pkg-config file
and install from there.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 tools/lib/traceevent/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 83446fe2cf01..c5a03356a999 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -208,10 +208,11 @@ define do_install
 	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
 endef
 
-PKG_CONFIG_FILE = libtraceevent.pc
+PKG_CONFIG_SOURCE_FILE = libtraceevent.pc
+PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
 define do_install_pkgconfig_file
 	if [ -n "${pkgconfig_dir}" ]; then 					\
-		cp -f ${PKG_CONFIG_FILE}.template ${PKG_CONFIG_FILE}; 		\
+		cp -f ${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
 		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
 		sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
 		sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
-- 
2.11.0

