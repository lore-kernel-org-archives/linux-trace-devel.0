Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C72C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Sep 2022 11:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiI3LWD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 07:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbiI3LV2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 07:21:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8C0E0045
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Sep 2022 04:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664536216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=TqBotxjNdrk9YiwRDsRD9Eq1UXIEKD2SVn4A/RFkruE=;
        b=AnKQlHw4gZSvGe+Hgp8SgToiT8IrskdbT+55dxnBatS9a8Ok4cPEBnS62EuFYrLr5sou8i
        xFsbw3vSYrfdAr27xIlAFSh9+HcOy3mbG0sJdHxK39wPifpw9+cu4BKeZZNchqk3yEnlJf
        vA5EqkAsQah75wYdUlGUDjIgBMV/ff0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-_ieKqhl8Ox6ky3nX12T9KA-1; Fri, 30 Sep 2022 07:10:12 -0400
X-MC-Unique: _ieKqhl8Ox6ky3nX12T9KA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8363F380393D;
        Fri, 30 Sep 2022 11:10:10 +0000 (UTC)
Received: from Diego.redhat.com (unknown [10.39.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72735C15BA4;
        Fri, 30 Sep 2022 11:10:09 +0000 (UTC)
From:   Michael Petlan <mpetlan@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org
Subject: [PATCH 3/3] libtraceevent: Fix Branch condition garbage value compiler warning
Date:   Fri, 30 Sep 2022 13:10:02 +0200
Message-Id: <20220930111002.6107-4-mpetlan@redhat.com>
In-Reply-To: <20220930111002.6107-1-mpetlan@redhat.com>
References: <20220930111002.6107-1-mpetlan@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If *offset equals to zero, it is zero. If not equals to zero, set it to
zero. In any case, it will be zero, so we can omit the condition and so
get rid of the compiler warning:

  libtraceevent/src/event-parse.c:4064:7: warning[core.uninitialized.Branch]: Branch condition evaluates to a garbage value

Instead, let's rather check the pointers for being NULL, in order to
prevent another warning:

  libtraceevent/src/event-parse.c:4064:7: warning[core.NullDereference]: Dereference of null pointer (loaded from variable 'offset')

Signed-off-by: Michael Petlan <mpetlan@redhat.com>
---
 src/event-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index b4094ec..60bf989 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4073,9 +4073,9 @@ static inline void dynamic_offset_field(struct tep_handle *tep,
 {
 	/* Test for overflow */
 	if (field->offset + field->size > size) {
-		if (*offset)
+		if (offset)
 			*offset = 0;
-		if (*len)
+		if (len)
 			*len = 0;
 		return;
 	}
-- 
2.18.4

