Return-Path: <SRS0=1m8P=2R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A417C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2158206CB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469505;
	bh=qM1K8b9ABcWajK0PB6SL3OmVqdsQlj0LkxqO2SEIa10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aoYIjbX+ynKmOQrohm6b5y3RqrkbuRGJ/0YCWH71RNkr3GiHM3pUjR1D8RmXzCbml
	 AAra/oj+ORlRsBa8FOpn5nORzFXKBVO/xINf3heix8Du4n2zgYNLc8OtJM6gzwO2wR
	 lDHOUr7NOtDq/Fw/SSz7J0/SsTZgDlv1MyYNAKI4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfL0R6Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727408AbfL0RlW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC8E124125;
        Fri, 27 Dec 2019 17:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468481;
        bh=qM1K8b9ABcWajK0PB6SL3OmVqdsQlj0LkxqO2SEIa10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tDmfMPIZ3qTXK6DjOUZanl/GO8RLlnuC5KrCWI0RKGiYnZ3ORQI1MhXdIEstozVc
         nBXn3rLVgWbihuQoovtzA53+maMPdUUzQKaQdjx9cCJmxZzOIAs0vmKGwdx06i881I
         gSZ2NAdmLdRDuYnedjhVk92WDCTwwjD5Y+ZasKQA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 020/187] libtraceevent: Copy pkg-config file to output folder when using O=
Date:   Fri, 27 Dec 2019 12:38:08 -0500
Message-Id: <20191227174055.4923-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

[ Upstream commit 15b3904f8e884e0d34d5f09906cf6526d0b889a2 ]

When we use 'O=' with make to build libtraceevent in a separate folder
it still copies 'libtraceevent.pc' to its source folder. Modify the
Makefile so that it uses the output folder to copy the pkg-config file
and install from there.

Signed-off-by: Sudipm Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191115113610.21493-2-sudipm.mukherjee@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index d008e64042ce..ecf882308d8a 100644
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
2.20.1

