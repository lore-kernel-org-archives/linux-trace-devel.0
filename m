Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24601C433E5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F391A20663
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWH5GdYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGOCaU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgGOCaU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:30:20 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D91C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:20 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id w6so550598ejq.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nch44c7YYpCqbj3D3m+rwVDaxOb+MtyHnzJjYg3W66Y=;
        b=LWH5GdYzD9Vg0IQe4Cq0lxeiLHVo02Kzd5jdAtLlHHjuHaxG5hp2xMpZBJ1N2fOGlW
         s8uDHGcvlYeLrcKl3qqrdwxTjy6kIqUxrE70si6RoNHJ8qZ2IwWazR1vITdDXqJtbhwU
         KFB7yuj9IMxahDeDnx0Uu3msO8cOClneK67sBt5B267lNDA/1a32I8TxrFYFpHhTN/4c
         r2RvtbSqIf6kV6sc9fRr1BFsh0t0Z3vGil+b5f9NHkDiZN7z+NW7T/jc/lJyzcJVzDFE
         Mbz+vrioQouBeyWlyY5yap/DQl1s1WoSbgXJyefVx28YVCiRsm3WtBeG8bePKmW34rTP
         HQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nch44c7YYpCqbj3D3m+rwVDaxOb+MtyHnzJjYg3W66Y=;
        b=B8pJnNwxkDy53ZhrL+SVYYHMCYYkzbSBS+14jl6PPkXjrFsFC/pRZJMnmDlywJ8sw+
         2WR2IDwgPMP7nUZdN5EJ9Hev+jQjKJpk5TgCBvYlbFThGe8+CblPKIBjvsiFNqpuERfC
         B3UMinoU8uOozhjxsHOlp7lCL4u4sMdGr8dSgocarCWA9Z80g+5KnnmXh8i3np4wKq4K
         zUVoQk9qABR0DIDFODNicwh13HWqgnzYFayWjvUYf8t9bPR96EDABu6R/TIoqZ8UjP+n
         nyFFWk8v6gdr+x54tJKS2B3wcsZZAZ9cVaPd+NeEaepvYdovKQAwhNCcwEqKjabW2jvx
         1LSA==
X-Gm-Message-State: AOAM530IM2aH6mYX/4VVpJxSWQnAjJ2OyV7Dly8M/mv1AD1MG6QHYu+P
        61Vmlx2UFu+Qm1hRGC8D4WFwykLW+O4=
X-Google-Smtp-Source: ABdhPJykXXn7NU4wktBkmudEBQzKC5EdZftDkdv0bQ+W0FPHdOhhzzMWdYrp6pvisaeTy5Hq18Gorw==
X-Received: by 2002:a17:906:1a54:: with SMTP id j20mr7054983ejf.455.1594780218972;
        Tue, 14 Jul 2020 19:30:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d24sm576474edp.83.2020.07.14.19.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 19:30:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH v2 5/8] trace-cmd libtraceevent: Fix broken indentation in parse_ip4_print_args()
Date:   Wed, 15 Jul 2020 05:30:06 +0300
Message-Id: <20200715023009.2503879-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed the "break" indentation in a switch() inside
parse_ip4_print_args() static function.

Link: https://lore.kernel.org/linux-trace-devel/CAM9d7cjboXGg+iMOA4BQo=E01iLGcJNB1MyPJ4doPP1XeGVJRA@mail.gmail.com/T/#u
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 77c32492..4de9729c 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -4680,11 +4680,11 @@ static int parse_ip4_print_args(struct tep_handle *tep,
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

