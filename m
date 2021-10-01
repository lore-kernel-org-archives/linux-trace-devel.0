Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DD0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5717A61A58
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353474AbhJANfn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 09:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353417AbhJANfn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 09:35:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6C0C061775
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Oct 2021 06:33:59 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g8so35015044edt.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Oct 2021 06:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/WIocOx46HgtLA2MAA4Oxqaf3Pj2rly+XfLWcKZmA8=;
        b=LOUXX6lQof8Qr87Z2fpW9r61R0msdxgE80ElVmOGClvOsAVUC7uRgil0dXRZTNK465
         gYOBu2VhCtEXwMwRHSi5KeLTEsGt5wz39y2/bAQICrK65TcxX9i41V8ixwm6h62RI/OG
         OnoY0T2eHXUgi+YXwCjAk4eNtwuSiBud+aECVrCiQfPlPmV20NTQRpeLWwa8tqWu55Os
         CayChUv0tD49vUsRp7Ont4+BhhK4+dCBrzNJXxRfhZHOWQfHqDwkC7XA77NC5FltHQog
         +mpa4PdSZEgRu4qxElpiHLA6wWV5pTl1gqy7V0ZyQ4OpNwrvjg86JpWy/Lpz0TJDH+TK
         qjwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/WIocOx46HgtLA2MAA4Oxqaf3Pj2rly+XfLWcKZmA8=;
        b=oJzvA4jejV5mIu2w0hUNoLK1BVnVBf1+tjvz+0MhNg8e/fBVbX0SmW4qD40BUuZAip
         l7KQwnDAV4UlBimtfAyf2hbgJMBY+YHyLFJuh6VM7UVJNTgXptcsLuTdE0taXcgkYRMj
         xzIXknfD6LcHfB1cEGqaAQiu7i1zHiM+oz9j1MgdmGd57ym7oGvnGgzAWfhN74MC0R6g
         7xaP6cndFwuD5jrZICCjrganDN1so56MmkF32o+mAz2CrKyIf4Vqed1evMkReJCZQq/5
         YloiZYyxz664XYb4bTqWgvDaoSveRoziH6quBSDvP2o+RPEnVpIyKWGWelgq02DBRF3w
         UWyA==
X-Gm-Message-State: AOAM532bsZK86cLG9vFN/qa9T22DzupDNkduTijfwiMG/kVWCwh3DHPu
        hOe1y+U48fHxOyP0gRFXrtTfkAnKH5Y=
X-Google-Smtp-Source: ABdhPJy+YKSDY87cbqSKlLidHe6d0Yl7TG5vUpvxIO/vTfIC3crv46eJGQ8eu4rP3z5KwTu5mhWCZA==
X-Received: by 2002:aa7:c484:: with SMTP id m4mr14516023edq.123.1633095237478;
        Fri, 01 Oct 2021 06:33:57 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id ne24sm2993250ejc.46.2021.10.01.06.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:33:57 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/5] trace-cruncher: Correct misleading error message
Date:   Fri,  1 Oct 2021 16:33:44 +0300
Message-Id: <20211001133346.8217-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001133346.8217-1-y.karadz@gmail.com>
References: <20211001133346.8217-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Indeed, the callback function can be included from a plugin, but this
is an option. In the default case it will be searched in '__main__'.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index e49132d..b0f5e0e 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2039,7 +2039,7 @@ static PyObject *get_callback_func(const char *plugin_name, const char * py_call
 	py_func = PyObject_GetAttrString(py_module, py_callback);
 	if (!py_func || !PyCallable_Check(py_func)) {
 		TfsError_fmt(NULL,
-			     "Failed to import callback from plugin \'%s\'",
+			     "Failed to import callback from \'%s\'",
 			     plugin_name);
 		return NULL;
 	}
-- 
2.30.2

