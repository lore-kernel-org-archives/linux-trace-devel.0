Return-Path: <SRS0=sU+T=WE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633BBC0650F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 11:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 392B32171F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 11:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s4BPUY6D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfHHLgl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 07:36:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39938 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728964AbfHHLgl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 07:36:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so2061093wmj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Aug 2019 04:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZVE9MkM3+rgyXnGA50GdIUxvP83aoS7qcBoYgdfabE0=;
        b=s4BPUY6DFB/5jiwrzjzKL/tTHCdRtdUbmLiHsLJ5qshNkjACuUh0us5b7ETcGQNy9e
         KMBvux/kzGmzW6MUO7gwz2B6+2/PF2DakYYpJWnLxJ8z3uFVY2dy625A1guXwe46GK7q
         qrBP1EX3p4EgdixTyjH4Ob0jq45Y32MOTP+jcWO14UpEFED31EGe6+JeMXg0fZ3Q25Mj
         MauUDx3rJC+XVtDQ5DKvu/P9WT15u8b/zjNnb60NHAxWdmcMATM7mAADP4v8Ni1qDq9e
         x2EcbabxK76N02YJaArSr0s8iYJ31kHsV/NrHNtnGvMjUf9MXt0qpHoQg0JYneabChZC
         EbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZVE9MkM3+rgyXnGA50GdIUxvP83aoS7qcBoYgdfabE0=;
        b=KD1DXEXYvktx7hmuHMrrs02Pv1keLPukT1vdIB+dzlz0eSRQ7VoQEf+KjtEf2DxI91
         Jg7Z6aWDyHNM0Hbrsu7PNYpX0UGLL+/TQsBeTBe7eH2p8XVRra0FfHp/wInAo9w5QUTR
         UdXOicvy37DyEZEncck4D1SvGsgYYhoIgtm3PT4me9RkL0Ypa6a60dV2CANUhBnoABt1
         zH/rhUDdx4AJltbmjcFJkUUXlVaQO/GKT42C8oAlfw0IDrCLAkMSxAvMV5Mof+qIyHhb
         zD9gfE85pQy/1SqPwWl1dXU14pQTXeNJWfxqRIlucKCEj4QRJbgNSVfq+q65JhkvMS9o
         9xKA==
X-Gm-Message-State: APjAAAVLrxpPK34rm0j3ngS9ECp7n5adJcZb/4xEKclNd7NlYcKXHmK8
        G3ojcX+WSw2AT5dkogSfI4iqd38XEuY=
X-Google-Smtp-Source: APXvYqwJN2QvzLKEfhYBDKeObtTF7ZVsRYqfRuQ29Ie9w7QBDnBXwi9hXbXeRsb2kX6ziNU6gwTahA==
X-Received: by 2002:a1c:f009:: with SMTP id a9mr3855251wmb.32.1565264199822;
        Thu, 08 Aug 2019 04:36:39 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l16sm5127992wrt.31.2019.08.08.04.36.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 04:36:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] tools/lib/traceevent: Man pages fix, rename tep_ref_get() to tep_get_ref()
Date:   Thu,  8 Aug 2019 14:36:35 +0300
Message-Id: <20190808113636.13299-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808113636.13299-1-tz.stoyanov@gmail.com>
References: <20190808113636.13299-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tep_ref_get() was renamed to tep_get_ref(), to be more consistent with
the other tep_ref_* APIs. However, in the man pages the API is still with
the old name. The documentation is fixed to reflect the actual name of the API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../lib/traceevent/Documentation/libtraceevent-handle.txt | 8 ++++----
 tools/lib/traceevent/Documentation/libtraceevent.txt      | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-handle.txt b/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
index 8d568316847d..45b20172e262 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_alloc, tep_free,tep_ref, tep_unref,tep_ref_get - Create, destroy, manage
+tep_alloc, tep_free,tep_ref, tep_unref,tep_get_ref - Create, destroy, manage
 references of trace event parser context.
 
 SYNOPSIS
@@ -16,7 +16,7 @@ struct tep_handle pass:[*]*tep_alloc*(void);
 void *tep_free*(struct tep_handle pass:[*]_tep_);
 void *tep_ref*(struct tep_handle pass:[*]_tep_);
 void *tep_unref*(struct tep_handle pass:[*]_tep_);
-int *tep_ref_get*(struct tep_handle pass:[*]_tep_);
+int *tep_get_ref*(struct tep_handle pass:[*]_tep_);
 --
 
 DESCRIPTION
@@ -57,9 +57,9 @@ EXAMPLE
 ...
 struct tep_handle *tep = tep_alloc();
 ...
-int ref = tep_ref_get(tep);
+int ref = tep_get_ref(tep);
 tep_ref(tep);
-if ( (ref+1) != tep_ref_get(tep)) {
+if ( (ref+1) != tep_get_ref(tep)) {
 	/* Something wrong happened, the counter is not incremented by 1 */
 }
 tep_unref(tep);
diff --git a/tools/lib/traceevent/Documentation/libtraceevent.txt b/tools/lib/traceevent/Documentation/libtraceevent.txt
index d71fc61ea759..7a3310168ef6 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
@@ -16,7 +16,7 @@ Management of tep handler data structure and access of its members:
 	void *tep_free*(struct tep_handle pass:[*]_tep_);
 	void *tep_ref*(struct tep_handle pass:[*]_tep_);
 	void *tep_unref*(struct tep_handle pass:[*]_tep_);
-	int *tep_ref_get*(struct tep_handle pass:[*]_tep_);
+	int *tep_get_ref*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_flag*(struct tep_handle pass:[*]_tep_, enum tep_flag _flag_);
 	void *tep_clear_flag*(struct tep_handle pass:[*]_tep_, enum tep_flag _flag_);
 	bool *tep_test_flag*(struct tep_handle pass:[*]_tep_, enum tep_flag _flags_);
-- 
2.21.0

