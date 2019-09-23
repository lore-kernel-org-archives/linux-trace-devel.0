Return-Path: <SRS0=Mdk7=XS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A163C4CECF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 15:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77F732089F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 15:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732512AbfIWP7j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 11:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728464AbfIWP7j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 11:59:39 -0400
Received: from oasis.local.home (unknown [65.39.69.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D77420673;
        Mon, 23 Sep 2019 15:59:36 +0000 (UTC)
Date:   Mon, 23 Sep 2019 11:59:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] tools/lib/traceevent: Man page updates and some
 file movement
Message-ID: <20190923115929.453b68f1@oasis.local.home>
In-Reply-To: <20190923111248.5ebdbfd5@oasis.local.home>
References: <20190919212335.400961206@goodmis.org>
        <20190923142839.GD16544@kernel.org>
        <20190923143927.GE16544@kernel.org>
        <20190923145249.GF16544@kernel.org>
        <20190923111248.5ebdbfd5@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 23 Sep 2019 11:12:48 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Yeah. Let's not apply this one yet till we figure out what broke. I'll
> take a look at it too.

Does this help?

-- Steve

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index f9807d8c005b..7544166dd466 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -292,7 +292,7 @@ endif
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
 export LIBTRACEEVENT
 
-LIBTRACEEVENT_DYNAMIC_LIST = $(TE_PATH)libtraceevent-dynamic-list
+LIBTRACEEVENT_DYNAMIC_LIST = $(TE_PATH)plugins/libtraceevent-dynamic-list
 
 #
 # The static build has no dynsym table, so this does not work for
@@ -737,7 +737,7 @@ libtraceevent_plugins: FORCE
 	$(Q)$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) plugins
 
 $(LIBTRACEEVENT_DYNAMIC_LIST): libtraceevent_plugins
-	$(Q)$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) $(OUTPUT)libtraceevent-dynamic-list
+	$(Q)$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) $(OUTPUT)plugins/libtraceevent-dynamic-list
 
 $(LIBTRACEEVENT)-clean:
 	$(call QUIET_CLEAN, libtraceevent)

