Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0341C38142
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Jan 2023 16:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjAaQbO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 Jan 2023 11:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbjAaQaz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jan 2023 11:30:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAE75925A;
        Tue, 31 Jan 2023 08:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 926616159C;
        Tue, 31 Jan 2023 16:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0963FC4339E;
        Tue, 31 Jan 2023 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675182621;
        bh=Rp+czZg6segzTvjYV1RqZZWVIT4bMNdzIqwCOmZs3jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saALylI4Qc34TNTKeAnCtMKKuuZuTG1bn9Ss9zvC+eyXoHsFKtphxHADdw+44PxsW
         1Mb6c2qDSRnEWIkUOYrhIa7Wvf6+zwxtpgt+0SlA+Hwh0otxx/Qjhjo07or8LJAMNb
         5fzrvp4xiJ75c93ezLk2+f30YeNNcT2iEc98giBO96jCBfVNiQ2XqBAQA5BUD54qqw
         duryGUhbSow6hPi4YY+onaxbqTwjYitr/CQguX13r3QmKAlqoFnoxUlXmJEyZFMh19
         WKIrrsD5ndRJHDiLaXf677wqTFOVIGfXxeORrg+9iru26oEOdKjdJuPKeYtKGmvh7L
         FqiX5eZ1G2JJQ==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 3/6] rtla/osnoise: Add the mode abstraction
Date:   Tue, 31 Jan 2023 17:30:04 +0100
Message-Id: <a13b7ea0d9499a0185aad407c48350503d52344c.1675181734.git.bristot@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1675181734.git.bristot@kernel.org>
References: <cover.1675181734.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In preparation to the hwnoise tool, add the mode abstraction
to the osnoise tool, so it can have multiple operation modes.

Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 tools/tracing/rtla/src/osnoise_top.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/tracing/rtla/src/osnoise_top.c b/tools/tracing/rtla/src/osnoise_top.c
index 76479bfb2922..d7bbd73e1a78 100644
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -14,6 +14,10 @@
 #include "osnoise.h"
 #include "utils.h"
 
+enum osnoise_mode {
+	MODE_OSNOISE = 0,
+};
+
 /*
  * osnoise top parameters
  */
@@ -32,6 +36,7 @@ struct osnoise_top_params {
 	int			set_sched;
 	struct sched_attr	sched_param;
 	struct trace_events	*events;
+	enum osnoise_mode	mode;
 };
 
 struct osnoise_top_cpu {
-- 
2.38.1

