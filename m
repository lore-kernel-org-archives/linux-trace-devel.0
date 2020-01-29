Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4FFC33CB2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02ED020708
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVcLVpb1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgA2Jy1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:54:27 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34848 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA2Jy1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:54:27 -0500
Received: by mail-lj1-f193.google.com with SMTP id q8so13625498ljb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 01:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Wx2itv63TNQ95G94I0G+2QREqju3y9Hf8DA5s7wV3o=;
        b=DVcLVpb1eZjMh+1k+xUgJs5gn/qXux3FkMDTIb/rom6D9qEU+QkBRq4YXjSEofmbxg
         LAj0zpuT0jwko6Sur2Xvxf1UBVS03+f+iGgP68GR3Wt/xXr61fcwkrau5zZLN2052OVF
         i+hcmEG47rUaebWHCb4UnsU0JZhKUqnVlPdeuuLyGsIzuUQ/Ws4RhB2K5mKRjGS/kQ/6
         1JWbnDmtSEgh4rfWt8MKZaKflXeyxGl/LYqQQ51mFXn06w53OlHp3o/CbPTF848VloSK
         JnMEOa6ZlqWXPQ2UNYTZem18iBQqiSrY9J0LP93XKMWsEmmHqypwS07O4pb+FixecADa
         qmcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Wx2itv63TNQ95G94I0G+2QREqju3y9Hf8DA5s7wV3o=;
        b=a3NwXI8Y+YWpTi00wJCF42Mqofc+UrAiEiVJgEdBn2qgPTdB/a28+PaIVq+hCAwhIa
         c5Uz6TJ3coXa3NyLH4qiBd+kelQ+2FQ8mRwDbI5MKo6Vs8aKh8t0ngzRl8wrrvGZnXIL
         O93uSC/OlsIiwpr/dznZ3L8P9kAEcY3oLWep/rp5182NV5KRKgoZ0n8Xijdp0DiQpRig
         UmY0fX8A6lxwMX3yTjSBODaSMKC/mB8l4Xam8lllGW8S+0mhZBYFQ2PijVeniUm7pnNG
         rdo4Tvo816IKm3I4DQoVcK3SyMiZE4LtF7s29CPKGPYr3PaT5AbLEwizXZZ/wRKTtV93
         1dcA==
X-Gm-Message-State: APjAAAUXBiN4oZiN8IsIJwsxM/o2YDYdIkbEa9Dh8adX7UHV9ZJTyi4T
        3//G3BduDK4rHJABDPVO7TchQsog
X-Google-Smtp-Source: APXvYqxVJ3JO2wojb0EX+IN/LDoycZ7yGCJpRug0QQVDtJlxyP9G6H2kvR261mitAGsdLIHNN/Ab9g==
X-Received: by 2002:a2e:9955:: with SMTP id r21mr15512937ljj.283.1580291665612;
        Wed, 29 Jan 2020 01:54:25 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q10sm648584ljj.60.2020.01.29.01.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:54:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/9] trace-cmd: Remove tracefs_read_page_record() API
Date:   Wed, 29 Jan 2020 11:54:14 +0200
Message-Id: <20200129095421.881786-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129095421.881786-1-tz.stoyanov@gmail.com>
References: <20200129095421.881786-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This function is used only internally in the library, it is
not exposed as an API. Its declaration was left by mistake in
the trasefs.h file, as official library API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index bd3f732..85690b6 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -34,9 +34,6 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 char *file, int *psize);
 
 /* events */
-struct tep_record *
-tracefs_read_page_record(struct tep_handle *tep, void *page, int size,
-			  struct tep_record *last_record);
 void tracefs_list_free(char **list);
 char **tracefs_event_systems(const char *tracing_dir);
 char **tracefs_system_events(const char *tracing_dir, const char *system);
-- 
2.24.1

