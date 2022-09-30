Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42348C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Sep 2022 11:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiI3LWD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 07:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiI3LV1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 07:21:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FE2AB4EC
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Sep 2022 04:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664536211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=2LPmTYz4Cmgh15hlecEwhMtP4kEDxI4VdFvkwWSjP+c=;
        b=bTKbS8vaiWvxUwmGc7VVFgJgU+BLKTnoBI9b3aptNnjXKy55SQ0wc2oUYZ1oSGPZzZNXmG
        8aFE6Dp7q2VAJCucAR0cr3zh7OcRsnshLHq8/llMFam2Ons9c+HwlZyJJt05+PNKPPe714
        +HSb889IwvS6F5+FLDJSPjvwCPU+oTc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-15TL3CPpNFePnxQ1JfvLJg-1; Fri, 30 Sep 2022 07:10:09 -0400
X-MC-Unique: 15TL3CPpNFePnxQ1JfvLJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFF79811E67;
        Fri, 30 Sep 2022 11:10:08 +0000 (UTC)
Received: from Diego.redhat.com (unknown [10.39.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5C39C15BA4;
        Fri, 30 Sep 2022 11:10:07 +0000 (UTC)
From:   Michael Petlan <mpetlan@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org
Subject: [PATCH 2/3] libtraceevent: Fix check-after-deref coverity flaw
Date:   Fri, 30 Sep 2022 13:10:01 +0200
Message-Id: <20220930111002.6107-3-mpetlan@redhat.com>
In-Reply-To: <20220930111002.6107-1-mpetlan@redhat.com>
References: <20220930111002.6107-1-mpetlan@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Before patch, both arg->bitmask.field and arg->string.field were checked
for being NULL and if yes, some value was assigned to them. The value
was immediately used (dereferenced) and after that, another check for
NULL was performed (the one leading to break command). However, in case
this check would be true, the dereferencing before would have already
caused a crash.

Move the NULL checks before dereferencing the pointers.

Signed-off-by: Michael Petlan <mpetlan@redhat.com>
---
 src/event-parse.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index edf990a..b4094ec 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4623,10 +4623,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_STRING: {
 		if (!arg->string.field) {
 			arg->string.field = tep_find_any_field(event, arg->string.string);
+			if (!arg->string.field)
+				break;
 			arg->string.offset = arg->string.field->offset;
 		}
-		if (!arg->string.field)
-			break;
 		dynamic_offset_field(tep, arg->string.field, data, size, &offset, &len);
 		/* Do not attempt to save zero length dynamic strings */
 		if (!len)
@@ -4640,10 +4640,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_BITMASK: {
 		if (!arg->bitmask.field) {
 			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
+			if (!arg->bitmask.field)
+				break;
 			arg->bitmask.offset = arg->bitmask.field->offset;
 		}
-		if (!arg->bitmask.field)
-			break;
 		dynamic_offset_field(tep, arg->bitmask.field, data, size, &offset, &len);
 		print_bitmask_to_seq(tep, s, format, len_arg,
 				     data + offset, len);
-- 
2.18.4

