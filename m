Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5B6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Feb 2022 16:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376545AbiBDQYV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 11:24:21 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:57677 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbiBDQYS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 11:24:18 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507--HCrrO5iPC-hR_YpiBWw0Q-1; Fri, 04 Feb 2022 11:24:17 -0500
X-MC-Unique: -HCrrO5iPC-hR_YpiBWw0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E800C1853022;
        Fri,  4 Feb 2022 16:24:15 +0000 (UTC)
Received: from x1.com (unknown [10.22.33.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2EBC7E91A;
        Fri,  4 Feb 2022 16:24:14 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] rtla/utils: Fix session duration parsing
Date:   Fri,  4 Feb 2022 17:24:03 +0100
Message-Id: <a2f0a37bc006c2561bb8ecd871cd70532b4a9f2d.1643990447.git.bristot@kernel.org>
In-Reply-To: <cover.1643990447.git.bristot@kernel.org>
References: <cover.1643990447.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Use gmtime to format the duration time. This avoids problems when the
system uses local time different of Pisa's Local Time.

Fixes: b1696371d865 ("rtla: Helper functions for rtla")
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 tools/tracing/rtla/src/utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index 1c9f0eea6166..ffaf8ec84001 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -77,11 +77,11 @@ void get_duration(time_t start_time, char *output, int output_size)
 	time_t duration;
 
 	duration = difftime(now, start_time);
-	tm_info = localtime(&duration);
+	tm_info = gmtime(&duration);
 
 	snprintf(output, output_size, "%3d %02d:%02d:%02d",
 			tm_info->tm_yday,
-			tm_info->tm_hour - 1,
+			tm_info->tm_hour,
 			tm_info->tm_min,
 			tm_info->tm_sec);
 }
-- 
2.34.1

