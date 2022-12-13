Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4913C10F1B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Dec 2022 17:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiLMRED (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiLMRDC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 12:03:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCBE22BD0
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Dec 2022 08:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670950722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pajEUW+e2kGpIy2WjVXpBvH/EVcKDyakZt4OPG6bn5I=;
        b=PDZCSY+iBhR6O541fctiaelt+VVxDE2IB8zpuFqVCD9QvbcCVIQlTl/F6Vuy2flftwWD8N
        +V2q/KQf7wZmdVE+AJOvWnPnq9h/NM4eSFwlrQmwc0GGYc1zJBSPGHQlxlcyZW/+bfNygQ
        af12WZ+pdTSzO+LbIhTXkTP6CJcTrv4=
Received: from mimecast-mx02.redhat.com (66.187.233.88 [66.187.233.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-TdbiB_hNMK-3jEK8rTGm5g-1; Tue, 13 Dec 2022 11:57:07 -0500
X-MC-Unique: TdbiB_hNMK-3jEK8rTGm5g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E519806003;
        Tue, 13 Dec 2022 16:57:05 +0000 (UTC)
Received: from vschneid.remote.csb (unknown [10.33.36.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 951351121314;
        Tue, 13 Dec 2022 16:57:04 +0000 (UTC)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH v3 1/4] libtraceevent: Ensure print_field_raw() terminates with '\0'
Date:   Tue, 13 Dec 2022 16:56:17 +0000
Message-Id: <20221213165620.1034287-2-vschneid@redhat.com>
In-Reply-To: <20221213165620.1034287-1-vschneid@redhat.com>
References: <20221213165620.1034287-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Testing printing cpumasks reveals an issue in print_field_raw()'s handling
of arrays: its final operation is trace_seq_putc(']'), which omits a final
'\0'.

The other cases in the function invoke trace_seq_printf() which does the
right thing, only the TEP_FIELD_IS_ARRAY case has that issue. Still, to
prevent any future surprises, add a call to trace_seq_terminate() at the
end of print_field_raw().

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 src/event-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index a6e9e93..093b345 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5681,6 +5681,7 @@ static void print_field_raw(struct trace_seq *s, void *data, int size,
 				trace_seq_printf(s, "%llu", val);
 		}
 	}
+	trace_seq_terminate(s);
 }
 
 static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
-- 
2.31.1

