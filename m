Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3ABC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Sep 2022 11:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiI3LWC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 07:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiI3LVW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 07:21:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FD1A3D2F
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Sep 2022 04:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664536210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=MkJBb6qEyiH1ZELOzZazlE+GwbqiTs5nWcOyNA2hsvM=;
        b=M8ogQCq+5ztN7CNxfs1IW0XtZxgfX3QxFVpE4JWlN/1px28Vycq4jMU29ult3hhKZHHPfN
        63Qe2ghSk8zCzoLkyk050blHH3ZeHlyRrvJKnpGeCHNjAtsUa485mtKZi//s/WZMR+T/AX
        Yc1KGXU5Xm4isJv4FVL8JAsS5mJRAaA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-mjXyYsvGNYiI2T6KHfhuYQ-1; Fri, 30 Sep 2022 07:10:07 -0400
X-MC-Unique: mjXyYsvGNYiI2T6KHfhuYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 368C8805AC5;
        Fri, 30 Sep 2022 11:10:07 +0000 (UTC)
Received: from Diego.redhat.com (unknown [10.39.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6459CC15BA4;
        Fri, 30 Sep 2022 11:10:06 +0000 (UTC)
From:   Michael Petlan <mpetlan@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org
Subject: [PATCH 1/3] libtraceevent: Fix uninitialized has_0x compiler warning
Date:   Fri, 30 Sep 2022 13:10:00 +0200
Message-Id: <20220930111002.6107-2-mpetlan@redhat.com>
In-Reply-To: <20220930111002.6107-1-mpetlan@redhat.com>
References: <20220930111002.6107-1-mpetlan@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initialize has_0x in order to supress the following compiler warning:

  event-parse.c:5654:20: warning: 'has_0x' may be used uninitialized in this function [-Wmaybe-uninitialized]
   5654 |                 if (has_0x)
        |                    ^
  event-parse.c:5619:14: note: 'has_0x' was declared here
   5619 |         bool has_0x;
        |              ^~~~~~

Signed-off-by: Michael Petlan <mpetlan@redhat.com>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 980e980..edf990a 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5657,7 +5657,7 @@ static inline void print_field(struct trace_seq *s, void *data, int size,
 	struct tep_print_parse *start_parse;
 	struct tep_print_parse *parse;
 	struct tep_print_arg *arg;
-	bool has_0x;
+	bool has_0x = false;
 
 	parse = parse_ptr ? *parse_ptr : event->print_fmt.print_cache;
 
-- 
2.18.4

