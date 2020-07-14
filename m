Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC970C433EA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C2A20BED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nk//qT8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgGNKaj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgGNKai (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 06:30:38 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DF3C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:37 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so16465204edq.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y5xYHlZaenBpAihzHiusowYFtEoBissY7NChgzs8s38=;
        b=Nk//qT8uTQbKJPF3AveJrxeku4HI4WKE+7yuF9WLoPNtLJ6Bv0uTDjsDXF/188szDU
         dZYYvKOw3deE//UdkcFQJ05JSPjA/bzDrOuuReSMIneFpcCqu42iNtfiSc7H4mqqGkaF
         BCEKQDg92ebkW4s5wnd/zCzHs9NOPBpjnRGQAV8D4DaU4yQsPxmzRB8A/ldJtZfVdLNS
         9+nLN9rroiPHB3ZKOwA+w4pu9MOTmNaZU9ZP1OR0i3XQvDjRdrDm/wkp5+aSeQV/R8qs
         8Vixto8XypcojmRFWJ00vWAaQZf0DeBhkhzGdoMc1+2wjHPXuApcw82+XnoIC3hd2Rtd
         P8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5xYHlZaenBpAihzHiusowYFtEoBissY7NChgzs8s38=;
        b=M1fDDzX1Nqm0WqhJG1C5xU4VGElrVswrULTRxZxr0OBaWPUDlfOMSwQhlf6PsmzmmF
         4ElxUcCo3JcZCiLmlM4t+CKP+Q4DFd7ZX2d6HPYKvNpsykpMU5tBuoh3+ezijtNyd6UH
         S1EaHSA5IEkkQlpNWXsNQzsANEZ3h39jTP+7gblbWiMIy80D6bLsyrYrnmEcg5K3+lbl
         xPTiWbdDhv86tTg6ElRB70U+tZB43Ur+IUdxWWJCnlKjaxaD2TrQJWjmR+sV3utazPr9
         ayckiRYWw1Y2qq1nbGTYlkFIsUraeChLXJCHdmp1P2HE84q9ndueqhTFCLrKefyal+4s
         URCw==
X-Gm-Message-State: AOAM532NomUaLw3UqyaOB0Vb1wgdTkVcuZuRyPiDq7OeSpwy8VpCUzau
        rK34mD2jh8pfRQqTkfapb1Y=
X-Google-Smtp-Source: ABdhPJx00TvlQAcEsHShRR1xGQgcD44FCeU9pwdHkomEHUvm45So7OZ69rFXVTKLj/DVq/4AwrOjZw==
X-Received: by 2002:aa7:c657:: with SMTP id z23mr3819633edr.265.1594722636555;
        Tue, 14 Jul 2020 03:30:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gr15sm11766034ejb.84.2020.07.14.03.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 03:30:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 5/8] trace-cmd: Fixed broken indentation in parse_ip4_print_args()
Date:   Tue, 14 Jul 2020 13:30:24 +0300
Message-Id: <20200714103027.2477584-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed the "break" indentation in a switch() inside
parse_ip4_print_args() static function.

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

