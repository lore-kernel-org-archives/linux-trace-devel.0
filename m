Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59BBC433E4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 927CA206C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q27FqhP0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgGPJUZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgGPJUY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:20:24 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C81C061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:24 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n2so4235200edr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YB+l9zhv86xv+fYss7J+wAMHgg1JdGr8frVtOJgUuCk=;
        b=q27FqhP0ln7RUVByNycnfS5/p3Zoi6zz6SRlqncHiWBJQN9goHfHiDht+BMWK7555Q
         5sUA+b0sDFjtESoErAzI5hKFqqhkYHAD7H/yPWISZPsry/HnbOR/nnqHa01ZEITKzYrK
         r2xmRPHwpCHvcK061QVkjlZMDafYPafWUjKlBgVPdbZq74xwcx/EpMYPtc+svxraCJ4K
         7qLYxEh+eRYBnhYoKA66J0akB1Gi8iGOO3oUbzOdpAHHZNVDMqFfu+6O2Ue/jyqU/7tZ
         FM4ZHNpwkH+gKyY0aXmBHfuPpkrVeW5jwPOHhtWr9Ins/pOW+1/tsMe4uUwoTwa/286Y
         Aibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YB+l9zhv86xv+fYss7J+wAMHgg1JdGr8frVtOJgUuCk=;
        b=C9U++k9AdN6gbksj8GjVXGTMZgj/oMx2QF0KO/RRRC/Lat8EpG70ynpN/smaxSWpn/
         RHiIkiYclJCqH5aq/hJckV8B+h9WeO8ldbiwSqXMI2K4Z6yP+nOL+zs9ZWBs68zqghv2
         CK/q8vbYlEe36GAxoMvdQsuqLQzjCAuxbu680EnqEiK4qbJlPP16ZqnbnOt2ko9XxLG8
         vYT10hLB64EFbRnJEMNoJEvjIU1JPcY3O1VtVuT7PJszKA+0Uh3wjredkGlU2PEUgqfq
         t+PBQgB1L3DaO4b3CHXzlMBdc5gzs6a3U/wRc6gmCgTpVjFrjsR7RU1X5SA57eazlcix
         zGAg==
X-Gm-Message-State: AOAM530J1TSxSYlf+JgdELOG3lpTuvLE5k9zxz07XUQDimjQe276Gkx+
        1Z1BJjEMT8/Hrg4xVnta8Lo=
X-Google-Smtp-Source: ABdhPJwsMY6tfJwjZpc15ERt86N6Ya2ySzuSjzXO1eKClUaJT6cmweypapS7XpD6rxTS2cEUxnU7xg==
X-Received: by 2002:aa7:d142:: with SMTP id r2mr3441792edo.211.1594891223394;
        Thu, 16 Jul 2020 02:20:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y1sm5129117ede.7.2020.07.16.02.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:20:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 5/8] tools lib traceevent: Fixed broken indentation in parse_ip4_print_args()
Date:   Thu, 16 Jul 2020 12:20:11 +0300
Message-Id: <20200716092014.2613403-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
References: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
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

