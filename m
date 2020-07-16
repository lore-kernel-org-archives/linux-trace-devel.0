Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FA7C433EA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCFE520656
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="riN24uS2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgGPJTe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgGPJTd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:19:33 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14DCC061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:33 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y10so5832001eje.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YB+l9zhv86xv+fYss7J+wAMHgg1JdGr8frVtOJgUuCk=;
        b=riN24uS2RM/jftAQxKQMSxGTIDBpo6Na8QxztuO9UuwuAsu2t4BNxGWNO+UzTdY17g
         Q3/DNnlGw/2VeUvO/wn39cWjtz0TZwMncki10ZHk23vvMSVjSOwWR0eUgkUPj/jGakbB
         XhvoDOO+V1pVEdLzvAr+R9IxWUQR990tIrQ1EgVfXQcZmvApDrnF7RHYwMPS0/zqyNTL
         daH69E7VOGGU9Gq7hGSWsx3jJay6CzUF/vqZZZCMGGm8FgUH2jQiKcCE9C8ajXpE3Id2
         CbGN95Dz1ilNjVBeWQIZ0tMRBTr2nKiZUEGq6OaF5zfI0UYnnuOdqAE1j+WyvOhaiRlt
         OH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YB+l9zhv86xv+fYss7J+wAMHgg1JdGr8frVtOJgUuCk=;
        b=D0ZnIthu4IC+vhSiOQN4JN6FHZ+n7UHKVFgygyvUb/fSHN5YexXEsVfF9Mvoj/VM2V
         5myUfyT4ChTccvH3AqLfu0ojFBy1HYnz7pzOpVUWDz7p8RphBmxXwFLG9+n3zo+uHT4k
         DxL6zdr/nYL6PRItWH+YZH8pnRDiz1iE4ry7ay88Wm2tEz9eDCtg2vU6+Y51/lGb2fE5
         9B14u7bb4wacSlBUHSGnq5/l/QmeyuoorQ3RqUh12tpmf5Syop3Cp0jrLiJmcKrVegCt
         2l60aYiUacWq0lXN7qUcc6OabTW/QDfedByjFkReqxzYJ/LYwqCpTs3bv5SizRFVp6pV
         UwFg==
X-Gm-Message-State: AOAM532yxlWhg+zs4c26s+NiPfn+oOtAI1SWiBLvaw0ZxADOVIm535e/
        zZzs7TZcBaAyP1uD8Iw3KiXCC47yR0s=
X-Google-Smtp-Source: ABdhPJw66YhnObuQ+P+DAsBsHR3gLggD437t2bIxJhI7PekIpKRXlZOIiBcBVVy+EIKFdUWnkYJqAA==
X-Received: by 2002:a17:906:4b59:: with SMTP id j25mr2728251ejv.301.1594891172498;
        Thu, 16 Jul 2020 02:19:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x9sm4431534ejw.28.2020.07.16.02.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:19:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/8] tools lib traceevent: Fixed broken indentation in parse_ip4_print_args()
Date:   Thu, 16 Jul 2020 12:19:20 +0300
Message-Id: <20200716091923.2613228-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
References: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed the "break" indentation in a switch() inside
parse_ip4_print_args() static function.

Link: https://lore.kernel.org/r/CAM9d7cjboXGg+iMOA4BQo=E01iLGcJNB1MyPJ4doPP1XeGVJRA@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-6-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index ee16be96697b..8ee83f1e4e01 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4633,11 +4633,11 @@ static int parse_ip4_print_args(struct tep_handle *tep,
 		else
 			*reverse = true;
 		ret++;
-	break;
+		break;
 	case 'l':
 		*reverse = true;
 		ret++;
-	break;
+		break;
 	case 'n':
 	case 'b':
 		ret++;
-- 
2.26.2

