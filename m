Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 844FFC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Feb 2022 17:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbiBRR5p convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 12:57:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238840AbiBRR5o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 12:57:44 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 728181162
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 09:57:27 -0800 (PST)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-oc3OI1FUP-m1dUeuELmFDg-1; Fri, 18 Feb 2022 12:57:21 -0500
X-MC-Unique: oc3OI1FUP-m1dUeuELmFDg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B08AD2F47;
        Fri, 18 Feb 2022 17:57:19 +0000 (UTC)
Received: from x1.com (unknown [10.22.32.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1097438DE9;
        Fri, 18 Feb 2022 17:57:17 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] rtla/osnoise: Free params at the exit
Date:   Fri, 18 Feb 2022 18:57:08 +0100
Message-Id: <0be31d8259c7c53b98a39769d60cfeecd8421785.1645206561.git.bristot@kernel.org>
In-Reply-To: <cover.1645206561.git.bristot@kernel.org>
References: <cover.1645206561.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The variable that stores the parsed command line arguments are not
being free()d at the rtla osnoise top exit path.

Free params variable before exiting.

Fixes: 1eceb2fc2ca5 ("rtla/osnoise: Add osnoise top mode")
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 tools/tracing/rtla/src/osnoise_top.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/tracing/rtla/src/osnoise_top.c b/tools/tracing/rtla/src/osnoise_top.c
index c67dc28ef716..7af769b9c0de 100644
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -573,6 +573,7 @@ int osnoise_top_main(int argc, char **argv)
 	osnoise_free_top(tool->data);
 	osnoise_destroy_tool(record);
 	osnoise_destroy_tool(tool);
+	free(params);
 out_exit:
 	exit(return_value);
 }
-- 
2.34.1

