Return-Path: <SRS0=xFsM=X4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06A4C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 17:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C751620865
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 17:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570123102;
	bh=8MmppN0wk6iJ6HlwRzJl5OGpV+msx+sgDG0ZWr1rF/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=abDGWTwsDwUeDfz4CPE5NCJlXgsjtpTXofj/qqexbpBOtJLhbTZO8cmEa133z2HnL
	 oisRKE2Vn3ZYuAueV0ZXmbN8whjwbaMCP2O0jSGHtzFOHBJhialMjDjtswdmU3dADi
	 DrEuk3NhQ5sFvmHNhvPz36t4WETTzvcFJ6dJ+yhA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393376AbfJCRSL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 13:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390156AbfJCQVe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 12:21:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC3520659;
        Thu,  3 Oct 2019 16:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119693;
        bh=8MmppN0wk6iJ6HlwRzJl5OGpV+msx+sgDG0ZWr1rF/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9/F+duVd4sxMBCwIrCZjp3CyOBoW5b2cP+pB0mc0D6fCOpKmH1MPDlAsxJtnOjD9
         K/5BZytGttEXhJWSrEWk6Q4rt1oNZWtrF+MevNy06AqHOmN9/Sy0QMr3GCKE35bbG4
         bT/+xAK5usuWV16iAjeGevvFqXAAmLUKKyPN3jLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick McLean <chutzpah@gentoo.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/211] libtraceevent: Change users plugin directory
Date:   Thu,  3 Oct 2019 17:53:05 +0200
Message-Id: <20191003154514.403362132@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

[ Upstream commit e97fd1383cd77c467d2aed7fa4e596789df83977 ]

To be compliant with XDG user directory layout, the user's plugin
directory is changed from ~/.traceevent/plugins to
~/.local/lib/traceevent/plugins/

Suggested-by: Patrick McLean <chutzpah@gentoo.org>
Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Patrick McLean <chutzpah@gentoo.org>
Cc: linux-trace-devel@vger.kernel.org
Link: https://lore.kernel.org/linux-trace-devel/20190313144206.41e75cf8@patrickm/
Link: http://lore.kernel.org/linux-trace-devel/20190801074959.22023-4-tz.stoyanov@gmail.com
Link: http://lore.kernel.org/lkml/20190805204355.344622683@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/Makefile       | 6 +++---
 tools/lib/traceevent/event-plugin.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 0b4e833088a4d..95a43ccb6dd09 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -55,15 +55,15 @@ set_plugin_dir := 1
 
 # Set plugin_dir to preffered global plugin location
 # If we install under $HOME directory we go under
-# $(HOME)/.traceevent/plugins
+# $(HOME)/.local/lib/traceevent/plugins
 #
 # We dont set PLUGIN_DIR in case we install under $HOME
 # directory, because by default the code looks under:
-# $(HOME)/.traceevent/plugins by default.
+# $(HOME)/.local/lib/traceevent/plugins by default.
 #
 ifeq ($(plugin_dir),)
 ifeq ($(prefix),$(HOME))
-override plugin_dir = $(HOME)/.traceevent/plugins
+override plugin_dir = $(HOME)/.local/lib/traceevent/plugins
 set_plugin_dir := 0
 else
 override plugin_dir = $(libdir)/traceevent/plugins
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index f17e25097e1e2..52874eb94acef 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -16,7 +16,7 @@
 #include "event-parse.h"
 #include "event-utils.h"
 
-#define LOCAL_PLUGIN_DIR ".traceevent/plugins"
+#define LOCAL_PLUGIN_DIR ".local/lib/traceevent/plugins/"
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
-- 
2.20.1



