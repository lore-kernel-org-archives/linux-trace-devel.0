Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369B7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 13:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiBWNLH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 08:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiBWNLG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 08:11:06 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32D197B96
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 05:10:37 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s24so37651253edr.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 05:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NWbTsutxTV7KrJxLrOztaMFzJkz+48L3U6gjrc1pKjA=;
        b=APJ02cNy0sjbWEF4nEhtOa+MjetyivKYhItWETxdyThbFjb6PqrkNKbHSkz87yJ1pi
         HvY+cTDoKZDrZM8qEkEn5/QwgFdEw506V7fjL874JaAf7AQyspRUUXYfuPQSGv94d2o9
         SVI/0VPHRypT9nb+ybum0PUSjrUvoHVW2uitBlgSDT62yEAg9z8zatg/l0uwY4aTdW6f
         HRAlc7KsPFxLk/hod7HyPxe58i3AOPuVjlqYNk+KGJvr6ps/CzOuz49qGhKOemFwc7UJ
         n+kL3a2XjkiG0kt4CBQVD+1gMALeSs64EkKk+uKErTw8+PYhzyxnJE0gjpitDioPsKnM
         id1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NWbTsutxTV7KrJxLrOztaMFzJkz+48L3U6gjrc1pKjA=;
        b=UerwVtBmz44bElKIsGVu1tLo8jEoJY+Aq6nyQurzr82K89A4efoDAtbjKR9a6OEedy
         7fsXqeUCkRJXbUjltbgPr/5QR9V3v5AbAC701mVz9ppn8722bDSa7Ypx9cthQLJppkg/
         Eaf2Pwkc+Aclw7k7KwHtsiGeUBubIOr3Iix9nkcY2NOhtTgL1zVnAAUw0rQe5aQ8KoYK
         S8y88p4jSgGFWN0AIv6VaKsWX+EGwkMKIkR66r15VjIPrVoEh5amn8luPBRh8YYzKIw0
         L581l0NxHRdv7WS8KBmE/obAQzn1spvMpq6K5Dly0d9HgWEBffII0eFXbKBHXaUZYtrj
         Ysmg==
X-Gm-Message-State: AOAM530AAFgpKI5iCJ1FT+keR5vvecCdc96eOzzZ6yGRAbaOahO/MsS8
        5xxzVMVLa+WCc/JasbLPE+q3wRVCbME=
X-Google-Smtp-Source: ABdhPJxm2iHeZgaZ5hAQvXvBgstQCj8ltT9aSNauNQO7uvXfydTwdkOhaXLZE3fLKVcHFfOKCvgA8Q==
X-Received: by 2002:aa7:d403:0:b0:40f:739c:cbae with SMTP id z3-20020aa7d403000000b0040f739ccbaemr31912092edq.267.1645621836157;
        Wed, 23 Feb 2022 05:10:36 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id qo12sm7420402ejb.79.2022.02.23.05.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 05:10:35 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Add error handling to PyTep_short_kprobe_print()
Date:   Wed, 23 Feb 2022 15:10:23 +0200
Message-Id: <20220223131024.62332-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The return value of the libtracefs API used internally has to be
checked and an error message printed in a case of an error.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 85f5bbc..e8411ae 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -632,8 +632,13 @@ PyObject *PyTep_short_kprobe_print(PyTep *self, PyObject *args,
 
 	ret = tep_register_event_handler(self->ptrObj, id, system, event,
 					 kprobe_info_short, NULL);
+	if (ret < 0) {
+		TfsError_fmt(NULL, "Failed to register handler for event %s/%s (%i).",
+			     system, event, id);
+		return NULL;
+	}
 
-	return PyLong_FromLong(ret);
+	Py_RETURN_NONE;
 }
 
 static bool check_file(struct tracefs_instance *instance, const char *file)
-- 
2.32.0

