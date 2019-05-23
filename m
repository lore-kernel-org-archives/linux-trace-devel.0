Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738A2C282E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A9D20665
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbfEWPSu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:18:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37575 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731173AbfEWPSs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:18:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id e15so6743904wrs.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RlPSX2f46myCSZN6xZyY1xUFxQFevAdG7+SpzfBhUK0=;
        b=Tf1OsfwUllZLaZuSmMXUm3BGg4hw+n0rW89pzFmxTwF4cO4SIRmdhT9bNZR1DYvMJ4
         7jageiFFRepxxTfghsbX64ZCYXdxRqj2bU7o+wmtoLn04V0/k26VGykkT+XyGujNR4if
         l8X/0sbL6vnAiX/ye8GKFp69fG+wiLGZWRwRt7uOx7XIhuiEJGbDEDHyuXONBwZh9rt7
         tMncHcThlSRWTm/GU6GTXBGeF1A6aKcyyKpIxpVzRWdcUTjqn42RbyYo+4UglrIj3hpa
         JP6rkHMGsbjNwp7/rnMVNFUv4kPGgULC1HBdolJWxRnyoDAMZ2UGAfc/YvhBSpRB3FuK
         ORlg==
X-Gm-Message-State: APjAAAVyzYKk49ib3tSDOfbmVRwGXh1PsSmvPXCqNviR38CbPimdDOZS
        +3Rd4eYZSH+L1GCv6VbnnW0=
X-Google-Smtp-Source: APXvYqx0nkJR+2h6iZQXInL3oldBxnvpuKll0l99jcIygyAc4fLKy/WkKGqXssC0kncijqDeanZadw==
X-Received: by 2002:adf:f488:: with SMTP id l8mr23748287wro.287.1558624726740;
        Thu, 23 May 2019 08:18:46 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x9sm12687071wmf.27.2019.05.23.08.18.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:18:46 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 4/5] trace-cmd: Install public interface headers
Date:   Thu, 23 May 2019 18:18:11 +0300
Message-Id: <20190523151812.31391-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523151812.31391-1-ykaradzhov@vmware.com>
References: <20190523151812.31391-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Installing the header files included in the public interfaces of
the trace-cmd libraries will make possible the libraries to be used
for development.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 Makefile | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index cde45f8..ac514b1 100644
--- a/Makefile
+++ b/Makefile
@@ -49,10 +49,18 @@ html_install = $(prefix)/share/kernelshark/html
 html_install_SQ = '$(subst ','\'',$(html_install))'
 img_install = $(prefix)/share/kernelshark/html/images
 img_install_SQ = '$(subst ','\'',$(img_install))'
-libdir ?= $(prefix)/lib
-libdir_SQ = '$(subst ','\'',$(libdir))'
-includedir = $(prefix)/include/trace-cmd
-includedir_SQ = '$(subst ','\'',$(includedir))'
+
+tcmd_libdir ?= $(prefix)/lib/trace-cmd
+tcmd_libdir_SQ = '$(subst ','\'',$(tcmd_libdir))'
+
+tevt_libdir ?= $(prefix)/lib/traceevent
+tevt_libdir_SQ = '$(subst ','\'',$(tevt_libdir))'
+
+tcmd_includedir = $(prefix)/include/trace-cmd
+tcmd_includedir_SQ = '$(subst ','\'',$(tcmd_includedir))'
+
+tevt_includedir = $(prefix)/include/traceevent
+tevt_includedir_SQ = '$(subst ','\'',$(tevt_includedir))'
 
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
@@ -335,10 +343,12 @@ install_gui: install_cmd gui
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build install
 
 install_libs: libs
-	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
-	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ))
-	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ))
-	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ))
+	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(tcmd_libdir_SQ))
+	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(tevt_libdir_SQ))
+	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(tevt_includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(tevt_includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(tcmd_includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-filter-hash.h,$(tcmd_includedir_SQ))
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
-- 
2.20.1

