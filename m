Return-Path: <SRS0=pI6O=2G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3B9C2D0C3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 20:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B1E24676
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 20:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576529292;
	bh=oBAXCXMSZ9oqUhMAoikA5/UAl05MBgzQ+SGDbxLEg4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nFzEJxAZ3syvPuIaffjfmLeL5adX8wFAjMzke8tdrquTMHweaYXMILxQ+t2XOiCSt
	 6P/rWGiOinLFYI+RuZmfzgSWYHNGi1Qowtd/iYJkDE4fVIfOWcJjcDWreAtI9ehAQh
	 sAWdofIkvdYg1KrlmjeGocyvqoFSfKUfRL+Q2SXY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfLPUsL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 15:48:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbfLPUsL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 15:48:11 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFB2D21775;
        Mon, 16 Dec 2019 20:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576529290;
        bh=oBAXCXMSZ9oqUhMAoikA5/UAl05MBgzQ+SGDbxLEg4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=be5Al73xYYFoQwhhsLMEQSyloVoCAEbBzvMuz+CRbY6jTA6CFi+VFkJx6yogHmafT
         AWkQYfnGBOvB4AF65roFmD8y680uK8w3SP4IiROc+8wK7HPLNexlruLwjPLNfiCpmM
         15YxkjLUu1UW7q0BTG3+B7VgRkF8MpxDacbkyaws=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/9] libtraceevent: Allow custom libdir path
Date:   Mon, 16 Dec 2019 17:47:36 -0300
Message-Id: <20191216204738.12107-8-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191216204738.12107-1-acme@kernel.org>
References: <20191216204738.12107-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

When I use prefix=/usr and try to install libtraceevent in my laptop it
tries to install in /usr/lib64. I am not having any folder as /usr/lib64
and also the debian policy doesnot allow installing in /usr/lib64. It
should be in /usr/lib/x86_64-linux-gnu/.

Quote: No package for a 64 bit architecture may install files in
	/usr/lib64/ or in a subdirectory of it.

ref: https://www.debian.org/doc/debian-policy/ch-opersys.html

Make it more flexible by allowing to mention libdir_relative while
installing so that distros can mention the path according to their
policy or use the default one.

Signed-off-by: Sudipm Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Sudipm Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191207111440.6574-1-sudipm.mukherjee@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile         | 5 +++--
 tools/lib/traceevent/plugins/Makefile | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index c5a03356a999..c874c017c636 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -39,11 +39,12 @@ DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
 
 LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
 ifeq ($(LP64), 1)
-  libdir_relative = lib64
+  libdir_relative_temp = lib64
 else
-  libdir_relative = lib
+  libdir_relative_temp = lib
 endif
 
+libdir_relative ?= $(libdir_relative_temp)
 prefix ?= /usr/local
 libdir = $(prefix)/$(libdir_relative)
 man_dir = $(prefix)/share/man
diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
index f440989fa55e..349bb81482ab 100644
--- a/tools/lib/traceevent/plugins/Makefile
+++ b/tools/lib/traceevent/plugins/Makefile
@@ -32,11 +32,12 @@ DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
 
 LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
 ifeq ($(LP64), 1)
-  libdir_relative = lib64
+  libdir_relative_tmp = lib64
 else
-  libdir_relative = lib
+  libdir_relative_tmp = lib
 endif
 
+libdir_relative ?= $(libdir_relative_tmp)
 prefix ?= /usr/local
 libdir = $(prefix)/$(libdir_relative)
 
-- 
2.21.0

