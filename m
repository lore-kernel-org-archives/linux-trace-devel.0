Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2550C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 09:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbiANJV3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jan 2022 04:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbiANJV3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jan 2022 04:21:29 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCCCC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 01:21:28 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id k15so32596250edk.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 01:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0SM6VN1pPtxZVWfvCtQKVWT5HJBzm8ezb/2KuPJkb7g=;
        b=Vd2QJE39Gvt+Q10GMitIo0eSGaBtUWv0zz0cCuIDXKvuxSECXRGPwUFJ0xFnkPIfFS
         WCp82s7jQUg2lGKu/3Mb1+2L9hGDNo6ZvqYUg471Qv4ao9dmhyWfvzJE6VTFJg4eRmx3
         pxz9uwN1dPL8BlgqjgkTYqOp7TAFvgyCaoHN6YSNznzzho8FDEzQhAqopzpIkA99KBSC
         ZUxNYp1w8Bd+rpZgQ56UqNRLe6xiOaukI7AIg+xGQFhk+pbgjWR64K+y6lk5Qi3kUFe6
         wnB7oGaOsVgn2fRbTixxFRZ2cOVFjlMalGHVSm1Ms6AGwfVo3IdrSdHOVdQtTZixQLhN
         stoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0SM6VN1pPtxZVWfvCtQKVWT5HJBzm8ezb/2KuPJkb7g=;
        b=8B0BF/DiXnE2eNmw0/qjsUeJMzDeugNZjZ97TO8QYt4PtoAs/Gg7arKoxk4BOqaexP
         cqiwa2twEOec6uTYVlGX9aaCJ7Y26YBBxnJF2hgBUdJoqNFgd1qumDvVs+piho/v6jq9
         GBeRheRz/ta49n8ngvIHYuClKPgq8FcJeDUdqkMY602HgzCJrbKQetR1q8dSWhm2qj0c
         wPhGgp7NX33fHLFG7LoUdR2xmq9S5hFMLOXATJH2BSQUlfBoiCJ10TdqfJ9aajymweMd
         6xtfKMmvLB4oYFzI6DoWiF37DQD1VJ2tpXmz4zse3no3olUHzM5BLRSoTSEiByjhLz1c
         SZ6w==
X-Gm-Message-State: AOAM531wxRQMg0MWCvR0IN1n4hwhzsh0bzet3xNfA5sJvGHTqV9A7cNq
        To2qBCW1Heg9GeiLCPfaHnWhB8QqjCg=
X-Google-Smtp-Source: ABdhPJy02xotjm2qrpRfpdUUx46F4AmIw92oFUTccilvlqZTKy6mM/+4N4konyEqpZrTyph6m1pTwg==
X-Received: by 2002:a17:906:af82:: with SMTP id mj2mr6507591ejb.33.1642152087188;
        Fri, 14 Jan 2022 01:21:27 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id nd36sm1657313ejc.196.2022.01.14.01.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 01:21:26 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Fix potential segfault in free_plugin()
Date:   Fri, 14 Jan 2022 11:21:07 +0200
Message-Id: <20220114092107.100521-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The 'handle' field is not guaranteed to be initialized, hence a check
is required before closing it.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index 09886ce..2eb3b4a 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -219,9 +219,10 @@ void kshark_free_draw_handler_list(struct kshark_draw_handler *handlers)
 /** Close and free this plugin. */
 static void free_plugin(struct kshark_plugin_list *plugin)
 {
-	dlclose(plugin->handle);
+	if (plugin->handle)
+		dlclose(plugin->handle);
 
-	if (plugin->process_interface){
+	if (plugin->process_interface) {
 		free(plugin->process_interface->name);
 		free(plugin->process_interface);
 	}
-- 
2.32.0

