Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70811C433FF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C312083B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p2At8EAI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725265AbfHNIrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38172 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfHNIrR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id m125so3706755wmm.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QvmxyWqmUQd8fxBfL1GhY95N+po7FL6ZZAgEaHx8R/4=;
        b=p2At8EAICj+u+HpR9brP2SVCJGa+kZfiNIwiNzDoInNJchAWDFDx1yaZR1HULSYkGs
         XJlVd++mYGySDHArqg2yTb+cahtlc27DTzkyB1+SJQGetDTzcCz97LhnX++Ow8rIDYNy
         6ibblgfYy/+ohH2DXpVzvqwHUS7A4urvnRMtqiELYn7M6oN8IkmnM+YLegzBWjsbGJOR
         +KAMlJWTObfQBI70IvNyIy8Ab+ic4A4h9FB8WH1kvBMJNAnfs5LFu96RU15VLYHBEObi
         zdkR8h6GnuVZ8ZD6eJPQLlnDi2gKxzdsRMgBJ9LeELSiAkZmaayd/zwcDde/9xnlp+Ms
         0Stw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QvmxyWqmUQd8fxBfL1GhY95N+po7FL6ZZAgEaHx8R/4=;
        b=keHkY19Hog+RaX0fF/Uob6+VeMGPcxBGY+uHYWZYbtBQtKUiFImSW8ug9gn1t6sktp
         RJD0/A+irY5gtqD5zlUH3TSgeFuA6FbrzNvcr19TBXB02/lDE+LmsackjeTO5Ce78US3
         S0nZCgZDbiORGqDtzTqHIgm+oPhyF3BSywzE1Lb+CguILzAfP6HsmdBzi2NGYmLOMFEF
         40vaftKgnmHRAiylm4ZVAzluL0+SXoL3iAeIHdd+OgaBWDU20GjFRABpQZ6wvF1R3TgM
         K3LlDN5YanBuyEtAaPdwGDbzQ3phORVk3pWXYRQECOxLDzFu0oeqOKfOTJe/dZnPD5Sn
         QNkA==
X-Gm-Message-State: APjAAAWJGQXecTUNRXCXpWM7lmBK5Cmlz8jYF1CQ7DsUu5PnRE8khms8
        PQhnCguOMurHBj6z6Lya5pafIIz4+3I=
X-Google-Smtp-Source: APXvYqweLugiBZRcaiNSSaseG5AV08l4iXpQIsImxX8P5lulk2GQLtl7yheXVMOO2VnKiOJLj27GVg==
X-Received: by 2002:a05:600c:144:: with SMTP id w4mr7553237wmm.94.1565772436553;
        Wed, 14 Aug 2019 01:47:16 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/8] trace-cmd: Move trace-cmd-local.h from the application to the library
Date:   Wed, 14 Aug 2019 11:47:01 +0300
Message-Id: <20190814084712.28188-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd-local.h file is used by trace-input.c, trace-output.c
and trace-msg.c files. The first one is part of the libtracecmd library.
The others will be moved to the same library, so this header file should be
part of the library too.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 {tracecmd => lib/trace-cmd}/include/trace-cmd-local.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename {tracecmd => lib/trace-cmd}/include/trace-cmd-local.h (100%)

diff --git a/tracecmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
similarity index 100%
rename from tracecmd/include/trace-cmd-local.h
rename to lib/trace-cmd/include/trace-cmd-local.h
-- 
2.21.0

