Return-Path: <SRS0=XW/z=Z2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF907C43603
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 07:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A690E215B2
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 07:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfLDHyA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 02:54:00 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56063 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLDHyA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 02:54:00 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1icPTr-0004Qe-OC; Wed, 04 Dec 2019 08:53:51 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 5F3391C2217;
        Wed,  4 Dec 2019 08:53:51 +0100 (CET)
Date:   Wed, 04 Dec 2019 07:53:51 -0000
From:   "tip-bot2 for Sudip Mukherjee" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] libtraceevent: Copy pkg-config file to output
 folder when using O=
Cc:     Sudipm Mukherjee <sudipm.mukherjee@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191115113610.21493-2-sudipm.mukherjee@gmail.com>
References: <20191115113610.21493-2-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Message-ID: <157544603119.21853.10423466148117634135.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     15b3904f8e884e0d34d5f09906cf6526d0b889a2
Gitweb:        https://git.kernel.org/tip/15b3904f8e884e0d34d5f09906cf6526d0b889a2
Author:        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
AuthorDate:    Fri, 15 Nov 2019 11:36:10 
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Mon, 02 Dec 2019 21:58:20 -03:00

libtraceevent: Copy pkg-config file to output folder when using O=

When we use 'O=' with make to build libtraceevent in a separate folder
it still copies 'libtraceevent.pc' to its source folder. Modify the
Makefile so that it uses the output folder to copy the pkg-config file
and install from there.

Signed-off-by: Sudipm Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191115113610.21493-2-sudipm.mukherjee@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 83446fe..c5a0335 100644
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
